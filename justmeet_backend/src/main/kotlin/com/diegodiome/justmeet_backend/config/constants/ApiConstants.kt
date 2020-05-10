package com.diegodiome.justmeet_backend.config.constants

object ApiConstants {
    /* User API */
    const val USER_API = "/user"
    const val ADD_USER_API = "/signUp"
    const val DEL_USER_API = "/{userId}/delete"
    const val UPD_USER_API = "/update"
    const val T_UPD_USER_API = "/{userId}&{token}/tupdate"
    const val S_UPD_USER_API = "/{userId}&{status}/supdate"
    const val GET_USER_API = "/{userId}"
    const val GET_USR_EV_API = "/{userId}/events"
    const val ADD_USR_REP_API = "/reporting"
    const val GET_USR_REPS_API = "/{userId}/reports"
    const val ACC_REQ_API = "/{eventId}/{userId}/accept"
    const val PUT_UPD_FCM_API = "/{userId}/{fcmToken}"

    /* Event API */
    const val EVENT_API = "/event"
    const val ADD_EVENT_API = "/create"
    const val UPD_EVENT_API = "/update"
    const val GET_EVENT_API =  "/{eventId}"
    const val GET_EVENTS_API = "/all"
    const val DEL_EVENT_API = "/{eventId}/delete"
    const val ADD_COM_API = "/{eventId}/comment"
    const val GET_COMS_API = "/{eventId}/comments"
    const val ADD_REP_API = "/reporting"
    const val ADD_RATE_API = "/{eventId}/{rate}/rate"
    const val GET_REPS_API = "/{eventId}/reports"
    const val ADD_REQ_API = "/{eventId}/{userId}/request"
    const val GET_REQ_API = "/{userId}/requests"
    const val ADD_PART_API = "/{eventId}/{userId}/join"

    /* Predictions api */
    const val GET_PRD_API = "app/{text}/predictions"
}