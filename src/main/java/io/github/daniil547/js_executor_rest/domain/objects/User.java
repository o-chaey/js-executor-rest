package io.github.daniil547.js_executor_rest.domain.objects;

import java.util.UUID;

public interface User {
    UUID getId();

    Role getRole();

    enum Role {
        ADMIN,
        USER
    }
}
