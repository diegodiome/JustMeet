package com.diegodiome.justmeet_backend.model

data class NotificationRequest(
        var title: String,
        var message: String,
        var topic: String,
        var token: String
) {
    constructor() : this("","", "","")
}