package io.github.daniil547.js_executor_rest.mappers;

import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

@Mapper(componentModel = "spring")
public interface TaskToViewMapper {

    /**
     * Exclusive
     */
    @SuppressWarnings("unused")
    public static final int TRIM_TO_LENGTH = 32;

    @SuppressWarnings("unused")
    public static String trimIfTooLong(String str) {
        return str.length() > TaskToViewMapper.TRIM_TO_LENGTH
               ? str.substring(0, 32) + "..."
               : str;
    }

    TaskView taskToView(LanguageTask task);

    @Mapping(target = "source",
             expression = "java(TaskToViewMapper.trimIfTooLong(task.getSource()))")
    @Mapping(target = "output",
             expression = "java(TaskToViewMapper.trimIfTooLong(task.getOutput()))")
    TaskView taskToViewShortenLongProps(LanguageTask task);
}
