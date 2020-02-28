package com.diegodiome.justmeet_backend.security;

import java.util.HashSet;
import java.util.Set;

import com.diegodiome.justmeet_backend.util.FirestoreConstants;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.stereotype.Component;

@Component
public class FirebaseAuthenticationProvider implements AuthenticationProvider {

    @Override
    public Authentication authenticate(Authentication authentication) throws AuthenticationException {
        if (!supports(authentication.getClass())) {
            return null;
        }

        FirebaseAuthenticationToken authenticationToken = (FirebaseAuthenticationToken) authentication;

        Set<GrantedAuthority> grantedAuthorities = new HashSet<GrantedAuthority>();
        if (FirestoreConstants.adminUsers.contains(authenticationToken.getPrincipal())) {
            grantedAuthorities.add(new SimpleGrantedAuthority("ADMIN"));
        }
        authenticationToken.setAuthorities(grantedAuthorities);
        authenticationToken.setAuthenticated(true);
        return authenticationToken;
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return (FirebaseAuthenticationToken.class.isAssignableFrom(authentication));
    }

}