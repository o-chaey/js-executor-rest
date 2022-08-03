package io.github.daniil547.js_executor_rest.util;

import java.lang.invoke.MethodHandle;

public final class ReflectionUtils {
    private ReflectionUtils() {}


    public static Object invokeGetter(MethodHandle meth, Object on, Object... withArgs) {
        try {
            return meth.bindTo(on)
                       .invokeWithArguments(withArgs);
        } catch (IllegalAccessException e) {
            throw new AssertionError("Getter illegal access wasn't accounted for", e);
        } catch (Throwable e) {
            throw new AssertionError("Getter throwing wasn't accounted for", e);

        }
    }
}
