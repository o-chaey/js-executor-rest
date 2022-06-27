package io.github.daniil547.js_executor_rest.dtos;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

public record TextInputTaskDto(String source, String input, LanguageTask.StreamType desiredOutputType) {
}