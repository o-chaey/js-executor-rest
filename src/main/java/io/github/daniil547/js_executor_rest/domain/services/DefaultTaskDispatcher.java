package io.github.daniil547.js_executor_rest.domain.services;

import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.exceptions.PropertyNotFoundProblem;
import io.github.daniil547.js_executor_rest.exceptions.ScriptStateConflictProblem;
import io.github.daniil547.js_executor_rest.exceptions.TaskNotFoundProblem;
import io.github.daniil547.js_executor_rest.mappers.TaskToViewMapper;
import io.github.daniil547.js_executor_rest.util.ReflectionUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Service;

import java.lang.reflect.Method;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;
import java.util.function.Function;
import java.util.function.Predicate;
import java.util.stream.Stream;

/**
 * An external executor for {@link LanguageTask}s. <br>
 * Uses an {@link ExecutorService} and maintains two registers:
 * managed task and task that are executing / queued for execution.
 * Beans for registers must be synchronized
 */
@Service
public class DefaultTaskDispatcher implements TaskDispatcher {
    private final ExecutorService threadPool;
    private final Map<UUID, LanguageTask> taskRegister;
    private final Map<UUID, Future<?>> futureRegister;

    private final TaskToViewMapper ttvMapper;

    @Autowired
    public DefaultTaskDispatcher(ExecutorService threadPool,
                                 TaskToViewMapper ttvMapper) {
        this.threadPool = threadPool;
        this.ttvMapper = ttvMapper;
        this.taskRegister = new ConcurrentHashMap<>();
        this.futureRegister = new ConcurrentHashMap<>();
    }

    @Override
    public void addForExecution(LanguageTask task) {
        synchronized (task) {
            if (task.getStatus() == LanguageTask.Status.SCHEDULED) {
                taskRegister.put(task.getId(), task);

                futureRegister.put(task.getId(), threadPool.submit(task::execute));
            }
        }
    }

    @Override
    public void cancelExecution(UUID id) {
        LanguageTask task;
        // getTask() throws if already removed
        synchronized (task = getTaskInternal(id)) {
            // and this checks if already cancelled
            doCancel(task);
        }
    }

    /**
     * Removes the task from this dispatcher. <br>
     * Doesn't require a task to be {@link LanguageTask.Status#CANCELED}
     * or {@link LanguageTask.Status#FINISHED} first.
     *
     * @param id id of a task to delete
     */
    @Override
    public void removeTask(UUID id) {
        LanguageTask task;
        // getTask() throws if already removed
        synchronized (task = getTaskInternal(id)) {
            LanguageTask.Status status = task.getStatus();
            if (status == LanguageTask.Status.SCHEDULED
                || status == LanguageTask.Status.RUNNING) {
                throw new ScriptStateConflictProblem("You cannot delete a task that didn't stop executing." +
                                                     " If that is what you want, please cancel it first.",
                                                     id, status, "delete");
            } else {
                taskRegister.remove(id);
            }
        }
    }

    private void doCancel(LanguageTask task) {
        task.cancel();
        UUID id = task.getId();
        // gets a future, not the task
        futureRegister.get(id).cancel(true);
        futureRegister.remove(id);
    }


    private LanguageTask getTaskInternal(UUID id) {
        LanguageTask languageTask = taskRegister.get(id);
        if (languageTask == null) {
            throw new TaskNotFoundProblem(id);
        }
        return languageTask;
    }


    /**
     * Returns a read-only view of the task as {@link TaskView}
     *
     * @param id of the task to fetch
     * @return the task with the given ID; !must not be mutated!
     */
    @Override
    public TaskView getTask(UUID id) {
        return ttvMapper.taskToView(getTaskInternal(id));
    }

    /**
     * Returns a read-only view of all the tasks as {@link TaskView}s
     *
     * @return all tasks managed by this dispatcher
     */
    @Override
    public List<TaskView> getAllTasks(Predicate<LanguageTask> filter, Pageable paging) {
        // it starts looking ugly when you add stream operations conditionally
        Stream<LanguageTask> stream1 = taskRegister.values()
                                                   .stream();
        if (filter != null) {
            stream1 = stream1.filter(filter);
        }
        Stream<TaskView> stream2 = stream1.map(ttvMapper::taskToView);
        Comparator<TaskView> sorting = sortToComparator(paging.getSort());
        if (sorting != null) {
            stream2 = stream2.sorted(sorting);
        }
        return stream2.skip(paging.getOffset())
                      .limit(paging.getPageSize())
                      .toList();
    }

    @Override
    public long getTaskCount() {
        return this.taskRegister.size();
    }

    @Nullable
    private Comparator<TaskView> sortToComparator(Sort sort) {
        Optional<Comparator<TaskView>> taskViewComparator =
                // sort is a collection of orders
                sort.stream()
                    // order is a singular sort clause
                    .map(order -> {
                        Method getter = ReflectionUtils.getDeclaredMethodOrThrow(
                                new PropertyNotFoundProblem(
                                        "bad sort query",
                                        "Task",
                                        order.getProperty()
                                ),
                                TaskView.class, order.getProperty());

                        Function<TaskView, Comparable<Object>> keyExtractor =
                                task -> (Comparable<Object>) ReflectionUtils.invokeGetter(getter, task);
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
