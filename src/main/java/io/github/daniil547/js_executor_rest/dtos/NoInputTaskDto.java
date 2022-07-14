package io.github.daniil547.js_executor_rest.dtos;

import io.swagger.v3.oas.annotations.media.Schema;

@Schema(name = "Task")
public record NoInputTaskDto(String source) {
}