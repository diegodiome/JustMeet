package com.diegodiome.justmeet_backend.controller;

import com.diegodiome.justmeet_backend.model.User;
import com.diegodiome.justmeet_backend.service.FirestoreUserService;
import com.diegodiome.justmeet_backend.util.ApiConstants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = ApiConstants.API_USER)
public class UserController {

    @Autowired
    FirestoreUserService firestoreService;

    @PostMapping(value = ApiConstants.API_ADD_USER, consumes = "application/json")
    public void addUser(@RequestBody User user) {
        try {
            firestoreService.create(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @PostMapping(value = ApiConstants.API_USER_ADD_EVENT)
    public void addEvent(@PathVariable("userId") String userId, @PathVariable("eventId") String eventId) {
        firestoreService.addEvent(userId, eventId);
    }

    @PostMapping(value = ApiConstants.API_UPDATE_USER, consumes = "application/json")
    public void updateUser(@RequestBody User user) {
        try {
            firestoreService.update(user);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @PostMapping(value = ApiConstants.API_UPDATE_USER_STATUS, consumes = "application/json")
    public void updateUser(
        @PathVariable("userUid") String userUid,
        @PathVariable("status") String status) {
        try {
            firestoreService.updateStatus(userUid, status);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = ApiConstants.API_GET_USER, produces = "application/json")
    public User getUser(@PathVariable("userId") String userId) {
        try {
            return firestoreService.get(userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}