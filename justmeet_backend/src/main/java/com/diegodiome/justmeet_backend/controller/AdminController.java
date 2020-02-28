package com.diegodiome.justmeet_backend.controller;

import java.util.List;
import java.util.concurrent.ExecutionException;

import com.diegodiome.justmeet_backend.model.User;
import com.diegodiome.justmeet_backend.service.FirestoreUserService;
import com.diegodiome.justmeet_backend.util.ApiConstants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PutMapping;


@RestController
@RequestMapping(value = ApiConstants.API_ADMIN)
public class AdminController {

    @Autowired
    FirestoreUserService firestoreUserService;

    @GetMapping(value = ApiConstants.API_ALL_USERS)
    public List<User> getAllUsers() {
        try {
            return firestoreUserService.getAll();
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    @DeleteMapping(value = ApiConstants.API_REMOVE_USER)
    public void removeUser(@PathVariable("userId") String userId) {
        try {
            firestoreUserService.remove(userId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @PutMapping(value = ApiConstants.API_BAN_USER)
    public void banUser(@PathVariable("userId")String userId) {
        firestoreUserService.banUser(userId);
    }
}