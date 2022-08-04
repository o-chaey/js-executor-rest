package io.github.daniil547.js_executor_rest.domain;

import io.github.daniil547.js_executor_rest.domain.objects.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.concurrent.*;

class IsolatedJsTaskTest {
    /**
     * If execution blocks on the task itself, it
     * is impossible to cancel it, which is invalid
     * behavior.
     *
     * @throws InterruptedException should never throw;
     *                              if throws, the cause lies outside the scope of this test
     */
    @Test
    @DisplayName("execution must not block for its entire duration")
    void nonBlockingExecute() throws InterruptedException, ExecutionException {
        IsolatedJsTask task = new IsolatedJsTask("while (true) {console.log(\"hello\");}",
                                                 Long.MAX_VALUE);
        ExecutorService executor = Executors.newFixedThreadPool(2);
        task.execute(executor);

        executor.submit(task::cancel).get();
        try {
            task.await(10, TimeUnit.MILLISECONDS);
            Assertions.assertEquals(LanguageTask.Status.CANCELED, task.getStatus());
        } catch (TimeoutException e) {
            Assertions.fail("Task wasn't canceled and continued to run.", e);
        }
    }
}
