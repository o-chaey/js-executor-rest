package io.github.daniil547.js_executor_rest.exceptions;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import org.zalando.problem.AbstractThrowableProblem;
import org.zalando.problem.Status;

import java.util.Map;
import java.util.UUID;

public class ScriptStateConflictProblem extends AbstractThrowableProblem {
    public ScriptStateConflictProblem(String message,
                                      UUID taskId,
                                      LanguageTask.Status statusBefore,
                                      String attemptedChange) {
        super(null,
              "Operation violates task lifecycle",
              Status.CONFLICT,
              message,
              null,
              null,
              Map.of(
                      "id", taskId,
                      "statusBefore", statusBefore,
                      "attemptedChange", attemptedChange
              )
        );
    }
}
