package com.diegodiome.justmeet_backend.model

import com.fasterxml.jackson.annotation.JsonFormat
import java.util.*

data class Comment(
        val commentId: String? = UUID.randomUUID().toString(),
        val commentCreator: String,
        val commentBody: String,
        val eventId: String,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm") val commentDate: Date
) {
    constructor() : this("", "", "", "", Date())
}