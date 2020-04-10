package com.diegodiome.justmeet_backend.config.constants

object ApiConstants {
    const val HOMEPAGE_URL = "/"

    /* User API */
    const val USER_API = "/user"
    const val ADD_USER_API = "/signUp"
    const val DEL_USER_API = "/{userId}/delete"
    const val UPD_USER_API = "/update"
    const val S_UPD_USER_API = "/{userId}&{status}/update"
    const val GET_USER_API = "/{userId}"
}