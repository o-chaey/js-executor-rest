package io.github.daniil547.js_executor_rest.exceptions;

import org.zalando.problem.AbstractThrowableProblem;
import org.zalando.problem.Status;

import java.util.Map;
import java.util.UUID;

public class TaskNotFoundProblem extends AbstractThrowableProblem {
    public TaskNotFoundProblem(UUID id) {
        super(null,
              "Task not found",
              Status.NOT_FOUND,
              "Task with ID " + id + " was either deleted, or never existed",
              null,
              null,
              Map.of("id", id)
        );
    }
}
