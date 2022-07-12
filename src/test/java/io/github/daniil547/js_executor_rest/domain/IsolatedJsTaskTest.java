package io.github.daniil547.js_executor_rest.domain;

import org.junit.jupiter.api.Assertions;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.Optional;

public class IsolatedJsTaskTest {
    /**
     * If execution blocks on the task itself, it
     * is impossible to cancel it, which is invalid
     * behavior.
     *
     * @throws InterruptedException should never throw;
     * if throws, the cause lies outside the scope of this test
     */
    @Test
    @DisplayName("execution must not block for its entire duration")
    public void nonBlockingExecute() throws InterruptedException {
        IsolatedJsTask task = new IsolatedJsTask("while (true) {console.log(\"hello\");}",
                                                 Long.MAX_VALUE);
        Thread executor = new Thread(task::execute);
        executor.start();

        Thread.sleep(10);

        Thread stopper = new Thread(task::cancel);
        stopper.start();

        stopper.join(100);
        Assertions.assertEquals(LanguageTask.Status.CANCELED,
                                task.getStatus());
    }
}
