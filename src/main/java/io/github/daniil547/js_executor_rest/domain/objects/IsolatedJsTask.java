package io.github.daniil547.js_executor_rest.domain.objects;

import io.github.daniil547.js_executor_rest.exceptions.ScriptStateConflictProblem;
import org.graalvm.polyglot.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.Nullable;

import java.io.*;
import java.lang.management.ThreadMXBean;
import java.nio.charset.StandardCharsets;
import java.time.Duration;
import java.time.ZonedDateTime;
import java.time.temporal.Temporal;
import java.util.Iterator;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicReference;

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
    private static final String EXECUTE = "start";
    private static final String CANCEL = "cancel";
    public static final String AT = "\tat ";
    private final Context polyglotContext;
    private final UUID id;
    private final String sourceCode;
    private final AtomicReference<Status> currentStatus;
    private final ByteArrayOutputStream out;
    private final Source polyglotSource;
    private static final Logger logger = LoggerFactory.getLogger(IsolatedJsTask.class);

    private Optional<ZonedDateTime> startTime;
    private Optional<ZonedDateTime> endTime;

    private Future<?> future;
    private final PrintWriter outWriter;

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

    /**
     * Create {@link IsolatedJsTask} with a custom output stream.
     *
     * @param sourceCode     JavaScript code to be executed
     * @param statementLimit maximum number of statements allowed to be executed by this task
     * @param customOut      output stream for the task to write to
     */
    public IsolatedJsTask(String sourceCode, long statementLimit, OutputStream customOut) {
        this(sourceCode, statementLimit, null, customOut);
    }

    private IsolatedJsTask(String sourceCode,
                           long statementLimit,
                           ByteArrayOutputStream defaultOut,
                           OutputStream customOut) {
        if (defaultOut != null && customOut != null) {
            throw new AssertionError(
                    "private IsolatedJsTask(String, long, ByteArrayOutputStream default, OutputStream custom)" +
                    " used incorrectly: both default and custom output streams were provided");
        }
        if (defaultOut == null && customOut == null) {
            throw new AssertionError("private IsolatedJsTask(String, long, ByteArrayOutputStream, OutputStream)" +
                                     " used incorrectly: both output streams were null");
        }
        @SuppressWarnings("squid:S125")
        Context.Builder builder =
                Context.newBuilder(LANG)
                       .in(InputStream.nullInputStream())
                       // obviously, not a good idea to allow
                       .allowAllAccess(false)
                       // determines if context can access things like java arrays, iterators,
                       // specific classes or classes annotated by particular annotations etc.
                       // not restricted here
                       .allowHostAccess(HostAccess.ALL)
                       // filters classes by their fully qualified name
                       // here reflection and the app's packages are filtered out
                       .allowHostClassLookup(clazz ->
                                                     !clazz.startsWith("io.github.daniil547.js_executor_rest")
                                                     && !clazz.startsWith("java.lang.reflect"))
                       // determines which languages can evaluate code of which languages
                       // not restricted here
                       .allowPolyglotAccess(PolyglotAccess.ALL)
                       // thread/process creation is prohibited
                       .allowCreateProcess(false)
                       .allowCreateThread(false)
                       .allowEnvironmentAccess(EnvironmentAccess.NONE)
                       // IO operations on host system
                       .allowIO(true)
                       .useSystemExit(false)
                       // guests are prohibited to load classes from files
                       .allowHostClassLoading(false)
                       // JNI. Also, some languages need it to boot their environment up (though not js)
                       .allowNativeAccess(true)
                       // sharing org.graalvm.polyglot.Value between different langs
                       .allowValueSharing(true)

                       // unavailable in community edition of GraalVM
                       // .option("sandbox.MaxHeapMemory", /*inject from config*/);
                       // and also requires
                       // .allowExperimentalOptions(true)
                       // so there's a workaround (and the only stable resource limiting feature)
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
                   .err(bufferedOut)
                   .logHandler(bufferedOut);
            outWriter = new PrintWriter(defaultOut, true);
        } else {
            this.out = null;

            builder.out(customOut)
                   // removed because on context close Graal calls flush()
                   // which conflicts, when the customOut is an OutputStream
                   // passed from StreamingResponseBody, hence managed by Spring,
                   // and Spring happens to call close() before flush().
                   // When this is not provided it prints to script's sout
                   // which is the same.
                   // If needed, constructor should be reworked/added to accept a
                   // user-provided stream for logging, but we currently have no
                   // use case for that
                   // .logHandler(customOut)

                   // provided, but unused by GraalJS
                   .err(customOut);


            outWriter = new PrintWriter(customOut, true);
        }

        this.startTime = Optional.empty();
        this.endTime = Optional.empty();
        this.polyglotContext = builder.build();
        this.sourceCode = sourceCode;
        this.polyglotSource = makeSource();
        polyglotContext.parse(polyglotSource);
        this.currentStatus = new AtomicReference<>(Status.SCHEDULED);
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
            return out.toString(StandardCharsets.UTF_8);
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
     * @return time elapsed between task start and end (or the moment of call for running tasks)
     */
    @Override
    public Optional<Duration> getDuration() {
        // note: Duration.between() can't be substituted with Duration.from(), from() is just a conversion method
        return startTime.map(s -> Duration.between(s, endTime.orElse(ZonedDateTime.now())));
    }

    @Override
    public Optional<ZonedDateTime> getEndTime() {
        return endTime;
    }

    /**
     * Submits the task to the provided {@link ExecutorService}.
     * <p>
     * While this method is running, {@link #getStatus}
     * returns {@link Status#RUNNING}. When it is
     * exited, {@link #getStatus} returns {@link Status#FINISHED}
     * or {@link Status#CANCELED}, if the task was canceled
     * by a user, or statement limit was hit.
     * <p>
     * Submitted runnable throw an {@link IOException}, if the loading of
     * code fails. <br> Here it is loaded from a string, so such
     * event is unlikely, but it is ultimately up to
     * a language engine implementation.
     */

    @Override
    @SuppressWarnings("squid:S1612")
    public void execute(ExecutorService executor) {
        future = executor.submit(() -> this.execute());
    }

    private void execute() {
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

            outWriter.println(e.getMessage());

            Iterator<PolyglotException.StackFrame> iterator = e.getPolyglotStackTrace().iterator();
            while (iterator.hasNext()) {
                // this is safe because there always are at least two trailing frames
                // that belong to our application, and they are filtered
                // in the code below
                // (all guest calls ultimately originate from this file and method,
                // (since guest scripts are not allowed to create new threads/processes)
                // and here we call Context.eval() which creates an additional stack frame)
                PolyglotException.StackFrame currentFrame = iterator.next();
                PolyglotException.StackFrame nextFrame = iterator.next();
                PolyglotException.StackFrame nextPlus1Frame = iterator.next();

                // a guest frame...
                if (currentFrame.isGuestFrame()
                    // ...followed by the host frame...
                    && nextFrame.isHostFrame()
                    // ...and a call from our app means that it's the last guest frame
                    && nextPlus1Frame.toString().startsWith("io.github.daniil547")) {
                    outWriter.println(AT + currentFrame);
                    break;
                }
                outWriter.println(AT + currentFrame);
                outWriter.println(AT + nextFrame);
                outWriter.println(AT + nextPlus1Frame);
            }
        } finally {
            polyglotContext.close(true);

            outWriter.close();
            currentStatus.set(Status.FINISHED);
            catchEndTime();
        }
    }

    @Override
    public void await() {
        try {
            this.future.get();
        } catch (InterruptedException e) {
            handleInterrupt();
        }
        // polyglot exception is caught in execute()
        // anything else isn't expected
        catch (ExecutionException e) {
            handleUnexpected(e);
        } catch (CancellationException e) {
            handleCancellation();
        }
    }

    @Override
    public void await(long timeout, TimeUnit timeUnit) throws TimeoutException {
        try {
            this.future.get(timeout, timeUnit);
        } catch (InterruptedException e) {
            handleInterrupt();
        } catch (ExecutionException e) {
            handleUnexpected(e);
        } catch (CancellationException e) {
            handleCancellation();
        }
    }

    private void handleUnexpected(ExecutionException e) {
        throw new AssertionError("Unexpected exception", e);
    }

    private void handleInterrupt() {
        // advised by sonar lint
        Thread.currentThread().interrupt();
    }

    private void handleCancellation() {
        logger.info("Task {} was canceled", this.id);
    }

    /**
     * Cancels the task.
     * <p>
     * Beside changing the {@link #currentStatus} to {@link Status#CANCELED},
     * this method also closes the context and output streams, determines end time,
     * prints the fact of cancellation
     */
    @Override
    public void cancel() {
        if (currentStatus.compareAndSet(Status.SCHEDULED, Status.CANCELED)
            || currentStatus.compareAndSet(Status.RUNNING, Status.CANCELED)) {
            outWriter.println("Task was canceled by the user.");
            outWriter.flush();
            future.cancel(true);
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
            throw new AssertionError("Source.Builder.build() failed loading a source from a string." +
                                     "This wasn't expected. If this happened, it has to be determined why it failed," +
                                     "and that case has to be handled.", e);
        }
    }

    private void catchEndTime() {
        endTime = Optional.of(ZonedDateTime.now());
    }
}