package com.diegodiome.justmeet_backend.model

data class User (
        val userId: String,
        val userEmail: String,
        val userPhotoUrl: String,
        val userStatus: String? = null,
        val userBanned: Boolean? = null
)