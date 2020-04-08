package com.diegodiome.justmeet_backend.config

import org.slf4j.LoggerFactory
import org.springframework.context.annotation.Configuration
import org.springframework.security.config.annotation.web.builders.HttpSecurity
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter
import org.springframework.security.config.http.SessionCreationPolicy
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter

@Configuration
@EnableWebSecurity
class WebSecurityConfig : WebSecurityConfigurerAdapter() {

    private var securityLogger = LoggerFactory.getLogger(WebSecurityConfig::class.java)

    private fun firebaseAuthenticationFilterBean(): FirebaseAuthenticationTokenFilter {
        securityLogger.info("Creating instance of FirebaseAuthenticationTokenFilter")
        return FirebaseAuthenticationTokenFilter()
    }

    override fun configure(http: HttpSecurity) {
        http
                .cors()
                .and()
                .csrf().disable()
                .sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .authorizeRequests()
                .antMatchers("/").permitAll()
                .anyRequest().authenticated()

        http.addFilterBefore(firebaseAuthenticationFilterBean(), UsernamePasswordAuthenticationFilter::class.java)
    }

}

