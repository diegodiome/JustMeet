package com.diegodiome.justmeet_backend.model;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;

public class Reporting {

    @Id 
    private String reportingId;

    @NotNull
    private String reportingBody;

    @NotNull
    private String reportingCreator;

    public Reporting() {}

    public Reporting(String reportingBody, String reportingCreator) {
        this.reportingBody = reportingBody;
        this.reportingCreator = reportingCreator;
    }

    public String getReportingId() {
        return reportingId;
    }

    public void setReportingId(String reportingId) {
        this.reportingId = reportingId;
    }


    public String getReportingCreator() {
        return reportingCreator;
    }

    public void setReportingCreator(String reportingCreator) {
        this.reportingCreator = reportingCreator;
    }

    public String getReportingBody() {
        return reportingBody;
    }

    public void setReportingBody(String reportingBody) {
        this.reportingBody = reportingBody;
    }
}