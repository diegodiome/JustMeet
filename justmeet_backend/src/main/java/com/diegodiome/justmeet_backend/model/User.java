package com.diegodiome.justmeet_backend.model;

public interface User {

    public String getUserId();
    public boolean isBanned();
    public String getUserEmail();
    public AUTH_PROVIDERS getAuthProvider();

    public enum AUTH_PROVIDERS {
        EMAIL_AND_PASSWORD,
        GOOGLE
    }
}