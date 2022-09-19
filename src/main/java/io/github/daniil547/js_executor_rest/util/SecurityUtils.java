package io.github.daniil547.js_executor_rest.util;

import io.github.daniil547.js_executor_rest.domain.objects.DefaultUser;
import io.github.daniil547.js_executor_rest.domain.objects.LanguageTask;
import io.github.daniil547.js_executor_rest.domain.objects.User;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

public class SecurityUtils {
    public static final SimpleGrantedAuthority ADMIN_ROLE_SCOPE = new SimpleGrantedAuthority("SCOPE_app_admin");
    public static final SimpleGrantedAuthority APP_SCOPE = new SimpleGrantedAuthority("SCOPE_app");

    /**
     * Map {@link org.springframework.security.core.context.SecurityContext}'s
     * {@link org.springframework.security.core.Authentication} to a {@link User} domain object
     *
     * @return user behind the currently processed request (thread-bound)
     */
    public static User currentUser() {
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

    public static boolean filterTasksByOwner(List<LanguageTask> tasks, UUID ownerId) {
        tasks.removeIf(lt -> !lt.getOwner().getId().equals(ownerId));

        return true;
    }
}
