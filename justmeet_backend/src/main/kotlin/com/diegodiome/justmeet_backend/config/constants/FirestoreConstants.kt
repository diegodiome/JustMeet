package com.diegodiome.justmeet_backend.config.constants

object FirestoreConstants {

    /* Users collection */
    const val USERS_COLLECTION = "users"
    const val USER_STATUS_FIELD = "userStatus"
    const val USER_TOKEN_FIELD = "userToken"
    const val USER_FCM_TOKEN_FIELD = "userFcmToken"
    const val USER_NAME_FIELD = "userDisplayName"
    const val USER_REPORTS_COLLECTION = "reports"

    /* Events collection */
    const val EVENTS_COLLECTION = "events"
    const val EVENT_REQUEST_FIELD = "eventRequest"
    const val EVENT_NAME_FIELD = "eventName"
    const val EVENT_CREATOR_FIELD = "eventCreator"
    const val EVENT_PARTICIPANTS_FIELD = "eventParticipants"
    const val EVENT_RATES_FIELD = "eventRates"

    /* Comment collection */
    const val COMMENTS_COLLECTION = "comments"

    /* Event report collection */
    const val EVENT_REPORTS_COLLECTION = "reports"
}