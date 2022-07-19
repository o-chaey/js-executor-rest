package io.github.daniil547.js_executor_rest.mappers;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface TaskToViewMapper {

    TaskView taskToView(LanguageTask task);
}
