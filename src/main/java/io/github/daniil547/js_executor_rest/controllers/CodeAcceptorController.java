package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParser;
import cz.jirutka.rsql.parser.ast.Node;
import io.github.daniil547.js_executor_rest.domain.objects.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.domain.services.TaskDispatcher;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.hateoas.RepresentationModel;
import org.springframework.hateoas.mediatype.Affordances;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;

import javax.servlet.http.HttpServletResponse;
import java.net.URI;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.function.Predicate;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

/**
 * Controller that accepts requests for remote script
 * execution.
 * <p>
 * Has CRUD functionality.
 */

@SuppressWarnings({"squid:S1452", "unused"})
@Tag(name = "JS Executor", description = "Service for remote execution of JS code")
@RestController
@RequestMapping("/tasks/")
public class CodeAcceptorController {
    private final TaskDispatcher taskDispatcher;
    private final Long statementLimit;
    private final RSQLParser rsqlParser;
    private final RsqlToPredicateVisitor<LanguageTask> rsqlToPredicateVisitor;
    private final TaskViewRepresentationModelAssembler taskReprAssembler;

    @Autowired
    public CodeAcceptorController(TaskDispatcher taskDispatcher,
                                  RSQLParser rsqlParser,
                                  @Value("${task-execution.statement-limit}") Long statementLimit,
                                  TaskViewRepresentationModelAssembler taskReprAssembler) {
        this.taskDispatcher = taskDispatcher;
        this.statementLimit = statementLimit;
        this.rsqlParser = rsqlParser;
        this.taskReprAssembler = taskReprAssembler;
        rsqlToPredicateVisitor = new RsqlToPredicateVisitor<>(LanguageTask.class);
    }

    @SuppressWarnings({"squid:S5665", "UnnecessaryStringEscape"})
    @Operation(
            summary = "get all available info about all the tasks (except deleted)",
            operationId = "get all",
            description = "",
            parameters = {
                    @Parameter(
                            name = "filter",
                            description = """
                                    #### Available logical operators:\n
                                    Logical AND: `;` or `and`\n
                                    Logical OR: `,` or `or`\n
                                    By default, the AND operator takes precedence over OR,
                                    but parenthesis can be used to group expressions\n
                                    #### Available comparison operators\n
                                    Equal to: `==`\n
                                    Not equal to: `!=`\n
                                    Less than: `=lt=` or `<`\n
                                    Less than or equal to: `=le=` or `<=`\n
                                    Greater than operator: `=gt=` or `>`\n
                                    Greater than or equal to: `=ge=` or `>=`\n
                                    In: `=in=`\n
                                    Not in: `=out=`\n
                                      """
                    ),
                    @Parameter(in = ParameterIn.QUERY,
                               description = "Zero-based page index (0..N)",
                               name = "page",
                               schema = @Schema(type = "integer", defaultValue = "0")
                    ),
                    @Parameter(in = ParameterIn.QUERY,
                               description = "The size of the page to be returned",
                               name = "size",
                               schema = @Schema(type = "integer", defaultValue = "10")
                    ),
                    @Parameter(in = ParameterIn.QUERY,
                               description = "Sorting criteria in the format: property,(asc|desc). "
                                             + "Default sort order is ascending. " + "Multiple sort criteria are supported.",
                               name = "sort",
                               array = @ArraySchema(schema = @Schema(type = "string", example = "status"))
                    )
            }
    )
    @GetMapping
    public ResponseEntity<PagedModel<EntityModel<TaskView>>> getAllTasks(
            @RequestParam(required = false, name = "filter")
            String query,
            @Parameter(hidden = true)
            Pageable paging,
            @SuppressWarnings("ConstantConditions") // injected by Spring, should never be null
            @Parameter(hidden = true)
            PagedResourcesAssembler<TaskView> pagedResAssembler
    ) {
        if (paging == null) {
            throw Problem.builder().withTitle("Bad request")
                         .withStatus(Status.BAD_REQUEST)
                         .withDetail("Paging must not be null")
                         .build();
        }
        Predicate<LanguageTask> filter = null;
        if (query != null && !query.isBlank()) {
            Node rootNode = rsqlParser.parse(query);
            filter = rootNode.accept(rsqlToPredicateVisitor);
        }
        List<TaskView> queryResult = taskDispatcher.getAllTasks(filter, paging);
        Page<TaskView> taskViewPage = new PageImpl<>(queryResult,
                                                     paging,
                                                     taskDispatcher.getTaskCount());
        return ResponseEntity.ok(pagedResAssembler.toModel(taskViewPage, taskReprAssembler));
    }

    @Operation(summary = "get all available info about the task",
               operationId = "get")
    @GetMapping("{id}/")
    public ResponseEntity<EntityModel<TaskView>> getTask(@PathVariable UUID id) {
        return ResponseEntity.ok(taskReprAssembler.toModel(taskDispatcher.getTask(id)));
    }

