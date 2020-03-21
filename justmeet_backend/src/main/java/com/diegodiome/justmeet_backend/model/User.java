package com.diegodiome.justmeet_backend.model;

import java.util.List;

public class User {

    String userUid;
    String userEmail;
    String userDisplayName;
    String userPhotoUrl;
    String userToken;
    String userStatus;
    Boolean userBanned;
    List<String> userEvents;

    public String getUserUid() {
        return userUid;
    }

    public void setUserUid(String userUid) {
        this.userUid = userUid;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public String getUserDisplayName() {
        return userDisplayName;
    }

    public void setUserDisplayName(String userDisplayName) {
        this.userDisplayName = userDisplayName;
    }

    public String getUserPhotoUrl() {
        return userPhotoUrl;
    }

    public void setUserPhotoUrl(String userPhotoUrl) {
        this.userPhotoUrl = userPhotoUrl;
    }

    public String getUserToken() {
        return userToken;
    }

    public void setUserToken(String userToken) {
        this.userToken = userToken;
    }

    public String getUserStatus() {
        return userStatus;
    }

    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }

    public Boolean getUserBanned() {
        return userBanned;
    }

    public void setUserBanned(Boolean userBanned) {
        this.userBanned = userBanned;
    }

    public List<String> getUserEvents() {
        return userEvents;
    }

    public void setUserEvents(List<String> userEvents) {
        this.userEvents = userEvents;
    }
}