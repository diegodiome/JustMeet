package com.diegodiome.justmeet_backend.util;

public class ApiConstants {

    public static final String API_V = "/v1";

    public static final String API = "/api" + API_V;
    public static final String API_ADMIN = API + "/admin";
    public static final String API_EVENTS = API + "/events";
    public static final String API_USER = API + "/user";
    public static final String API_EVENT_COMMENT = API_EVENTS + "/comments";

    /* Api admin */
    public static final String API_ALL_USERS = "/users/all";
    public static final String API_REMOVE_USER = "/users/remove/userId={userId}";
    public static final String API_BAN_USER = "/users/ban/userId={userId}";

    /* Api comments */
    public static final String API_ADD_COMMENT = "/add";
    public static final String API_GET_COMMENTS = "/eventId={eventId}/all";
    public static final String API_GET_COMMENT = "/eventId={eventId}&commentId={commentId}";
    public static final String API_REMOVE_COMMENT = "/eventId={eventId}&commentId={commentId}";

    /* Api user */
    public static final String API_ADD_USER = "/add";
    public static final String API_USER_ADD_EVENT = "/userId={userId}&eventId={eventId}";
    public static final String API_UPDATE_USER = "/update";
    public static final String API_GET_USER =  "/userId={userId}";

    /* Api user reporting */
    public static final String API_USER_REPORTING = API_USER + "/reporting";
    public static final String API_ADD_USER_REPORTING = "/add";
    public static final String API_GET_USER_REPORTS = "/all";
    public static final String API_GET_REPORTS_FOR = "all/userId={userId}";
    
    /* Api event */
    public static final String API_ADD_EVENT = "/add";
    public static final String API_UPDATE_EVENT = "/update/id={eventId}&{fieldName}={updatedValue}";
    public static final String API_GET_ALL_EVENTS = "/all";
    public static final String API_GET_EVENT_BY_CATEGORY = "/category={eventCategory}";
    public static final String API_GET_EVENT_BY_ID = "/id={eventId}";
    public static final String API_REMOVE_EVENT = "/remove/id={eventId}";
    public static final String API_JOIN_EVENT = "/join/id={eventId}&displayName={displayName}";
    public static final String API_REPORTING_EVENT = "/report";
    public static final String API_GET_EVENT_AVERAGE_RATE = "/rate/eventId={eventId}";
    public static final String API_GET_EVENT_REQUESTS = "/requests/eventId={eventId}";
    public static final String API_ADD_EVENT_REQUESTS = "/requests/add/eventId={eventId}&userEmail={userEmail}";
}