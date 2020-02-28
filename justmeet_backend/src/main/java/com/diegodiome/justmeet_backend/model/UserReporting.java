package com.diegodiome.justmeet_backend.model;

import javax.validation.constraints.NotNull;

public class UserReporting extends Reporting{

    @NotNull
    private String userId;

    public UserReporting() {}

    public UserReporting(String reportingBody, String reportingCreator) {
        super(reportingBody, reportingCreator);
    }

    public String getUserId() {
        return userId;
    }

    public void setUserId(String userId) {
        this.userId = userId;
    }
}