package com.diegodiome.justmeet_backend.model

data class User (
        val userId: String,
        val userEmail: String,
        val userDisplayName: String,
        val userPhotoUrl: String,
        val userStatus: String? = "",
        val userBanned: Boolean? = false
) {
    constructor() : this("", "", "", "", "", false)
}