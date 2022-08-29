package io.github.daniil547.js_executor_rest.controllers;

import cz.jirutka.rsql.parser.RSQLParser;
import cz.jirutka.rsql.parser.ast.Node;
import io.github.daniil547.js_executor_rest.domain.objects.DefaultUser;
import io.github.daniil547.js_executor_rest.domain.objects.IsolatedJsTask;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.domain.objects.User;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.mappers.TaskToViewMapper;
import io.github.daniil547.js_executor_rest.repos.TaskRepository;
import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.enums.ParameterIn;
import io.swagger.v3.oas.annotations.enums.SecuritySchemeType;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.security.SecurityScheme;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.data.util.Pair;
import org.springframework.data.util.Predicates;
import org.springframework.data.web.PagedResourcesAssembler;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.PagedModel;
import org.springframework.hateoas.RepresentationModel;
import org.springframework.hateoas.mediatype.Affordances;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.method.annotation.StreamingResponseBody;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;
import org.zalando.problem.Problem;
import org.zalando.problem.Status;

import javax.servlet.http.HttpServletResponse;
import java.net.URI;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutorService;
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
@SecurityRequirement(name = "Authorization")
@OpenAPIDefinition(
        servers = {@Server(url = "https://localhost:8080/"),
                   @Server(url = "https://127.0.0.1:8080/")
        },
        security = @SecurityRequirement(name = "Authorization")
)
@SecurityScheme(name = "Authorization",
                type = SecuritySchemeType.OPENIDCONNECT,
                openIdConnectUrl = "https://localhost:8081/realms/JsExecutor/.well-known/openid-configuration"
)
@Tag(name = "JS Executor", description = "Service for remote execution of JS code")
@RestController
@RequestMapping("/tasks/")
public class CodeAcceptorController {
    private static final Logger logger = LoggerFactory.getLogger(CodeAcceptorController.class);
    public static final SimpleGrantedAuthority ADMIN_ROLE_SCOPE = new SimpleGrantedAuthority("SCOPE_app_admin");
    public static final SimpleGrantedAuthority APP_SCOPE = new SimpleGrantedAuthority("SCOPE_app");
    private final TaskRepository taskRepository;
    private final Long statementLimit;
    private final RSQLParser rsqlParser;
    private final RsqlToPredicateVisitor<LanguageTask> rsqlToPredicateVisitor;
    private final TaskViewRepresentationModelAssembler taskReprAssembler;
    private final TaskToViewMapper mapper;
    private final ExecutorService threadPool;

    @Autowired
    public CodeAcceptorController(TaskRepository taskRepository, RSQLParser rsqlParser,
                                  @Value("${task-execution.statement-limit}") Long statementLimit,
                                  RsqlToPredicateVisitor<LanguageTask> rsqlToPredicateVisitor,
                                  TaskViewRepresentationModelAssembler taskReprAssembler,
                                  TaskToViewMapper mapper,
                                  ExecutorService threadPool) {
        this.taskRepository = taskRepository;
        this.statementLimit = statementLimit;
        this.rsqlParser = rsqlParser;
        this.rsqlToPredicateVisitor = rsqlToPredicateVisitor;
        this.taskReprAssembler = taskReprAssembler;
        this.mapper = mapper;
        this.threadPool = threadPool;
    }

    @SuppressWarnings({"squid:S5665", "UnnecessaryStringEscape"})
    @Operation(
            summary = "get all available info about all the tasks (except deleted)",
            operationId = "get all",
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
            @Parameter(hidden = true)
            PagedResourcesAssembler<TaskView> pagedResAssembler
    ) {
        if (paging == null) {
            throw Problem.builder().withTitle("Bad request")
                         .withStatus(Status.BAD_REQUEST)
                         .withDetail("Paging must not be null")
                         .build();
        }
        Predicate<LanguageTask> filter;
        if (query != null && !query.isBlank()) {
            Node rootNode = rsqlParser.parse(query);
            filter = rootNode.accept(rsqlToPredicateVisitor);
        } else {
            filter = Predicates.isTrue();
        }
        var user = currentUser();
        if (user.getRole() != User.Role.ADMIN) {
            filter = filter.and(task -> task.getOwner().getId().equals(user.getId()));
        }
        Pair<List<LanguageTask>, Integer> queryResult = taskRepository.getAllTasks(filter, paging);
        List<TaskView> taskViews = queryResult.getFirst()
                                              .stream()
                                              .map(mapper::taskToViewShortenLongProps)
                                              .toList();
        Page<TaskView> taskViewPage = new PageImpl<>(taskViews,
                                                     paging,
                                                     queryResult.getSecond());
        return ResponseEntity.ok(pagedResAssembler.toModel(taskViewPage, taskReprAssembler));
    }

    @Operation(summary = "get all available info about the task",
               operationId = "get")
    @GetMapping("{id}/")
    public ResponseEntity<EntityModel<TaskView>> getTask(@PathVariable UUID id) {
        var task = checkCurrentUserAuthorizedAndGet(id);
        return ResponseEntity.ok(taskReprAssembler.toModel(mapper.taskToView(task)));
    }

