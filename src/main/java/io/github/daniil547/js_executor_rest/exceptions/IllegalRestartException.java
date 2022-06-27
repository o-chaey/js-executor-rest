package io.github.daniil547.js_executor_rest.exceptions;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.UUID;

public class IllegalRestartException extends RuntimeException {
    public IllegalRestartException(UUID id, LanguageTask.Status status) {
        super("Task " + id + " is " + status +
                      ". You can only restart tasks that are FINISHED or CANCELED");
    }
}
