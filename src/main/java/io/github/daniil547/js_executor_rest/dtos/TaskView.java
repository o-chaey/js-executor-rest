package io.github.daniil547.js_executor_rest.dtos;

import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.Duration;
import java.time.ZonedDateTime;
import java.util.Optional;
import java.util.UUID;

@Schema(title = "Task")
public record TaskView(
        UUID id,
        String source,
        LanguageTask.Status status,
        String output,

        Optional<ZonedDateTime> startTime,
        Optional<Duration> duration,
        Optional<ZonedDateTime> endTime
) {
}
