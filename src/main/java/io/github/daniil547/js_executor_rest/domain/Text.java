package io.github.daniil547.js_executor_rest.domain;

/**
 * {@link Data} variant, representing character
 * input/output of a {@link LanguageTask}.
 *
 * @param text character-based data
 */
public record Text(String text) implements Data {
}