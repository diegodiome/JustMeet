package com.diegodiome.justmeet_backend.security;

import java.util.Collection;

import com.google.firebase.auth.FirebaseToken;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;

public class FirebaseAuthenticationToken implements Authentication {

    private static final long serialVersionUID = 1L;

    private FirebaseToken token;

    private String principal;

    private Collection<? extends GrantedAuthority> authorities;

    private boolean isAuthenticated;

    public FirebaseAuthenticationToken(FirebaseToken token) {
        this.token = token;
        this.principal = token.getEmail();
    }

    public FirebaseAuthenticationToken(String principal, Collection<? extends GrantedAuthority> authorities) {
        this.principal = principal;
        this.authorities = authorities;
    }

    @Override
    public String getName() {
        return token.getName();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    public void setAuthorities(Collection<? extends GrantedAuthority> authorities) {
        this.authorities = authorities;
    }

    @Override
    public FirebaseToken getCredentials() {
        return token;
    }

    @Override
    public Object getDetails() {
        return null;
    }

    @Override
    public String getPrincipal() {
        return principal;
    }

    @Override
    public boolean isAuthenticated() {
        return isAuthenticated;
    }

    @Override
    public void setAuthenticated(boolean isAuthenticated) throws IllegalArgumentException {
        this.isAuthenticated = isAuthenticated;
    }

    public void setPrincipal(String principal) {
        this.principal = principal;
    }
}