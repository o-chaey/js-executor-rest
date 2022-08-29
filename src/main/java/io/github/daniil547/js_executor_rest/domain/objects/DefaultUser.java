package io.github.daniil547.js_executor_rest.domain.objects;

import java.util.UUID;

/**
 * It *can* be a record, but records don't follow naming convention for accessors
 * (e.g. "id()" would get generated instead of "getId()"), so "getId()" and "getRole()"
 * would still have to be defined to satisfy User interface contract. So it wouldn't
 * save a lot of letters.
 */
@SuppressWarnings({"squid:S6206", "ClassCanBeRecord"})
public final class DefaultUser implements User {
    private final UUID id;
    private final Role role;

    public DefaultUser(UUID id, Role role) {
        this.id = id;
        this.role = role;
    }

    @Override
    public UUID getId() {
        return this.id;
    }

    @Override
    public Role getRole() {
        return this.role;
    }
}
