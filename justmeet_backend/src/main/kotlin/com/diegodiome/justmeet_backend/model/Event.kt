package com.diegodiome.justmeet_backend.model

import com.diegodiome.justmeet_backend.model.enums.EVENT_CATEGORY
import com.fasterxml.jackson.annotation.JsonFormat
import java.util.*
import kotlin.collections.ArrayList

data class Event(
        val eventId: String? = UUID.randomUUID().toString(),
        val eventName: String,
        val eventCreator: String,
        val eventLat: Double,
        val eventLong: Double,
        val eventCategory: EVENT_CATEGORY,
        @JsonFormat(pattern = "yyyy-MM-dd HH:mm") val eventDate: Date,
        val eventDescription: String? = "",
        val eventParticipants: List<String>? = ArrayList(),
        val eventRequest: List<String>? = ArrayList()
) {
    constructor() : this("","","",0.0,0.0, EVENT_CATEGORY.Sport, Date(),"")
}