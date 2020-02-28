package com.diegodiome.justmeet_backend.controller;

import java.util.List;
import java.util.concurrent.ExecutionException;

import com.diegodiome.justmeet_backend.model.UserReporting;
import com.diegodiome.justmeet_backend.service.FirestoreUserReportingService;
import com.diegodiome.justmeet_backend.util.ApiConstants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping(value = ApiConstants.API_USER_REPORTING)
public class UserReportingController {

    @Autowired
    private FirestoreUserReportingService firestoreService;

    @PostMapping(value = ApiConstants.API_ADD_USER_REPORTING, consumes = "application/json")
    public void createReporting(@RequestBody UserReporting reporting) {
        try {
            firestoreService.create(reporting);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    @PreAuthorize("hasAnyAuthority('ADMIN')")
    @GetMapping(value =  ApiConstants.API_GET_REPORTS_FOR, produces = "application/json")
    public List<UserReporting> getReportsBy(@PathVariable("userId")String userId) {
        try {
            return firestoreService.getAllByUser(userId);
        }
        catch(InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }
}