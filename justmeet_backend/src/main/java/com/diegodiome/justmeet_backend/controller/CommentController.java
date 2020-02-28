package com.diegodiome.justmeet_backend.controller;

import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;

import com.diegodiome.justmeet_backend.model.Comment;
import com.diegodiome.justmeet_backend.service.FirestoreCommentService;
import com.diegodiome.justmeet_backend.util.ApiConstants;
import com.diegodiome.justmeet_backend.util.MessageConstants;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

@RestController
@RequestMapping(value = ApiConstants.API_EVENT_COMMENT)
public class CommentController {

    @Autowired
    private FirestoreCommentService firestoreService;

    private static final Logger LOGGER = Logger.getLogger(FirestoreCommentService.class.getName());

    @PostMapping(value = ApiConstants.API_ADD_COMMENT, consumes = "application/json")
    public void addComment(@RequestBody Comment newComment) {
        try {
            firestoreService.create(newComment);
            LOGGER.log(Level.INFO, MessageConstants.EVENT_COMMENT_CREATED);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @GetMapping(value = ApiConstants.API_GET_COMMENTS, produces = "application/json")
    public List<Comment> getAllComments(@PathVariable("eventId") String eventId) {
        try {
            return firestoreService.getAllBy(eventId);
        } catch (InterruptedException | ExecutionException e) {
            e.printStackTrace();
        }
        return null;
    }

    @PreAuthorize("hasAnyAuthority('ADMIN')")
    @DeleteMapping(value = ApiConstants.API_REMOVE_COMMENT)
    public void removeComment(@PathVariable("eventId") String eventId, @PathVariable("commentId") String commentId) {
        try {
            firestoreService.remove(new HashMap<String, String>() {
                private static final long serialVersionUID = 1L;
                {
                    put(FirestoreCommentService.COMMENT_EVENT_ID_MAP_KEY, eventId);
                    put(FirestoreCommentService.COMMENT_ID_MAP_KEY, commentId);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
}