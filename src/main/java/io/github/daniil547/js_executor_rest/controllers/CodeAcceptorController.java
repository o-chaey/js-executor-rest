package io.github.daniil547.js_executor_rest.controllers;

import io.github.daniil547.js_executor_rest.domain.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.services.TaskDispatcher;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Controller that accepts requests for remote script
 * execution.
 * <p>
 * Has CRUD functionality.
 */
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

    @GetMapping
    public ResponseEntity<List<Map<String, String>>> getAllTasksInfo() {
        return ResponseEntity.ok(taskDispatcher.getAllTasks()
                                               .stream()
                                               .map(LanguageTask::getInfo)
                                               .toList());
    }

    @GetMapping("{id}/")
    public ResponseEntity<Map<String, String>> getTaskInfo(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getInfo());
    }

    @GetMapping("{id}/source")
    public ResponseEntity<String> getTaskSource(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getSource());
    }

    @GetMapping("{id}/status")
    public ResponseEntity<LanguageTask.Status> getTaskStatus(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getStatus());
    }

    @GetMapping("{id}/output")
    public ResponseEntity<String> getTaskOutput(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getOutputSoFar());
    }

    @PostMapping(headers = "Accept=text/plain")
    @Operation( // that's Java's lack of import aliases for you
            requestBody = @io.swagger.v3.oas.annotations.parameters.RequestBody(
                    content = @Content(
                            schema = @Schema(type = "string"),
                            mediaType = "text/plain",
                            examples = {@ExampleObject("console.log(\"Hello, World!\");")}
                    )
            )
    )
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

    @DeleteMapping("{id}")
    public ResponseEntity<?> removeTask(@PathVariable UUID id) {
        taskDispatcher.removeTask(id);
        return ResponseEntity.noContent().build();
    }
}

