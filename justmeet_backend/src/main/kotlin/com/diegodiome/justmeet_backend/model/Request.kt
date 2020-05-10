package com.diegodiome.justmeet_backend.model

data class Request(
        val userId: String,
        var eventId: String,
        var event: Event? = null,
        var user: User? = null
) {
    constructor() : this("","")
}