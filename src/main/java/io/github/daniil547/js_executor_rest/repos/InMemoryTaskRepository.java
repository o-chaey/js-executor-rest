package io.github.daniil547.js_executor_rest.repos;

import io.github.daniil547.js_executor_rest.controllers.SortToComparatorConverter;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.exceptions.TaskNotFoundProblem;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.util.Pair;
import org.springframework.lang.Nullable;
import org.springframework.stereotype.Repository;

import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.function.Predicate;
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
    public LanguageTask getTask(UUID id) {
        LanguageTask languageTask = taskRegister.get(id);
        if (languageTask == null) {
            throw new TaskNotFoundProblem(id);
        }
        return languageTask;
    }

    @Override
    public void deleteTask(UUID id) {
        LanguageTask removed = taskRegister.remove(id);
        if (removed == null) {throw new TaskNotFoundProblem(id);}
    }

    @Override
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
                              .toList(),
                       taskRegister.size());
    }

    @Nullable
    private Comparator<LanguageTask> sortToComparator(Sort sort) {
        return sortToComparatorConverter.sortToComparator(sort);
    }
}