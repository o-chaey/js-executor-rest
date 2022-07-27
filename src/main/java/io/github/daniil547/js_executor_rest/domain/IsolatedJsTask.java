package io.github.daniil547.js_executor_rest.domain;

import io.github.daniil547.js_executor_rest.exceptions.ScriptStateConflictProblem;
import lombok.Builder;
import org.graalvm.polyglot.*;
import org.springframework.lang.Nullable;

import java.io.*;
import java.lang.management.ThreadMXBean;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.ZonedDateTime;
import java.time.temporal.Temporal;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicReference;
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
@Builder
public class IsolatedJsTask implements LanguageTask {
    public static final String LANG = "js";
    public static final String EXECUTE = "start";
    public static final String CANCEL = "cancel";
    private final Context polyglotContext;
    private final UUID id;
    private final String sourceCode;
    private AtomicReference<Status> currentStatus;
    private final ByteArrayOutputStream out;
    private String errors = "";

    private Optional<ZonedDateTime> startTime;
    private Optional<Duration> duration;
    private Optional<ZonedDateTime> endTime;

    private final Object lock = new Object();
    private final Source polyglotSource;

    /**
     * Create {@link IsolatedJsTask} with a default output stream - ByteArrayOutputStream.
     * Contents of which can be retrieved at any time via {@link IsolatedJsTask#getOutput()}.
     *
     * @param sourceCode     JavaScript code to be executed
     * @param statementLimit maximum number of statements allowed to be executed by this task
     */
    public IsolatedJsTask(String sourceCode, long statementLimit) {
        this(sourceCode, statementLimit, new ByteArrayOutputStream(), null);
    }

    public IsolatedJsTask(String sourceCode, long statementLimit, OutputStream customOut) {
        this(sourceCode, statementLimit, null, customOut);
    }

    private IsolatedJsTask(String sourceCode, long statementLimit, ByteArrayOutputStream defaultOut, OutputStream customOut) {
        if (defaultOut != null && customOut != null)
            throw new AssertionError("Both default OutputStream and custom one are provided, which is illegal");
        if (defaultOut == null && customOut == null)
            throw new AssertionError("Neither default OutputStream nor custom one is provided, which is illegal");

        Context.Builder builder = Context.newBuilder(LANG)
                                         .in(InputStream.nullInputStream())

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
                                                               .onLimit(s -> this.cancel())
                                                               .build());
        if (defaultOut != null) {
            this.out = defaultOut;
            BufferedOutputStream bufferedOut = new BufferedOutputStream(defaultOut);
            builder.out(bufferedOut)
                   //provided, but unused by GraalJS
                   .err(bufferedOut);
        } else {
            builder.out(customOut)
                   //provided, but unused by GraalJS
                   .err(customOut);
            this.out = null;
        }

        this.startTime = Optional.empty();
        this.duration = Optional.empty();
        this.endTime = Optional.empty();
        this.polyglotContext = builder.build();
        this.sourceCode = sourceCode;
        this.polyglotSource = makeSource();
        polyglotContext.parse(polyglotSource);
        currentStatus = new AtomicReference<>(Status.SCHEDULED);
        id = UUID.randomUUID();
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
        return currentStatus.getPlain();
    }

    @Override
    @Nullable
    public String getOutput() {
        if (out != null) {
            return out.toString(StandardCharsets.UTF_8) + errors;
        } else {
            return null;
        }
    }

    @Override
    public Optional<ZonedDateTime> getStartTime() {
        return startTime;
    }

    /**
     * Duration is implemented naively: as
     * {@link Duration#between(Temporal, Temporal) Duration.between(startTime, endTime)}
     * This doesn't account for a lot of stuff, like blocking, waiting,
     * logical cores being used for other computation etc.<br>
     * It would be better solved by measuring CPU time used by a specific task.<br>
     * However, standard tools ({@link ThreadMXBean#getThreadCpuTime(long)}) only
     * support measuring CPU time allocated to a <b>thread</b>, which would be
     * useless for our case, since we are using a thread pool.<br>
     * GraalVM, though, measures CPU time per polyglot context, but it is
     * available only in GraalVM Enterprise and is an experimental feature.
     * <p>
     * So, naive approach seems to be a good tradeoff between effect (precision) and complexity.
     *
     * @return
     */
    @Override
    public Optional<Duration> getDuration() {
        if (currentStatus.compareAndSet(Status.RUNNING, Status.RUNNING)) {
            return startTime.map(
                    zonedDateTime -> Duration.between(zonedDateTime, ZonedDateTime.now())
            );
        } else {
            return duration;
        }
    }

    @Override
    public Optional<ZonedDateTime> getEndTime() {
        return endTime;
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
        if (currentStatus.compareAndSet(Status.SCHEDULED, Status.RUNNING)) {
            startTime = Optional.of(ZonedDateTime.now());
        } else {
            throw new ScriptStateConflictProblem(
                    "Task " + this.id + " is " + currentStatus.getPlain().toString().toLowerCase()
                    + ". Scripts can't be restarted.",
                    this.id, this.currentStatus.getPlain(), EXECUTE
            );
        }

        try {
            polyglotContext.eval(polyglotSource);
        }
        // GraalJS doesn't write errors to its err, even though it is provided
        // to the builder in the constructor above
        catch (PolyglotException e) {
            StringBuilder errorAcumulator = new StringBuilder("");
            errorAcumulator.append(e.getMessage());
            StreamSupport.stream(e.getPolyglotStackTrace().spliterator(), false)
                         // don't wanna leak implementation details, do we?
                         // though some formatting or wording may still be unique to GraalVM
                         .filter(PolyglotException.StackFrame::isGuestFrame)
                         .forEach(obj -> errorAcumulator.append(obj).append("\n"));
            errors = errorAcumulator.toString();
        } finally {
            currentStatus.set(Status.FINISHED);
            catchEndTime();
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
        if (currentStatus.compareAndSet(Status.SCHEDULED, Status.CANCELED)
            || currentStatus.compareAndSet(Status.RUNNING, Status.CANCELED)) {
            catchEndTime();
        } else {
            throw new ScriptStateConflictProblem(
                    "Task " + this.id + " is already " + currentStatus.toString().toLowerCase() +
                    ". Canceling it again will have no effect",
                    this.id, this.currentStatus.getPlain(), CANCEL);
        }
    }

    private Source makeSource() {
        try {
            return Source.newBuilder(LANG, sourceCode, "Task")
                         // can it even fail if loaded from a string?
                         // who knows... nothing in the docs
                         // also we have a context per script, so having a particular name
                         // for a script inside a context shouldn't matter
                         .build();
        } catch (IOException e) {
            throw new AssertionError("Source.Builder.build() wasn't expected " +
                                     "to fail when source is loaded from a string", e);
        }
    }

    private void catchEndTime() {
        endTime = Optional.of(ZonedDateTime.now());
        duration = Optional.of(Duration.between(startTime.get(),
                                                endTime.get()));
    }
}