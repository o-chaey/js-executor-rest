package io.github.daniil547.js_executor_rest.services;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.exceptions.TaskNotFoundException;
import io.github.daniil547.js_executor_rest.mappers.TaskToViewMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Collection;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Future;

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
            doCancel(task);
            taskRegister.remove(id);
        }
    }

    private void doCancel(LanguageTask task) {
        LanguageTask.Status status = task.getStatus();
        if (status == LanguageTask.Status.SCHEDULED
            || status == LanguageTask.Status.RUNNING) {
            task.cancel();
            UUID id = task.getId();
            // gets a future, not the task
            futureRegister.get(id).cancel(true);
            futureRegister.remove(id);
        }
    }


    private LanguageTask getTaskInternal(UUID id) {
        LanguageTask languageTask = taskRegister.get(id);
        if (languageTask == null) {
            throw new TaskNotFoundException(id);
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
    public Collection<TaskView> getAllTasks() {
        return taskRegister.values()
                           .stream()
                           .map(ttvMapper::taskToView)
                           .toList();
    }
}