    @Operation(summary = "get source code of the task, as was submitted",
               operationId = "get source")
    @GetMapping("{id}/source")
    public ResponseEntity<String> getTaskSource(@PathVariable UUID id) {
        String source = checkCurrentUserAuthorizedAndGet(id).getSource();

        return ResponseEntity.ok(source);
    }

    @Operation(summary = "get current or previous status of the task",
               operationId = "get status")
    @GetMapping("{id}/status")
    public ResponseEntity<String> getTaskStatus(@PathVariable UUID id) {
        LanguageTask.Status status = checkCurrentUserAuthorizedAndGet(id).getStatus();

        return ResponseEntity.ok(status.toString().toLowerCase());
    }

    @Operation(summary = "retrieve output produced by the task up to some \"recent\" moment in the past",
               operationId = "get output")
    @GetMapping("{id}/output")
    public ResponseEntity<String> getTaskOutput(@PathVariable UUID id) {
        String output = checkCurrentUserAuthorizedAndGet(id).getOutput();

        return ResponseEntity.ok(output);
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
            ),
            security = @SecurityRequirement(name = "keycloack-auth",
                                            scopes = "swagger")
    )
    @PostMapping(consumes = MediaType.TEXT_PLAIN_VALUE)
    public ResponseEntity<RepresentationModel<?>> newTask(@RequestBody String source) {
        IsolatedJsTask newTask = new IsolatedJsTask(source, statementLimit, currentUser());
        newTask.execute(threadPool);
        taskRepository.storeTask(newTask);

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
    public ResponseEntity<StreamingResponseBody> newTaskStream(@RequestBody String source,
                                                               HttpServletResponse response) {
        StreamingResponseBody srb = out -> {
            IsolatedJsTask task = new IsolatedJsTask(source, statementLimit, out, currentUser());
            response.addHeader(
                    HttpHeaders.LOCATION,
                    getTaskLocation(task).toString().replace("/stream/", "/")
            );
            taskRepository.storeTask(task);
            task.execute(threadPool);
            task.await();
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
        checkCurrentUserAuthorizedAndGet(id).cancel();

        return ResponseEntity.ok(taskReprAssembler.toModel(id));
    }

    @Operation(summary = "delete a task",
               operationId = "delete")
    @DeleteMapping("{id}")
    public ResponseEntity<RepresentationModel<?>> removeTask(@PathVariable UUID id) {
        LanguageTask task = checkCurrentUserAuthorizedAndGet(id);
        LanguageTask.Status status = task.getStatus();
        if (status == LanguageTask.Status.FINISHED
            || status == LanguageTask.Status.CANCELED) {
            taskRepository.deleteTask(id);
        }
        return ResponseEntity.ok(RepresentationModel.of(null).add(
                                         Affordances.of(linkTo(methodOn(CodeAcceptorController.class)
                                                                       .newTask("")).withRel("collection"))
                                                    // NOTE: the following will be excluded, see notes in
                                                    // io.github.daniil547.js_executor_rest.services.TaskViewRepresentationModelAssembler.doAddLinks()
                                                    .afford(HttpMethod.GET)
                                                    .withName("getAllTasks")
                                                    .toLink()
                                 )
        );
    }

    private LanguageTask checkCurrentUserAuthorizedAndGet(UUID taskId) {
        User user = currentUser();
        var task = taskRepository.getTask(taskId);
        User owner = task.getOwner();
        if (user.getRole() == User.Role.ADMIN
            || owner.getId()
                    .equals(user.getId())) {
            return task;
        } else {
            throw new AccessDeniedException("User " + user.getId() + " isn't authorized to access this resource");
        }
    }

    private static User currentUser() {
        var authen = SecurityContextHolder.getContext().getAuthentication();
        // Not the best way to determine privilege level, but here it's
        // restricted buy how things are implemented in KC and Spring/
        // One of better ways is to put the role into claims of the token
        // (role attribute in KC) but KC doesn't always do this.
        // Another way is to use KC's SCOPE_roles, which puts all user's role into claims,
        // but it buries them deep within token's JSON, which is really messy to traverse
        // because Spring represents it as Map<String, Object>

        User.Role role;
        Collection<? extends GrantedAuthority> authorities = authen.getAuthorities();
        // currently O(n) as it's impl is a list
        // but it should be possible to configure Spring to pack Authorities in e.g. a HashSet
        if (authorities.contains(APP_SCOPE)) {
            if (authorities.contains(ADMIN_ROLE_SCOPE)) {
                role = User.Role.ADMIN;
            } else {
                role = User.Role.USER;
            }
        } else {
            // unlikely as SCOPE_app is given by default
            throw new AccessDeniedException("User doesn't have access to the app.");
        }

        String name = authen.getName();
        return new DefaultUser(UUID.fromString(name), role);
    }


    private URI getTaskLocation(LanguageTask task) {
        return ServletUriComponentsBuilder.fromCurrentRequest()
                                          .path("/{id}")
                                          .buildAndExpand(task.getId()
                                                              .toString())
                                          .toUri();
    }
}

