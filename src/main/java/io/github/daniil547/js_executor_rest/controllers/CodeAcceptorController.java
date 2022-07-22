package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParser;
import cz.jirutka.rsql.parser.ast.Node;
import io.github.daniil547.js_executor_rest.domain.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.mappers.TaskToViewMapper;
import io.github.daniil547.js_executor_rest.services.RsqlToPredicateVisitor;
import io.github.daniil547.js_executor_rest.services.TaskDispatcher;
import io.github.daniil547.js_executor_rest.services.TaskViewRepresentationModelAssembler;
import io.swagger.v3.oas.annotations.Operation;
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
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

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

@Tag(name = "JS Executor", description = "Service for remote execution of JS code")
@RestController
@RequestMapping("/execution/")
public class CodeAcceptorController {
    private final TaskDispatcher taskDispatcher;
    private final Long statementLimit;
    private final RSQLParser rsqlParser;
    private final RsqlToPredicateVisitor<LanguageTask> rsqlToPredicateVisitor;
    private final TaskViewRepresentationModelAssembler taskReprAssembler;

    private final TaskToViewMapper taskToViewMapper;

    @Autowired
    public CodeAcceptorController(TaskDispatcher taskDispatcher,
                                  RSQLParser rsqlParser,
                                  @Value("${task-execution.statement-limit}") Long statementLimit,
                                  TaskViewRepresentationModelAssembler taskReprAssembler,
                                  TaskToViewMapper taskToViewMapper) {
        this.taskDispatcher = taskDispatcher;
        this.statementLimit = statementLimit;
        this.rsqlParser = rsqlParser;
        this.taskReprAssembler = taskReprAssembler;
        this.taskToViewMapper = taskToViewMapper;
        rsqlToPredicateVisitor = new RsqlToPredicateVisitor<>(LanguageTask.class);
    }

    @Operation(summary = "get all available info about all the tasks (except deleted)",
               operationId = "get all")
    @GetMapping
    public ResponseEntity<PagedModel<EntityModel<TaskView>>> getAllTasks(
            @RequestParam(required = false, name = "query") String query,
            Pageable paging,
            PagedResourcesAssembler<TaskView> pagedResAss
    ) {
        Predicate<LanguageTask> filter = null;
        if (query != null && !query.isBlank()) {
            Node rootNode = rsqlParser.parse(query);
            filter = rootNode.accept(rsqlToPredicateVisitor);
        }
        List<TaskView> queryResult = taskDispatcher.getAllTasks(filter, paging);
        Page<TaskView> taskViewPage = new PageImpl<>(queryResult,
                                                     paging,
                                                     taskDispatcher.getTaskCount());
        return ResponseEntity.ok(pagedResAss.toModel(taskViewPage, taskReprAssembler));
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
                ServletUriComponentsBuilder.fromCurrentRequest()
                                           .path("/{id}")
                                           .buildAndExpand(newTask.getId()
                                                                  .toString())
                                           .toUri()
        );
        // .body is called separately, otherwise Intellij messes up formatting

        return responseBuilder.body(taskReprAssembler.toModel(newTask.getId()));
    }

    @Operation(summary = "edit existing task (currently only cancel)",
               operationId = "update")
    @PatchMapping("{id}")
    public ResponseEntity<?> cancelTask(@PathVariable UUID id,
                                        @RequestBody PatchTaskDto patch) {
        if (patch.status() == LanguageTask.Status.CANCELED) {
            taskDispatcher.cancelExecution(id);
            return ResponseEntity.ok(taskReprAssembler.toModel(id));
        } else {
            return ResponseEntity.badRequest()
                                 .body(Map.of("message",
                                              "You can change script's state only by canceling it"));
        }
    }

    @Operation(summary = "delete a task",
               operationId = "delete")
    @DeleteMapping("{id}")
    public ResponseEntity<RepresentationModel<?>> removeTask(@PathVariable UUID id) {
        taskDispatcher.removeTask(id);
        return ResponseEntity.ok(RepresentationModel.of(null).add(
                Affordances.of(linkTo(
                                       methodOn(this.getClass())
                                               .newTask("")
                               ).withRel("newTask")
                           ).afford(HttpMethod.POST)
                           .toLink(),
                // NOTE: the following will be excluded, see notes in
                // io.github.daniil547.js_executor_rest.services.TaskViewRepresentationModelAssembler.doAddLinks()
                Affordances.of(linkTo(
                                       methodOn(this.getClass())
                                               .getAllTasks(null,
                                                            Pageable.ofSize(10),
                                                            null)
                               ).withRel("getAllTasks")
                           ).afford(HttpMethod.GET)
                           .toLink()
        ));
    }
}

