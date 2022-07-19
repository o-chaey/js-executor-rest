package io.github.daniil547.js_executor_rest.services;

import cz.jirutka.rsql.parser.ast.*;
import io.github.daniil547.js_executor_rest.util.ReflectionUtils;

import java.lang.reflect.Method;
import java.util.List;
import java.util.function.BinaryOperator;
import java.util.function.Function;
import java.util.function.Predicate;

public class RsqlToPredicateVisitor<T> extends NoArgRSQLVisitorAdapter<Predicate<T>> {
    private final Class<T> type;

    public RsqlToPredicateVisitor(Class<T> type) {
        this.type = type;
    }

    @Override
    public Predicate<T> visit(AndNode node) {
        return traverseChildren(node, Predicate::and);
    }

    @Override
    public Predicate<T> visit(OrNode node) {
        return traverseChildren(node, Predicate::or);
    }

    @Override
    public Predicate<T> visit(ComparisonNode node) {
        String propertyName = node.getSelector();
        Method getter = ReflectionUtils.getDeclaredMethodOrThrow(
                type, "get" + Character.toUpperCase(propertyName.charAt(0))
                      + propertyName.substring(1));
        List<String> args = node.getArguments();
        Function<T, String> fn = v -> ReflectionUtils.invokeOrThrow(getter, v).toString();
        Predicate<T> propertyPredicate = switch (node.getOperator().getSymbol()) {
            case "==" -> lt -> fn.apply(lt).equals(args.get(0));
            case "!=" -> lt -> !fn.apply(lt).equals(args.get(0));
            case "=lt=" -> lt -> fn.apply(lt).compareTo(args.get(0)) < 0;
            case "=le=" -> lt -> fn.apply(lt).compareTo(args.get(0)) <= 0;
            case "=gt=" -> lt -> fn.apply(lt).compareTo(args.get(0)) > 0;
            case "=ge=" -> lt -> fn.apply(lt).compareTo(args.get(0)) >= 0;
            case "=in=" -> lt -> args.contains(fn.apply(lt));
            case "=out=" -> lt -> !args.contains(fn.apply(lt));
            default -> throw new IllegalStateException("Unknown comparison operator" + node.getOperator().getSymbol());
        };
        return propertyPredicate;
    }

    private Predicate<T> traverseChildren(LogicalNode node,
                                          BinaryOperator<Predicate<T>> gatheringWith) {
        return node.getChildren()
                   .stream()
                   .map(n -> {
                       if (n instanceof OrNode orN) {
                           return visit(orN);
                       } else if (n instanceof AndNode andN) {
                           return visit(andN);
                       } else if (n instanceof ComparisonNode cmpN) {
                           return visit(cmpN);
                       }
                       throw new AssertionError("Unreachable code reached: new subclass of " +
                                                "cz.jirutka.rsql.parser.ast.LogicalNode ("
                                                + n.getClass() + ") was introduced and wasn't accounted for");
                   })
                   .reduce(gatheringWith)
                   .orElse(x -> true);
    }
}
