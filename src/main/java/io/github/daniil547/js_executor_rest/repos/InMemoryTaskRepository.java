package io.github.daniil547.js_executor_rest.repos;

import io.github.daniil547.js_executor_rest.controllers.SortToComparatorConverter;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.exceptions.TaskNotFoundProblem;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.util.Pair;
import org.springframework.lang.Nullable;
import org.springframework.security.access.prepost.PostAuthorize;
import org.springframework.stereotype.Repository;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Repository
public class InMemoryTaskRepository implements TaskRepository {
    private final Map<UUID, LanguageTask> taskRegister;
    private final SortToComparatorConverter<LanguageTask> sortToComparatorConverter;

    public InMemoryTaskRepository(SortToComparatorConverter<LanguageTask> sortToComparatorConverter) {
        this.sortToComparatorConverter = sortToComparatorConverter;
        this.taskRegister = new ConcurrentHashMap<>();
    }

    @Override
    public LanguageTask storeTask(LanguageTask task) {
        if (task == null) {throw new IllegalArgumentException("LanguageTask to store must not be null");}
        taskRegister.put(task.getId(), task);
        return task;
    }

    @Override
    @PostAuthorize("hasAuthority('SCOPE_app_admin') " +
                   "or returnObject.getOwner.getId.equals(T(java.util.UUID).fromString(authentication.getName))")
    public LanguageTask getTask(UUID id) {
        LanguageTask languageTask = taskRegister.get(id);
        if (languageTask == null) {
            throw new TaskNotFoundProblem(id);
        }
        return languageTask;
    }

    /**
     * <p>No {@link org.springframework.security.access.prepost.PreAuthorize} or
     * {@link org.springframework.security.access.prepost.PostAuthorize} here as
     * we have no access to the specific {@link LanguageTask} object before/after
     * the method is executed. We also can't call {@link #getTask(UUID)} here as
     * Spring AOP doesn't affect method calls inside one object. This would require
     * the use of ApectJ load-time weaving.
     * <p>The way it is now it'll still work as in
     * {@link io.github.daniil547.js_executor_rest.controllers.CodeAcceptorController#removeTask(UUID)}
     * we invoke {@link #getTask(UUID)} to check if we are deleting an inactive task.
     * <p>And anyway, this ideally needs a refactor to have a service layer.
     *
     * @param id id of the task to delete
     */
    @Override
    public void deleteTask(UUID id) {
        LanguageTask removed = taskRegister.remove(id);
        if (removed == null) {throw new TaskNotFoundProblem(id);}
    }

    @SuppressWarnings("squid:S6204") // returned list has to be modifiable
    @Override
    // no @PostFilter here cause the List is inside a Pair
    // always evaluates to true, but for non-admins also filters (mutates) the returned list
    @PostAuthorize("hasAuthority('SCOPE_app_admin') " +
                   "or T(io.github.daniil547.js_executor_rest.util.SecurityUtils)" +
                   ".filterTasksByOwner(returnObject.first, authentication.getName)")
    public Pair<List<LanguageTask>, Integer> getAllTasks(Predicate<LanguageTask> filter, Pageable paging) {
        // it starts looking ugly when you add stream operations conditionally
        Stream<LanguageTask> stream1 = taskRegister.values()
                                                   .stream();
        if (filter != null) {
            stream1 = stream1.filter(filter);
        }
        Comparator<LanguageTask> sorting = sortToComparatorConverter.sortToComparator(paging.getSort());
        if (sorting != null) {
            stream1 = stream1.sorted(sorting);
        }
        return Pair.of(stream1.skip(paging.getOffset())
                              .limit(paging.getPageSize())
                              // modifiable
                              .collect(Collectors.toList()),
                       taskRegister.size());
    }

    @Nullable
    private Comparator<LanguageTask> sortToComparator(Sort sort) {
        return sortToComparatorConverter.sortToComparator(sort);
    }
}