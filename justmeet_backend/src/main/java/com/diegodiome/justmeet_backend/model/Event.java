
package com.diegodiome.justmeet_backend.model;

import java.util.Date;
import java.util.List;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Event {

    @Id
    private String eventId;

    @NotNull
    @Size(min = 4, max = 20)
    private String eventName;

    @NotNull
    private String eventAdmin;
    
    private String eventDescription;

    private List<Double> eventRates;

    private List<String> eventRequests;

    @NotNull
    private String eventImageUrl;

    @NotNull
    private boolean eventPrivate;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:SS")
    private Date eventDate;

    @NotNull
    private String eventLocation;

    @NotNull
    private Category eventCategory;

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public String getEventName() {
        return eventName;
    }

    public void setEventName(String eventName) {
        this.eventName = eventName;
    }

    public String getEventAdmin() {
        return eventAdmin;
    }

    public void setEventAdmin(String eventAdmin) {
        this.eventAdmin = eventAdmin;
    }

    public Date getEventDate() {
        return eventDate;
    }

    public void setEventDate(Date eventDate) {
        this.eventDate = eventDate;
    }

    public String getEventLocation() {
        return eventLocation;
    }

    public void setEventLocation(String eventLocation) {
        this.eventLocation = eventLocation;
    }

    public Category getEventCategory() {
        return eventCategory;
    }

    public void setEventCategory(Category eventCategory) {
        this.eventCategory = eventCategory;
    }

    public String getEventDescription() {
        return eventDescription;
    }

    public void setEventDescription(String eventDescription) {
        this.eventDescription = eventDescription;
    }

    public List<Double> getEventRates() {
        return eventRates;
    }

    public void setEventRating(List<Double> eventRates) {
        this.eventRates = eventRates;
    }

    public String getEventImageUrl() {
        return eventImageUrl;
    }

    public void setEventImageUrl(String eventImageUrl) {
        this.eventImageUrl = eventImageUrl;
    }

    public boolean getEventPrivate() {
        return eventPrivate;
    }

    public void setPrivate(boolean eventPrivate) {
        this.eventPrivate = eventPrivate;
    }

    public void setEventRates(List<Double> eventRates) {
        this.eventRates = eventRates;
    }

    public List<String> getEventRequests() {
        return eventRequests;
    }

    public void setEventRequests(List<String> eventRequests) {
        this.eventRequests = eventRequests;
    }

    public void setEventPrivate(boolean eventPrivate) {
        this.eventPrivate = eventPrivate;
    }
}