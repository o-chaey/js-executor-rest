package io.github.daniil547.js_executor_rest.services;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;

import java.util.Collection;
import java.util.UUID;

/**
 * An external executor for {@link LanguageTask}s.
 */
public interface TaskDispatcher {

    /**
     * Adds a task to this task dispatcher.<br>
     * Might queue or start execution immediately.
     *
     * @param task - task to execute
     */
    void addForExecution(LanguageTask task);

    /**
     * Cancels task execution but doesn't remove from the
     * dispatcher.
     *
     * @param id id of the task to cancel
     */
    void cancelExecution(UUID id);

    /**
     * Restarts a task. Task must be canceled beforehand.
     *
     * @param id if of the task to restart
     */
    void restartExecution(UUID id);

    /**
     * Removes the task from this dispatcher, ceasing execution.
     *
     * @param id id of a task to delete
     */
    void removeTask(UUID id);

    /**
     * @param id of the task to fetch
     * @return the task with the given ID
     */
    LanguageTask getTask(UUID id);

    /**
     * @return all tasks managed by this dispatcher
     */
    Collection<LanguageTask> getAllTasks();
}
