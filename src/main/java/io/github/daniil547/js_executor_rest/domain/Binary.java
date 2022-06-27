package io.github.daniil547.js_executor_rest.domain;

/**
 * {@link Data} variant, representing binary
 * input/output of a {@link LanguageTask}.
 *
 * @param bytes binary data
 */
public record Binary(byte[] bytes) implements Data {
}