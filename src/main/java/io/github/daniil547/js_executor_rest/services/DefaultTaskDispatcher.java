package io.github.daniil547.js_executor_rest.services;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.exceptions.TaskNotFoundException;
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

    @Autowired
    public DefaultTaskDispatcher(ExecutorService threadPool) {
        this.threadPool = threadPool;
        this.taskRegister = new ConcurrentHashMap<>();
        this.futureRegister = new ConcurrentHashMap<>();
    }

    @Override
    public void addForExecution(LanguageTask task) {
        taskRegister.put(task.getId(), task);

        futureRegister.put(task.getId(), threadPool.submit(task::execute));
    }

    @Override
    public void cancelExecution(UUID id) {
        synchronized (getTask(id)) {
            getTask(id).cancel();
            futureRegister.get(id).cancel(true);
            futureRegister.remove(id);
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
        synchronized (getTask(id)) {
            this.cancelExecution(id);
            taskRegister.remove(id);
        }
    }

    /**
     * TODO: Better be reimplemented to return a read-only view of the task
     * TODO: And this impl made internal-only
     *
     * @param id of the task to fetch
     * @return the task with the given ID; !must not be mutated!
     */
    @Override
    public LanguageTask getTask(UUID id) {
        LanguageTask languageTask = taskRegister.get(id);
        if (languageTask == null) {
            throw new TaskNotFoundException(id);
        }
        return languageTask;
    }

    /**
     * TODO: Better be reimplemented to return a read-only views of tasks
     *
     * @return all tasks managed by this dispatcher
     */
    @Override
    public Collection<LanguageTask> getAllTasks() {
        return taskRegister.values();
    }
}
