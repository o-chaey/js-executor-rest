package io.github.daniil547.js_executor_rest.exceptions;

import org.zalando.problem.AbstractThrowableProblem;
import org.zalando.problem.Status;

import java.util.Map;

public class PropertyNotFoundProblem extends AbstractThrowableProblem {
    public PropertyNotFoundProblem(String titleSpecifics,
                                   String resourceName,
                                   String propertyName) {
        super(null,
              "Bad request: " + titleSpecifics,
              Status.BAD_REQUEST,
              "Resource" + resourceName + " has no property " + propertyName
              + ". Consider checking for typos and/or logic errors in your code",
              null,
              null,
              Map.of(
                      "resourceName", resourceName,
                      "propertyName", propertyName
              )
        );
    }
}
