package io.github.daniil547.js_executor_rest.exceptions;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.UUID;

public class DoubleStartException extends RuntimeException {

    public DoubleStartException(UUID id) {
        super("Task " + id + " is already " + LanguageTask.Status.RUNNING);
    }
}
