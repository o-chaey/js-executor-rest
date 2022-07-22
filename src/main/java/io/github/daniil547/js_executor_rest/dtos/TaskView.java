package io.github.daniil547.js_executor_rest.dtos;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.swagger.v3.oas.annotations.media.Schema;

import java.util.UUID;

@Schema(title = "Task")
public record TaskView(
        UUID id,
        String source,
        LanguageTask.Status status,
        String output
) {
}
