package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_EVENTS_API
import com.diegodiome.justmeet_backend.model.Event
import com.diegodiome.justmeet_backend.repository.EventRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(value = [EVENT_API])
class EventController  {

    @Autowired
    lateinit var eventRepository: EventRepository

    @PostMapping(value = [ADD_EVENT_API])
    fun createEvent(@RequestBody newEvent: Event) {
        eventRepository.addElement(newEvent)
    }

    @GetMapping(value = [GET_EVENTS_API])
    fun getEvents() : List<Event> {
        return eventRepository.getEvents()
    }
}