package io.github.daniil547.js_executor_rest;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;


@Configuration
public class SecurityConfig {

    @Bean
    public SecurityFilterChain httpSecurity(HttpSecurity http) throws Exception {
        http// picks up corsConfigurationSource
            .cors()
            .and()
            // temporarily for swagger to work
            .csrf().disable();
        return http.build();
    }

    /**
     * An explicitly set default (see the settings in the javadoc of
     * {@link CorsConfiguration#applyPermitDefaultValues()}.<br>
     * Implicit (without this bean) default just denies all CORS requests.
     *
     * @return default CORS configuration
     */
    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", new CorsConfiguration().applyPermitDefaultValues());
        return source;
    }
}
