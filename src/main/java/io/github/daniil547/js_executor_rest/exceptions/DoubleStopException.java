package io.github.daniil547.js_executor_rest.exceptions;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.UUID;

public class DoubleStopException extends RuntimeException {
    public DoubleStopException(UUID id, LanguageTask.Status status) {
        super("Task " + id + " is already " + status);
    }
}
