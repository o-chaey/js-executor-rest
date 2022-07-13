package io.github.daniil547.js_executor_rest.domain;

import io.github.daniil547.js_executor_rest.exceptions.ScriptStateConflictException;
import org.graalvm.polyglot.*;

import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.StreamSupport;

/**
 * Represents a single script of Javascript language
 * with no access to other scripts, host VM and Java code, host's FS and so on.
 * <p>
 * Uses GraalVM (which in turn uses GraalJS) as Javascript engine.
 * <p>
 * Each script uses a separate engine object. It might be
 * changed to use a shared one for better performance. <br>
 * However doing so might allow one task to access/manipulate
 * other ones. (requires profiling and further research)
 * <p>
 * Implementation is to be managed externally
 * (e.g. by an {@link java.util.concurrent.ExecutorService}).
 * It allows valid concurrent (non-blocking) access to its methods.
 * <p>
 * Even though it's named Isolated<u>Js</u>Task, the only bit of
 * specialization currently present is "js" string being passed to
 * {@link Context#newBuilder(String...)} and
 * {@link Source#newBuilder(String, CharSequence, String)}.
 * It can be easily generified (if required at some point)
 * by making language identifier into a constructor parameter.
 * <p>
 * {@link Status#CANCELED} means that the task was either canceled
 * by the user or executed {@code IsolatedJsTask(..., long statementLimit)}
 * statements.
 */
public class IsolatedJsTask implements LanguageTask {
    public static final String LANG = "js";
    private final Context polyglotContext;
    private final String sourceCode;
    private Status currentStatus;
    private final ByteArrayOutputStream out;
    private String errors;
    private final UUID id;
    private final Object lock = new Object();

    /**
     * One and only constructor.
     *
     * @param sourceCode     - JavaScript code to be executed
     * @param statementLimit - maximum number of statements allowed to be executed by this task
     */
    public IsolatedJsTask(String sourceCode, long statementLimit) {
        this.out = new ByteArrayOutputStream();
        Context.Builder builder = Context.newBuilder(LANG)
                                         .in(InputStream.nullInputStream())
                                         .out(new BufferedOutputStream(out))
                                         //provided, but unused by GraalJS
                                         .err(new BufferedOutputStream(out))
                                         .allowHostAccess(HostAccess.NONE)
                                         .allowPolyglotAccess(PolyglotAccess.NONE)
                                         .allowCreateProcess(false)
                                         .allowCreateThread(false)
                                         .allowHostAccess(HostAccess.SCOPED)
                                         .allowAllAccess(false)
                                         .allowEnvironmentAccess(EnvironmentAccess.NONE)
                                         // unavailable in community edition of GraalVM
                                         //.option("sandbox.MaxHeapMemory", /*inject from config*/);
                                         // and also requires
                                         //.allowExperimentalOptions(true)
                                         //so there's a workaround (and the only stable resource limiting feature)
                                         .resourceLimits(
                                                 ResourceLimits.newBuilder()
                                                               // perform no filtering
                                                               .statementLimit(statementLimit,
                                                                               null)
                                                               // context is closed automatically
                                                               // upon reaching the limit
                                                               // this is for other actions
                                                               .onLimit((s) -> this.cancel())
                                                               .build());

        this.polyglotContext = builder.build();
        this.sourceCode = sourceCode;
        currentStatus = Status.SCHEDULED;
        id = UUID.randomUUID();
    }

    /**
     * Returns combined output of {@link #getId()},
     * {@link #getSource()}, {@link #getStatus()},
     * {@link #getOutputSoFar()}.
     *
     * @return info describing the task
     */
    @Override
    public Map<String, String> getInfo() {
        // to maintain insertion order (for nicer output to the user)
        // might be replaced with something like List<Pair<String, String>>
        // but it requires a Pair class (3rd-party dep or handwritten)
        // and might not be autoconverted to JSON
        Map<String, String> info = new LinkedHashMap<>();
        Status status = getStatus();

        info.put("id", getId().toString());
        info.put("status", status.toString());
        info.put("outputSoFar", getOutputSoFar());

        return info;
    }


    @Override
    public UUID getId() {
        return this.id;
    }

    /**
     * @return task's source code
     */
    @Override
    public String getSource() {
        return sourceCode;
    }

    @Override
    public Status getStatus() {
        return currentStatus;
    }

    @Override
    public String getOutputSoFar() {
        return out.toString(StandardCharsets.UTF_8) + errors;
    }


    /**
     * Executes the task.
     * <p>
     * While this method is running, {@link #getStatus}
     * returns {@link Status#RUNNING}. When it is
     * exited, {@link #getStatus} returns {@link Status#FINISHED}
     * or {@link Status#CANCELED}, if the task was canceled
     * by a user, or statement limit was hit.
     * <p>
     * *Might* throw an {@link IOException}, if the loading of
     * code fails. <br> Here it is loaded from a string, so such
     * event is unlikely, but it is ultimately up to
     * a language engine implementation.
     */
    @Override
    public void execute() {
        synchronized (lock) {
            switch (currentStatus) {
                case SCHEDULED -> currentStatus = Status.RUNNING;
                case RUNNING -> throw new ScriptStateConflictException(
                        "Task " + this.id + " is already " + LanguageTask.Status.RUNNING
                );
                case FINISHED, CANCELED -> throw new ScriptStateConflictException(
                        "Script " + this.id + "can't be executed as it is " + currentStatus + ". Scripts can't be restarted."
                );
            }
        }

        try {
            polyglotContext.eval(
                    // can it even fail if loaded from a string?
                    // who knows... nothing in the docs
                    // also we have a context per script, so having a particular name
                    // for a script inside a context shouldn't matter
                    Source.newBuilder(LANG, sourceCode, "Task")
                          .build()
            );
        } catch (IOException e) {
            throw new IllegalStateException(e);
            // GraalJS doesn't write errors to its err, even though it is provided
            // to the builder in the constructor above
        } catch (PolyglotException e) {
            StringBuilder errorAcumulator = new StringBuilder("");
            errorAcumulator.append(e.getMessage());
            StreamSupport.stream(e.getPolyglotStackTrace().spliterator(), false)
                         // don't wanna leak implementation details, do we?
                         // though some formatting or wording may still be unique to GraalVM
                         .filter(PolyglotException.StackFrame::isGuestFrame)
                         .forEach(obj -> errorAcumulator.append(obj).append("\n"));
            errors = errorAcumulator.toString();
        } finally {
            currentStatus = Status.FINISHED;
            polyglotContext.close();
        }
    }

    /**
     * Cancels the task.
     * <p>
     * This implementation is meant to be managed by an external
     * executor, so it only changes the {@link #currentStatus}
     * {@link Status#CANCELED}.
     */
    @Override
    public void cancel() {
        synchronized (lock) {
            switch (currentStatus) {
                case SCHEDULED, RUNNING -> this.currentStatus = Status.CANCELED;
                case FINISHED, CANCELED -> throw new ScriptStateConflictException(
                        "Task " + this.id + " is already " + currentStatus);
            }
        }
    }
}