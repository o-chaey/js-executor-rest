package io.github.daniil547.js_executor_rest.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class ReflectionUtils {
    private ReflectionUtils() {}


    public static Object invokeGetter(Method meth, Object on, Object... withArgs) {
        try {
            return meth.invoke(on, withArgs);
        } catch (IllegalAccessException e) {
            throw new AssertionError("Getter illegal access wasn't accounted for", e);
        } catch (InvocationTargetException e) {
            throw new AssertionError("Getter throwing wasn't accounted for", e);
        }
    }

    public static Method getDeclaredMethodOrThrow(RuntimeException toThrow,
                                                  Class<?> declaringClass,
                                                  String methName,
                                                  Class<?>... args) {
        try {
            return declaringClass.getDeclaredMethod(methName, args);
        } catch (NoSuchMethodException e) {
            throw toThrow;
        }
    }
}
