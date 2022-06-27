package io.github.daniil547.js_executor_rest.exceptions;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.UUID;

public class NotRestartedException extends RuntimeException {
    public NotRestartedException(UUID id, LanguageTask.Status status) {
        super("To execute a task that is " + status + " you have to restart it first");
    }
}
