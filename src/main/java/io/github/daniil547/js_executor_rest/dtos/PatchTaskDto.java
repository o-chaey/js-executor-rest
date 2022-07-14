package io.github.daniil547.js_executor_rest.dtos;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.swagger.v3.oas.annotations.media.Schema;

@Schema(title = "PatchTask")
public record PatchTaskDto(LanguageTask.Status status) {
}
