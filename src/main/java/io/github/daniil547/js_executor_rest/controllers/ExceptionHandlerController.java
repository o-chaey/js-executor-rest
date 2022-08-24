package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParserException;
import io.github.daniil547.js_executor_rest.util.HttpUtils;
import org.graalvm.polyglot.PolyglotException;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.context.request.NativeWebRequest;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;
import org.zalando.problem.ThrowableProblem;
import org.zalando.problem.spring.web.advice.ProblemHandling;

import javax.annotation.ParametersAreNonnullByDefault;

import static org.zalando.problem.Status.UNAUTHORIZED;

@SuppressWarnings("unused")
@RestControllerAdvice
public class ExceptionHandlerController implements ProblemHandling {

    @Override
    @ParametersAreNonnullByDefault
    public ResponseEntity<Problem> create(final Throwable throwable, final Problem problem,
                                          final NativeWebRequest request) {
        HttpHeaders headers = new HttpHeaders();
        if (problem.getStatus() == UNAUTHORIZED) {
            headers.add(HttpHeaders.WWW_AUTHENTICATE,
                        "Bearer realm=\"JsExecutor\" " +
                        "scope=\"openid swagger\"" +
                        "error=\"invalid_token\"," +
                        "error_description=\"The access token expired\"");

        }
        return ProblemHandling.super.create(throwable, problem, request, headers);
    }

    @Override
    @ParametersAreNonnullByDefault
    public ThrowableProblem toProblem(Throwable throwable) {
        if (throwable instanceof AuthenticationException) {
            return ProblemHandling.super.toProblem(throwable, UNAUTHORIZED);
        } else if (throwable instanceof AccessDeniedException) {
            return ProblemHandling.super.toProblem(throwable, Status.FORBIDDEN);
        }
        return ProblemHandling.super.toProblem(throwable);
    }

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