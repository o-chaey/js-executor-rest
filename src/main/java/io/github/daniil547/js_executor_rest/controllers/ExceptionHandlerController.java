package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParserException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;
import org.zalando.problem.ThrowableProblem;
import org.zalando.problem.spring.web.advice.ProblemHandling;

@RestControllerAdvice
public class ExceptionHandlerController implements ProblemHandling {

    @ExceptionHandler
    public ThrowableProblem toProblem(RSQLParserException exc) {
        return Problem.builder()
                      .withTitle("Bad request: bad RSQL filter query")
                      .withStatus(Status.BAD_REQUEST)
                      .withDetail(exc.getCause().getMessage())
                      .build();
    }
}
