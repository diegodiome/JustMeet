package com.diegodiome.justmeet_backend.model

data class NotificationResponse(
        var status: String,
        var message: String
) {
    constructor() : this("","")
}