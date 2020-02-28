package com.diegodiome.justmeet_backend.model;


import java.util.List;
import javax.validation.constraints.NotNull;

public class EventOrganizer extends UserAuthenticated {

    @NotNull
    private List<String> userEvents;

    public List<String> getUserEvents() {
        return userEvents;
    }

    public void setUserEvents(List<String> userEvents) {
        this.userEvents = userEvents;
    }
}