package io.github.daniil547.js_executor_rest.util;

import org.springframework.web.context.request.RequestAttributes;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;
import org.zalando.problem.ThrowableProblem;

import javax.servlet.http.HttpServletRequest;

public class HttpUtils {
    public static HttpServletRequest getCurrentHttpRequest() {
        RequestAttributes requestAttributes = RequestContextHolder.getRequestAttributes();
        if (requestAttributes instanceof ServletRequestAttributes servletReqAttrs) {
            return servletReqAttrs.getRequest();
        }
        throw new AssertionError("HttpUtils.getCurrentHttpRequest() was called" +
                                 " outside the context of an HTTP request, which makes no sense and is a bug.");
    }

    public static ThrowableProblem internalErrorNoDisclose() {
        return Problem.builder()
                      .withStatus(Status.INTERNAL_SERVER_ERROR)
                      .build();
    }
}
