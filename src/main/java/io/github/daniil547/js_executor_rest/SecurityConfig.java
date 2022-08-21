package io.github.daniil547.js_executor_rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.oauth2.server.resource.OAuth2ResourceServerConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import javax.annotation.PostConstruct;


@Configuration
public class SecurityConfig {
    private final Environment env;

    @Autowired
    public SecurityConfig(Environment env) {
        this.env = env;
    }

    /**
     * It appears that Spring uses server.ssl.trust-store not for mapping to javax.net.ssl.trustStore,
     * so we define our custom property and map it here
     */
    @SuppressWarnings("ConstantConditions")
    @PostConstruct
    private void configureSSL() {
        //-Djavax.net.ssl.trustStore=src/main/resources/truststore.jks -Djavax.net.ssl.trustStorePassword=password
        System.setProperty("javax.net.ssl.trustStore", env.getProperty("server.javax.net.ssl.trust-store"));
        System.setProperty("javax.net.ssl.trustStorePassword",
                           env.getProperty("server.javax.net.ssl.trust-store-password"));
    }

    @Bean
    public SecurityFilterChain httpSecurity(HttpSecurity http) throws Exception {
        http// picks up corsConfigurationSource
            .cors()
            .and()

            .authorizeRequests()
            .mvcMatchers("/tasks/*").hasAuthority("SCOPE_swagger")
            .and()

            .csrf()
            .disable()

            .sessionManagement()
            .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()

            .oauth2ResourceServer(OAuth2ResourceServerConfigurer::jwt)
        ;
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
