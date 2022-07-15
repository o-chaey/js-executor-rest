package io.github.daniil547.js_executor_rest.dtos;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.UUID;

public record TaskView(
        UUID id,
        String source,
        LanguageTask.Status status,
        String output
) {
}
