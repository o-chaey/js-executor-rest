package io.github.daniil547.js_executor_rest.controllers;

import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.dtos.PatchTaskDto;
import io.github.daniil547.js_executor_rest.dtos.TaskView;
import io.github.daniil547.js_executor_rest.util.HttpUtils;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.hateoas.Link;
import org.springframework.hateoas.RepresentationModel;
import org.springframework.hateoas.mediatype.Affordances;
import org.springframework.hateoas.mediatype.ConfigurableAffordance;
import org.springframework.hateoas.server.SimpleRepresentationModelAssembler;
import org.springframework.http.HttpMethod;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import java.util.List;
import java.util.UUID;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@Component
public class TaskViewRepresentationModelAssembler implements SimpleRepresentationModelAssembler<TaskView> {
    public static final PatchTaskDto CANCEL_PATCH = new PatchTaskDto(LanguageTask.Status.CANCELED);
    private final Class<CodeAcceptorController> controller = CodeAcceptorController.class;

    public <T> RepresentationModel<?> toModel(T value, UUID taskId) {

        RepresentationModel<?> resource = RepresentationModel.of(value);
        doAddLinks(resource, taskId);
        return resource;
    }

    public RepresentationModel<?> toModel(UUID taskId) {
        RepresentationModel<?> resource = RepresentationModel.of(null);
        doAddLinks(resource, taskId);
        return resource;
    }

    @Override
    public void addLinks(EntityModel<TaskView> resource) {
        TaskView taskView = resource.getContent();
        UUID id = taskView.id();
        doAddLinks(resource, id);
    }

    private void doAddLinks(RepresentationModel<?> resource, UUID id) {
        String mainRel;
        if (!(resource instanceof EntityModel)) {
            mainRel = "resource";
            resource.add(Link.of(ServletUriComponentsBuilder.fromCurrentRequest().toUriString(), "self"));
        } else {
            mainRel = "self";
        }
        Link resLink = linkTo(controller).slash(id)
                                         .withRel(mainRel);
        ConfigurableAffordance affsOnSelfResource = Affordances.of(resLink)
                                                               .afford(HttpMethod.GET)
                                                               .withName("getTask")

                                                               .andAfford(HttpMethod.DELETE)
                                                               .withName("deleteTask");

        // user shouldn't try to cancel a task that was just (in the current request) canceled
        if (!HttpUtils.getCurrentHttpRequest().getMethod().equalsIgnoreCase("PATCH")) {
            affsOnSelfResource = affsOnSelfResource.andAfford(HttpMethod.PATCH)
                                                   .withName("cancelTask")
                                                   .withTarget(linkTo(methodOn(controller)
                                                                              .cancelTask(id,
                                                                                          CANCEL_PATCH)
                                                               ).withRel("cancel")
                                                   )
                                                   .withInput(PatchTaskDto.class);
        }
        List<Link> linksAndAffs = List.of(
                // NOTE 1: Spring HATEOAS currently filters out any GET affordances
                // that is dumb, but has no workaround
                // so GET affordances are here waiting for the patch to come
                // (though it might take a lot of time)

                // NOTE 2: Spring HATEOAS currently forces the name "default"
                // onto the first affordance. That is dumb as well, and has no workaround.
                affsOnSelfResource.toLink(),
                // and thу following are sub-resources
                Affordances.of(
                                   linkTo(methodOn(controller).getTaskSource(id)).withRel(mainRel + ".source"))
                           .afford(HttpMethod.GET)
                           .withName("getTaskSource")
                           .toLink(),
                Affordances.of(
                                   linkTo(methodOn(controller).getTaskStatus(id)).withRel(mainRel + ".status"))
                           .afford(HttpMethod.GET)
                           .withName("getTaskStatus")
                           .toLink(),
                Affordances.of(
                                   linkTo(methodOn(controller).getTaskOutput(id)).withRel(mainRel + ".output"))
                           .afford(HttpMethod.GET)
                           .withName("getTaskOutput")
                           .toLink()
        );
        resource.add(linksAndAffs);


    }


    @Override
    public void addLinks(CollectionModel<EntityModel<TaskView>> resources) {

    }
}