    @Operation(summary = "get source code of the task, as was submitted",
               operationId = "get source")
    @GetMapping("{id}/source")
    public ResponseEntity<RepresentationModel<?>> getTaskSource(@PathVariable UUID id) {
        RepresentationModel<?> sourceAndLinks = taskReprAssembler.toModel(
                Map.of("source", taskDispatcher.getTask(id).source()),
                id
        );
        return ResponseEntity.ok(sourceAndLinks);
    }

    @Operation(summary = "get current or previous status of the task",
               operationId = "get status")
    @GetMapping("{id}/status")
    public ResponseEntity<RepresentationModel<?>> getTaskStatus(@PathVariable UUID id) {
        RepresentationModel<?> statusAndLinks = taskReprAssembler.toModel(
                Map.of("status", taskDispatcher.getTask(id).status()),
                id
        );
        return ResponseEntity.ok(statusAndLinks);
    }

    @Operation(summary = "retrieve output produced by the task up to some \"recent\" moment in the past",
               operationId = "get output")
    @GetMapping("{id}/output")
    public ResponseEntity<RepresentationModel<?>> getTaskOutput(@PathVariable UUID id) {
        RepresentationModel<?> outputAndLinks = taskReprAssembler.toModel(
                Map.of("output", taskDispatcher.getTask(id).output()),
                id
        );
        return ResponseEntity.ok(outputAndLinks);
    }


    @Operation(
            summary = "create a task by sending source as plain text",
            operationId = "create",
            // that's Java's lack of import aliases for you
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    content = @Content(
                            schema = @Schema(type = "string"),
                            mediaType = "text/plain",
                            examples = {@ExampleObject("console.log(\"Hello, World!\");")}
                    )
            ))
    @PostMapping(consumes = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<RepresentationModel<?>> newTask(@RequestBody String source) {
        IsolatedJsTask newTask = new IsolatedJsTask(source, statementLimit);
        taskDispatcher.addForExecution(newTask);

        ResponseEntity.BodyBuilder responseBuilder = ResponseEntity.created(
                getTaskLocation(newTask)
        );
        // .body is called separately, otherwise Intellij messes up formatting
        return responseBuilder.body(taskReprAssembler.toModel(newTask.getId()));
    }

    @Operation(
            summary = "create a task by sending source as plain text, and continuously receive output as a stream",
            operationId = "create and stream output",
            // that's Java's lack of import aliases for you
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    content = @Content(
                            schema = @Schema(type = "string"),
                            mediaType = "text/plain",
                            examples = {@ExampleObject("for(var i = 0; i < 1000; i++) {console.log(\"Hello, World!\");}")}
                    )
            ))
    @PostMapping(path = "stream",
                 consumes = MediaType.TEXT_PLAIN_VALUE)
    //TODO add support for storing, canceling and deleting streaming tasks
    //TODO for that should most likely refactor DefaultTaskDispatcher and IsolatedJsTask so that:
    //TODO - DefaultTaskDispatcher only executes task
    //TODO - there's a separate entity, storing the tasks
    //TODO - task execution can be controlled by the task itself (e.g. task should store the Future
    //TODO     and cancel() also cancels that Future)

    public ResponseEntity<StreamingResponseBody> newTaskStream(@RequestBody String source,
                                                               HttpServletResponse response) {
        StreamingResponseBody srb = out -> {
            IsolatedJsTask task = new IsolatedJsTask(source, statementLimit, out);
            response.addHeader(
                    HttpHeaders.LOCATION,
                    getTaskLocation(task).toString().replace("/stream/", "/")
            );
            task.execute();
        };
        ResponseEntity.BodyBuilder responseBuilder = ResponseEntity.ok();

        return responseBuilder.body(srb);
    }


    @Operation(summary = "edit existing task (currently only cancel)",
               operationId = "update")
    @PatchMapping("{id}")
    public ResponseEntity<RepresentationModel<?>> cancelTask(
            @PathVariable UUID id,
            @RequestBody PatchTaskDto patch
    ) {
        taskDispatcher.cancelExecution(id);
        return ResponseEntity.ok(taskReprAssembler.toModel(id));
    }

    @Operation(summary = "delete a task",
               operationId = "delete")
    @DeleteMapping("{id}")
    public ResponseEntity<RepresentationModel<?>> removeTask(@PathVariable UUID id) {
        taskDispatcher.removeTask(id);
        return ResponseEntity.ok(RepresentationModel.of(null).add(
                                         Affordances.of(linkTo(methodOn(CodeAcceptorController.class)
                                                                       .newTask("")).withRel("collection"))
                                                    //                                                    .afford(HttpMethod.POST)
                                                    //                                                    .withName("newTask")
                                                    // NOTE: the following will be excluded, see notes in
                                                    // io.github.daniil547.js_executor_rest.services.TaskViewRepresentationModelAssembler.doAddLinks()
                                                    .afford(HttpMethod.GET)
                                                    .withName("getAllTasks")
                                                    .toLink()
                                 )
        );
    }


    private URI getTaskLocation(LanguageTask task) {
        return ServletUriComponentsBuilder.fromCurrentRequest()
                                          .path("/{id}")
                                          .buildAndExpand(task.getId()
                                                              .toString())
                                          .toUri();
    }
}

