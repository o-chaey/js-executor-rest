package io.github.daniil547.js_executor_rest.util;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

public final class ReflectionUtils {
    private ReflectionUtils() {}


    public static Object invokeOrThrow(Method meth, Object on, Object... withArgs) {
        try {
            return meth.invoke(on, withArgs);
        } catch (IllegalAccessException e) {
            throw new RuntimeException(e);
        } catch (InvocationTargetException e) {
            throw new RuntimeException(e);
        }
    }

    public static Method getDeclaredMethodOrThrow(Class<?> declaringClass, String methName, Class<?>... args) {
        try {
            return declaringClass.getDeclaredMethod(methName, args);
        } catch (NoSuchMethodException e) {
            throw new RuntimeException(e);
        }
    }
}
