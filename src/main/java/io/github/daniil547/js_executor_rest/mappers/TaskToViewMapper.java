package io.github.daniil547.js_executor_rest.mappers;

import io.github.daniil547.js_executor_rest.domain.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;

@Mapper(componentModel = "spring")
public interface TaskToViewMapper {
    @Mappings({
            @Mapping(source = "outputSoFar", target = "output")
    })
    TaskView taskToView(LanguageTask task);
}
