package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParserException;
import io.github.daniil547.js_executor_rest.util.HttpUtils;
import org.graalvm.polyglot.PolyglotException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;
import org.zalando.problem.ThrowableProblem;
import org.zalando.problem.spring.web.advice.ProblemHandling;

@RestControllerAdvice
public class ExceptionHandlerController implements ProblemHandling {

    @ExceptionHandler
    public ResponseEntity<ThrowableProblem> toProblem(RSQLParserException exc) {
        return ResponseEntity.badRequest().body(
                Problem.builder()
                       .withTitle("Bad request: bad RSQL filter query")
                       .withStatus(Status.BAD_REQUEST)
                       .withDetail(exc.getCause().getMessage())
                       .build()
        );
    }

    @ExceptionHandler
    public ResponseEntity<ThrowableProblem> toProblem(PolyglotException exc) {
        if (exc.isGuestException()) {
            return ResponseEntity.badRequest().body(
                    Problem.builder()
                           .withTitle("Bad request: bad script syntax")
                           .withStatus(Status.BAD_REQUEST)
                           .withDetail(exc.getMessage())
                           .build()
            );
        } else {
            return ResponseEntity.internalServerError()
                                 .body(HttpUtils.internalErrorNoDisclose());
        }
    }
}