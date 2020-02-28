package com.diegodiome.justmeet_backend.model;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;

public class UserAuthenticated implements User{

    @Id
    private String userId;

    @NotNull
    private String userEmail;

    @NotNull
    private AUTH_PROVIDERS authProvider;

    @NotNull
    private boolean banned;

    public UserAuthenticated() {
        this.banned = false;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    @Override
    public String getUserId() {
        return userId;
    }

    @Override
    public boolean isBanned() {
        return banned;
    }

    @Override
    public String getUserEmail() {
        return userEmail;
    }

    public AUTH_PROVIDERS getAuthProvider() {
        return authProvider;
    }

    public void setAuthProvider(AUTH_PROVIDERS authProvider) {
        this.authProvider = authProvider;
    }

    public void setBanned(boolean banned) {
        this.banned = banned;
    }
}