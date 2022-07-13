package io.github.daniil547.js_executor_rest;

import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@Configuration
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
                         .build();
    }
}
