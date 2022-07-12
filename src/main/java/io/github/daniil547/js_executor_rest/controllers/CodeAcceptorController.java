package io.github.daniil547.js_executor_rest.controllers;

import io.github.daniil547.js_executor_rest.domain.Data;
import io.github.daniil547.js_executor_rest.domain.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.BinaryInputTaskDto;
import io.github.daniil547.js_executor_rest.dtos.NoInputTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TextInputTaskDto;
import io.github.daniil547.js_executor_rest.services.TaskDispatcher;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;
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
    public ResponseEntity<List<Map<String, Data>>> getAllTasksInfo() {
        return ResponseEntity.ok(taskDispatcher.getAllTasks()
                                               .stream()
                                               .map(LanguageTask::getInfo)
                                               .toList());
    }

    @GetMapping("{id}/")
    public ResponseEntity<Map<String, Data>> getTaskInfo(@PathVariable UUID id) {
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
    public ResponseEntity<Data> getTaskOutput(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getOutputSoFar());
    }

    @GetMapping("{id}/errors")
    public ResponseEntity<String> getTaskErrors(@PathVariable UUID id) {
        return ResponseEntity.ok(taskDispatcher.getTask(id).getErrors());
    }

    @PostMapping("text-input")
    public ResponseEntity<String> submitTaskTextInput(@RequestBody TextInputTaskDto dto) {
        return doSubmitTask(dto.source(),
                            Optional.of(Data.of(dto.input())),
                            dto.desiredOutputType());
    }

    @PostMapping("binary-input")
    public ResponseEntity<String> submitTaskBinaryInput(@RequestBody BinaryInputTaskDto dto) {
        return doSubmitTask(dto.source(),
                            Optional.of(Data.of(dto.input())),
                            dto.desiredOutputType());
    }

    @PostMapping(consumes = "application/json")
    public ResponseEntity<String> submitTaskNoInput(@RequestBody NoInputTaskDto dto) {
        return doSubmitTask(dto.source(), Optional.empty(), dto.desiredOutputType());
    }

    private ResponseEntity<String> doSubmitTask(
            String source,
            Optional<Data> input,
            LanguageTask.StreamType desiredOutputType
    ) {
        IsolatedJsTask newTask = new IsolatedJsTask(source, input, desiredOutputType, statementLimit);
        taskDispatcher.addForExecution(newTask);

        return new ResponseEntity<>(newTask.getId().toString(), HttpStatus.CREATED);
    }

    @PutMapping("{id}/cancel")
    public ResponseEntity<?> cancelTask(@PathVariable UUID id) {
        taskDispatcher.cancelExecution(id);
        return ResponseEntity.ok().build();
    }

    @DeleteMapping("{id}")
    public ResponseEntity<?> removeTask(@PathVariable UUID id) {
        taskDispatcher.removeTask(id);
        return ResponseEntity.noContent().build();
    }
}

