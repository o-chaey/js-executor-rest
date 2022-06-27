package io.github.daniil547.js_executor_rest;

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
}
