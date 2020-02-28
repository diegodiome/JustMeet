package com.diegodiome.justmeet_backend.model;

import javax.validation.constraints.NotNull;

public class EventReporting extends Reporting {

    @NotNull
    private String eventId;

    public EventReporting( String reportingContent, String reportingCreator) {
        super(reportingContent, reportingCreator);
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

}