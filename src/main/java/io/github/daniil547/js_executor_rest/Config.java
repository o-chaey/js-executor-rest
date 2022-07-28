package io.github.daniil547.js_executor_rest;

import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.databind.json.JsonMapper;
import cz.jirutka.rsql.parser.RSQLParser;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.convert.converter.Converter;
import org.springframework.core.convert.converter.ConverterFactory;
import org.springframework.core.task.support.TaskExecutorAdapter;
import org.springframework.format.FormatterRegistry;
import org.springframework.hateoas.config.EnableHypermediaSupport;
import org.springframework.hateoas.support.WebStack;
import org.springframework.web.servlet.config.annotation.AsyncSupportConfigurer;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import javax.annotation.PreDestroy;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Configuration
@EnableHypermediaSupport(stacks = WebStack.WEBMVC,
                         type = EnableHypermediaSupport.HypermediaType.HAL_FORMS)
public class Config implements WebMvcConfigurer {

    @Value("${task-execution.parallelism}")
    public Integer parallelism;

    @Value("${task-execution.await-termination-for-ms}")
    public Long awaitFor;

    @Override
    public void configureAsyncSupport(AsyncSupportConfigurer configurer) {
        configurer.setTaskExecutor(new TaskExecutorAdapter(threadPool()));
    }

    @Bean
    @SuppressWarnings({"all"})
    // unused, result-ignored, redundunt type argument <Runnable> (which is the way it's defined in Executors)
    public ExecutorService threadPool() {
        return  // same as Executors.newFixedThreadPool(parallelism)
                // just declares a @PreDestroy method
                new ThreadPoolExecutor(
                        parallelism, parallelism,
                        0L, TimeUnit.MILLISECONDS,
                        new LinkedBlockingQueue<Runnable>()
                ) {
                    @PreDestroy
                    public void awaitTermination() throws InterruptedException {
                        this.awaitTermination(awaitFor, TimeUnit.MILLISECONDS);
                    }
                };
    }

    @Bean
    public ObjectMapper objectMapper() {
        return JsonMapper.builder()
                         .enable(MapperFeature.ACCEPT_CASE_INSENSITIVE_ENUMS)
                         .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
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

    @Bean
    @Primary
    public ConverterFactory<String, Enum> stringToEnumCaseInsensitiveConvFactory() {
        return new ConverterFactory<>() {
            @Override
            public <T extends Enum> Converter<String, T> getConverter(Class<T> targetType) {
                return newStrToEnumConverter(targetType);
            }
        };
    }

    private <T extends Enum<T>> Converter<String, T> newStrToEnumConverter(Class<T> targetType) {
        return str -> Enum.valueOf(targetType, str.toUpperCase());
    }
}
