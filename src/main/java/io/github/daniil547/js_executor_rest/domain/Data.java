package io.github.daniil547.js_executor_rest.domain;

/**
 * Sum type (tagged union) of String and byte[] for
 * input and output of {@link LanguageTask}s.
 */
public sealed interface Data permits Text, Binary {
    static Data of(String text) {
        return new Text(text);
    }

    static Data of(byte[] bytes) {
        return new Binary(bytes);
    }
}


