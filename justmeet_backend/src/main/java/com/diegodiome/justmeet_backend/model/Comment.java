
package com.diegodiome.justmeet_backend.model;

import java.util.Date;

import javax.persistence.Id;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonFormat;

public class Comment {

    @Id 
    private String commentId;

    @NotNull
    private String commentCreator;

    @NotNull
    private String commentBody;

    @NotNull
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:SS")
    private Date commentDate;

    @NotNull
    private String eventId;

    public String getCommentId() {
        return commentId;
    }

    public void setCommentId(String commentId) {
        this.commentId = commentId;
    }

    public String getCommentCreator() {
        return commentCreator;
    }

    public void setCommentCreator(String commentCreator) {
        this.commentCreator = commentCreator;
    }

    public String getCommentBody() {
        return commentBody;
    }

    public void setCommentBody(String commentBody) {
        this.commentBody = commentBody;
    }

    public String getEventId() {
        return eventId;
    }

    public void setEventId(String eventId) {
        this.eventId = eventId;
    }

    public Date getCommentDate() {
        return commentDate;
    }

    public void setCommentDate(Date commentDate) {
        this.commentDate = commentDate;
    }
}