package io.github.daniil547.js_executor_rest.controllers;

import io.github.daniil547.js_executor_rest.domain.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.services.TaskDispatcher;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.Collection;
import java.util.Map;
import java.util.UUID;

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

    @Autowired
    public CodeAcceptorController(TaskDispatcher taskDispatcher,
                                  @Value("${task-execution.statement-limit}")
                                  Long statementLimit) {
        this.taskDispatcher = taskDispatcher;
        this.statementLimit = statementLimit;
    }

    @Operation(summary = "get all available info about all the tasks (except deleted)",
               operationId = "get all")
    @GetMapping
    public ResponseEntity<Collection<TaskView>> getAllTasksInfo() {
        return ResponseEntity.ok(taskDispatcher.getAllTasks());
    }

    @Operation(summary = "get all available info about the task",
               operationId = "get")
    @GetMapping("{id}/")
    public ResponseEntity<TaskView> getTaskInfo(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id));
    }

    @Operation(summary = "get source code of the task, as was submitted",
               operationId = "get source")
    @GetMapping("{id}/source")
    public ResponseEntity<String> getTaskSource(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).source());
    }

    @Operation(summary = "get current or previous status of the task",
               operationId = "get status")
    @GetMapping("{id}/status")
    public ResponseEntity<LanguageTask.Status> getTaskStatus(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).status());
    }

    @Operation(summary = "retrieve output produced by the task up to some \"recent\" moment in the past",
               operationId = "get output")
    @GetMapping("{id}/output")
    public ResponseEntity<String> getTaskOutput(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).output());
    }

    @PostMapping(headers = "Accept=text/plain")
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
    public ResponseEntity<String> submitTaskNoInput(@RequestBody String source) {
        IsolatedJsTask newTask = new IsolatedJsTask(source, statementLimit);
        taskDispatcher.addForExecution(newTask);

        ResponseEntity.BodyBuilder responseBuilder = ResponseEntity.created(
                ServletUriComponentsBuilder.fromCurrentRequest()
                                           .path("/{id}")
                                           .buildAndExpand(newTask.getId()
                                                                  .toString())
                                           .toUri()
        );
        // .build is called separately, otherwise Intellij messes up formatting
        return responseBuilder.build();

    }

    @Operation(summary = "edit existing task (currently only cancel)",
               operationId = "update")
    @PatchMapping("{id}")
    public ResponseEntity<?> cancelTask(@PathVariable UUID id,
                                        @RequestBody PatchTaskDto patch) {
        if (patch.status() == LanguageTask.Status.CANCELED) {
            taskDispatcher.cancelExecution(id);
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.badRequest()
                                 .body(Map.of("message",
                                              "You can change script's state only by canceling it"));
        }
    }

    @Operation(summary = "delete a task",
               operationId = "delete")
    @DeleteMapping("{id}")
    public ResponseEntity<?> removeTask(@PathVariable UUID id) {
        taskDispatcher.removeTask(id);
        return ResponseEntity.noContent().build();
    }
}

