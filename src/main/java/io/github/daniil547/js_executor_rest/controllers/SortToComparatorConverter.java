package io.github.daniil547.js_executor_rest.controllers;

import io.github.daniil547.js_executor_rest.util.ReflectionUtils;
import org.springframework.data.domain.Sort;
import org.springframework.lang.Nullable;

import java.lang.invoke.MethodHandle;
import java.util.Comparator;
import java.util.Map;
import java.util.Optional;
import java.util.function.Function;

public class SortToComparatorConverter<T> {
    private final Map<String, MethodHandle> propertyRegistry;

    public SortToComparatorConverter(Map<String, MethodHandle> propertyRegistry) {this.propertyRegistry = propertyRegistry;}

    // despite the suppression, in the future some task property might not implement Comparable
    // but this also would have to be dealt with by adding restrictions to the API docs
    // ("you cannot sort by X") or implementing Comparable for the property (or wrapper)
    // also instanceof check here messes up generics
    @SuppressWarnings("unchecked")
    @Nullable
    public Comparator<T> sortToComparator(Sort sort) {
        Optional<Comparator<T>> taskViewComparator =
                // sort is a collection of orders
                sort.stream()
                    // order is a singular sort clause
                    .map(order -> {
                        MethodHandle getter = propertyRegistry.get(order.getProperty());

                        Function<T, Comparable<Object>> keyExtractor =
                                task -> {
                                    Object valBehindGetter = ReflectionUtils.invokeGetter(getter, task);
                                    if (valBehindGetter instanceof Optional<?> opt) {
                                        valBehindGetter = opt.orElse(null);
                                    }
                                    return (Comparable<Object>) valBehindGetter;
                                };
                        Comparator<Comparable<Object>> propertyCmp = switch (order.getDirection()) {
                            case ASC -> Comparator.naturalOrder();
                            case DESC -> Comparator.reverseOrder();
                        };
                        propertyCmp = switch (order.getNullHandling()) {
                            case NULLS_FIRST -> Comparator.nullsFirst(propertyCmp);
                            case NATIVE, NULLS_LAST -> Comparator.nullsLast(
                                    propertyCmp);
                        };
                        return Comparator.comparing(keyExtractor, propertyCmp);
                    })
                    .reduce(Comparator::thenComparing);
        return taskViewComparator.orElse(null);
    }
}