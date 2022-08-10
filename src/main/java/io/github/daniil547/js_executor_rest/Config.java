package io.github.daniil547.js_executor_rest;

import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import cz.jirutka.rsql.parser.RSQLParser;
import io.github.daniil547.js_executor_rest.controllers.RsqlToPredicateVisitor;
import io.github.daniil547.js_executor_rest.controllers.SortToComparatorConverter;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.converter.ConverterFactory;
import org.springframework.core.task.support.TaskExecutorAdapter;
import org.springframework.data.util.Pair;
import org.springframework.format.FormatterRegistry;
import org.springframework.hateoas.config.EnableHypermediaSupport;
import org.springframework.hateoas.support.WebStack;
import org.springframework.lang.NonNull;
import org.springframework.web.servlet.config.annotation.AsyncSupportConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.PreDestroy;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@SuppressWarnings("unused")
@Configuration
@EnableHypermediaSupport(stacks = WebStack.WEBMVC,
                         type = EnableHypermediaSupport.HypermediaType.HAL_FORMS)
public class Config implements WebMvcConfigurer {

    /**
     * Determines the number of threads used the {@link Config#threadPool()} bean, mustn't be zero.
     * Positive values are interpreted literally: threads = parallelism, 0 < parallelism;
     * might be higher than Runtime.getRuntime().availableProcessors(), as the latter isn't constant.
     * <p>
     * Negative values are interpreted as a percentage of processors available to JVM at startup
     * threads = jvmProcs * (-parallelism/100), parallelism < 0
     */
    @Value("${task-execution.parallelism}")
    public Integer parallelism;

    @Value("${task-execution.await-termination-for-ms}")
    public Long awaitFor;

    @Override
    public void configureAsyncSupport(AsyncSupportConfigurer configurer) {
        configurer.setTaskExecutor(new TaskExecutorAdapter(threadPool()));
    }

    @Bean
    // redundant type argument <Runnable>
    // (which is the way it's defined in Executors)
    @SuppressWarnings({"squid:S2293", "Convert2Diamond"})
    public ExecutorService threadPool() {
        int threads;
        if (parallelism > 0) {
            threads = parallelism;
        } else if (parallelism < 0 && parallelism >= -100) {
            int jvmProcs = Runtime.getRuntime().availableProcessors();
            threads = (int) Math.ceil(jvmProcs * ((float) -parallelism / (float) 100));
        } else {
            throw new IllegalArgumentException(
                    "Parallelism must within [-100..-1] ∪ [1..Integer.MAX_VALUE], but was: " + parallelism);
        }
        return  // same as Executors.newFixedThreadPool(threads)
                // just declares a @PreDestroy method
                new ThreadPoolExecutor(
                        threads, threads,
                        0L, TimeUnit.MILLISECONDS,
                        new LinkedBlockingQueue<Runnable>()
                ) {
                    @SuppressWarnings({"ResultOfMethodCallIgnored", "unused"})
                    @PreDestroy
                    public void awaitTermination() throws InterruptedException {
                        this.awaitTermination(awaitFor, TimeUnit.MILLISECONDS);
                    }
                };
    }

    @Bean
    public RsqlToPredicateVisitor<LanguageTask> rsqlToTaskPredicate(
            @Qualifier("taskPropertyRegistry") Map<String, MethodHandle> propertyRegistry) {
        return new RsqlToPredicateVisitor<>(propertyRegistry);
    }

    @Bean
    public SortToComparatorConverter<LanguageTask> sortToTaskComparator(
            @Qualifier("taskPropertyRegistry") Map<String, MethodHandle> propertyRegistry) {
        return new SortToComparatorConverter<>(propertyRegistry);
    }

    @Bean("taskPropertyRegistry")
    public Map<String, MethodHandle> taskPropertyRegistry() {
        MethodHandles.Lookup lookup = MethodHandles.publicLookup();
        Method[] declaredMethods = LanguageTask.class.getDeclaredMethods();
        return Arrays.stream(declaredMethods)
                     .filter(m -> m.getName().startsWith("get"))
                     .map(m -> {
                         try {
                             String prptyNam = m.getName();
                             return Pair.of(prptyNam.substring(3, 4).toLowerCase() + prptyNam.substring(4),
                                            lookup.unreflect(m));
                         } catch (IllegalAccessException e) {
                             throw new AssertionError("", e);
                         }
                     }).collect(Collectors.toUnmodifiableMap(
                        Pair::getFirst, Pair::getSecond));
    }

    @Bean
    public ObjectMapper objectMapper() {
        return JsonMapper.builder()
                         .enable(MapperFeature.ACCEPT_CASE_INSENSITIVE_ENUMS)
                         .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
                         .disable(SerializationFeature.WRITE_DURATIONS_AS_TIMESTAMPS)
                         .build()
                         .findAndRegisterModules();
    }

    @Override
    public void addFormatters(FormatterRegistry registry) {
        registry.addConverterFactory(stringToEnumCaseInsensitiveConvFactory());
    }

    @Bean
    public RSQLParser rsqlParser() {
        return new RSQLParser();
    }

    @SuppressWarnings({"squid:S3740", "rawtypes"})
    @Bean
    @Primary
    public ConverterFactory<String, Enum> stringToEnumCaseInsensitiveConvFactory() {
        return new ConverterFactory<>() {
            @SuppressWarnings("unchecked")
            @NonNull
            @Override
            public <T extends Enum> Converter<String, T> getConverter(@NonNull Class<T> targetType) {
                return newStrToEnumConverter(targetType);
            }
        };
    }

    private <T extends Enum<T>> Converter<String, T> newStrToEnumConverter(Class<T> targetType) {
        return str -> Enum.valueOf(targetType, str.toUpperCase());
    }
}
