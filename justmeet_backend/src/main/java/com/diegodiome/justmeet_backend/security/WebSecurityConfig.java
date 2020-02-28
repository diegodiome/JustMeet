
package com.diegodiome.justmeet_backend.security;

import com.diegodiome.justmeet_backend.util.ApiConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfiguration;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.www.BasicAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig extends WebSecurityConfigurerAdapter {

    private static final Logger logger = LoggerFactory.getLogger(WebSecurityConfiguration.class);

    @Autowired
    private FirebaseAuthenticationProvider authProvider;

    /**
     * Use to create instance of {@link FirebaseAuthenticationTokenFilter}.
     *
     * @return instance of {@link FirebaseAuthenticationTokenFilter}
     */
    public FirebaseAuthenticationTokenFilter firebaseAuthenticationFilterBean() throws Exception {
        logger.info("Creating instance of FirebaseAuthenticationFilter.");

        FirebaseAuthenticationTokenFilter authenticationTokenFilter = new FirebaseAuthenticationTokenFilter();

        return authenticationTokenFilter;
    }

    @Override
    protected void configure(AuthenticationManagerBuilder auth) throws Exception {
        auth.authenticationProvider(authProvider);
    }

    @Override
    protected void configure(HttpSecurity httpSecurity) throws Exception {

        httpSecurity
                .cors()
                .and()
                .csrf()
                .disable()
                .authorizeRequests()
                .antMatchers(ApiConstants.API + "/**").permitAll()
                .antMatchers(ApiConstants.API_ADMIN + "/**").hasAuthority("ADMIN")
                .anyRequest().authenticated()
                .and()
                .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS);

        // Custom security filter
        httpSecurity.addFilterBefore(firebaseAuthenticationFilterBean(),
                BasicAuthenticationFilter.class);
    }

}