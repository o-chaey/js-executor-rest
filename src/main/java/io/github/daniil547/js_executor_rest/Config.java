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
import org.springframework.format.FormatterRegistry;
import org.springframework.hateoas.config.EnableHypermediaSupport;
import org.springframework.hateoas.support.WebStack;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Configuration
@EnableHypermediaSupport(stacks = WebStack.WEBMVC,
                         type = EnableHypermediaSupport.HypermediaType.HAL_FORMS)
public class Config implements WebMvcConfigurer {

    @Value("${task-execution.parallelism}")
    public Integer parallelism;

    @Bean
    public ExecutorService threadPool() {
        return Executors.newFixedThreadPool(parallelism);
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
