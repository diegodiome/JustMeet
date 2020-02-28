package com.diegodiome.justmeet_backend.controller;

import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.diegodiome.justmeet_backend.model.Category;
import com.diegodiome.justmeet_backend.model.Event;
import com.diegodiome.justmeet_backend.model.EventReporting;
import com.diegodiome.justmeet_backend.service.FirestoreEventService;
import com.diegodiome.justmeet_backend.util.ApiConstants;
import com.diegodiome.justmeet_backend.util.MessageConstants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

@RestController
@RequestMapping(value = ApiConstants.API_EVENTS)
public class EventController {

    @Autowired
    private FirestoreEventService firestoreService;

    private static final Logger LOGGER = Logger.getLogger(FirestoreEventService.class.getName());

    @PostMapping(value = ApiConstants.API_ADD_EVENT, consumes = "application/json")
    public void creteEvent(@RequestBody Event event) {
        try {
            firestoreService.create(event);
            LOGGER.log(Level.WARNING, MessageConstants.EVENT_CREATED_MESSAGE);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, MessageConstants.EVENT_CREATED_ERROR_MESSAGE);
            e.printStackTrace();
        }
    }

    @DeleteMapping(value = ApiConstants.API_REMOVE_EVENT)
    public void removeEvent(@PathVariable("eventId") String eventId) {
        try {
            firestoreService.remove(eventId);
            LOGGER.log(Level.WARNING, MessageConstants.EVENT_CORRECT_REMOVED_MESSAGE);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = ApiConstants.API_GET_EVENT_BY_ID, produces = "application/json")
    public Event getEventById(@PathVariable("eventId") String eventId) {
        try {
            return firestoreService.get(eventId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @GetMapping(value = ApiConstants.API_GET_ALL_EVENTS, produces = "application/json")
    public List<Event> getEvents() {
        try {
            return firestoreService.getAll();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    @PutMapping(value = ApiConstants.API_UPDATE_EVENT, consumes = "application/json")
    public void updateEvent(@RequestBody Event event) {
        try {
            firestoreService.update(event);
            LOGGER.log(Level.WARNING, MessageConstants.EVENT_CORRECT_UPDATED_MESSAGE);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = ApiConstants.API_GET_EVENT_BY_CATEGORY, produces = "application/json")
    public List<Event> getEventsByCategory(@PathVariable("eventCategory") Category category) {
        try {
            return firestoreService.getAllBy(category);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    @PostMapping(value = ApiConstants.API_JOIN_EVENT)
    public void enterEvent(@PathVariable("eventId") String eventId, @Value("displayName") String displayName) {
        try {
            firestoreService.joinEvent(displayName, eventId);
            LOGGER.log(Level.INFO, MessageConstants.EVENT_CORRECT_JOINED);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
    }

    @PostMapping(value = ApiConstants.API_REPORTING_EVENT, consumes = "application/json")
    public void reportEvent(@RequestBody EventReporting eventReporting) {
        try {
            firestoreService.addReporting(eventReporting);
            LOGGER.log(Level.INFO, MessageConstants.EVENT_COMMENT_CREATED);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = ApiConstants.API_GET_EVENT_AVERAGE_RATE, produces = "application/json")
    public double getEventAverageRate(@PathVariable("eventId") String eventId) {
        try {
            return firestoreService.getAverageRate(eventId);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return 0;
    }
}