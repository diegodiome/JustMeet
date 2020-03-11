package com.diegodiome.justmeet_backend.util;

import java.util.Arrays;
import java.util.List;

public class FirestoreConstants {

    /* Admin e-mails*/
    public static final List<String> adminUsers = Arrays
        .asList(
            "admin@gmail.com",
            "email@gmail.com",
            "user@gmail.com"
        );
    
    public static final String EVENTS_COLLECTION = "events";
    public static final String PARTICIPANTS_COLLECTION = "participants";
    public static final String COMMENTS_COLLECTION = "comments";
    public static final String EVENT_REPORTS_COLLECTION = "reports";
    public static final String USERS_COLLECTION = "users";
    public static final String USER_REPORTS_COLLECTION = "reports";

    public static final String PARTICIPANTS_SIGN_IN_TIME_FIELD = "signInTime";

    /* Users collection constants */
    public static final String USER_ROLE_FIELD = "userRole";
    public static final String USER_AUTH_PROVIDER_FIELD = "userProvider";
    public static final String USER_EMAIL_FIELD = "userEmail";
    public static final String USER_EVENTS_FIELD = "userEvents";
    public static final String USER_BANNED_FIELD = "banned";

    /* Comments collection constants */
    public static final String COMMENT_CREATOR_FIELD = "commentCreator";
    public static final String COMMENT_BODY_FIELD = "commentBody";
    public static final String COMMENT_DATE_FIELD = "commentDate";

    /* Reporting collection constants */
    public static final String REPORTING_CREATOR_FIELD = "reportingCreator";
    public static final String REPORTING_CONTENT_FIELD = "reportingBody";
    
    /* Events collection constants */
    public static final String EVENT_NAME_FIELD = "eventName";
    public static final String EVENT_DATE_FIELD = "eventDate";
    public static final String EVENT_CATEGORY_FIELD = "eventCategory";
    public static final String EVENT_ADMIN_FIELD = "eventAdmin";
    public static final String EVENT_LOCATION_FIELD = "eventLocation";
    public static final String EVENT_DESCRIPTION_FIELD = "eventDescription";
    public static final String EVENT_DISTANCE_FIELD = "eventDistance";
    public static final String EVENT_IMAGE_FIELD = "eventImageUrl";
    public static final String EVENT_RATING_FIELD = "eventRates";
    public static final String EVENT_IS_PRIVATE_FIELD = "eventPrivate";
    public static final String EVENT_REQUESTS_FIELD = "eventRequests";
}