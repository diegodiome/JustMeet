package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_COM_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_REP_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_REQ_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.DEL_EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_COMS_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_EVENTS_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_EVENT_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_PRD_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_REPS_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.UPD_EVENT_API
import com.diegodiome.justmeet_backend.model.*
import com.diegodiome.justmeet_backend.repository.EventRepository
import com.diegodiome.justmeet_backend.util.SecurityUtils
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(value = [EVENT_API])
class EventController  {

    private val eventControllerLogger = LoggerFactory.getLogger(EventController::class.java)

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

    @GetMapping(value = [GET_EVENT_API])
    fun getEvent(@PathVariable("eventId") eventId: String) : Event? {
        return eventRepository.getElement(eventId)
    }

    @PutMapping(value = [UPD_EVENT_API])
    fun updateEvent(@RequestBody eventUpdated: Event) {
        eventRepository.updateElement(eventUpdated)
    }

    @DeleteMapping(value = [DEL_EVENT_API])
    fun deleteEvent(@PathVariable("eventId") eventId: String) {
        eventRepository.removeElement(eventId)
    }

    @PostMapping(value = [ADD_COM_API])
    fun addComment(@RequestHeader("Authorization") token: String,
                   @PathVariable("eventId") eventId: String,
                   @RequestBody newComment: Comment) {
        if(SecurityUtils().checkToken(token, newComment.commentCreator)) {
            eventRepository.addComment(eventId, newComment)
            return
        }
        eventControllerLogger.warn("[+] User with id : " + newComment.commentCreator + " try to add comment without permission")
    }

    @GetMapping(value = [GET_COMS_API])
    fun getComments(@PathVariable("eventId") eventId: String) : List<Comment> {
        return eventRepository.getComments(eventId)
    }

    @PostMapping(value = [ADD_REP_API])
    fun addReporting(@PathVariable("eventId") eventId: String,
                     @RequestBody newReporting: EventReporting) {
        eventRepository.addReporting(eventId, newReporting)
    }

    @GetMapping(value = [GET_REPS_API])
    fun getReports(@PathVariable("eventId") eventId: String) : List<EventReporting> {
        return eventRepository.getReports(eventId)
    }

    @PutMapping(value = [ADD_REQ_API])
    fun addRequest(@PathVariable("eventId") eventId: String
                   , @PathVariable("userId") userId: String) {
        eventRepository.addRequest(eventId, userId)
    }

    @GetMapping(value = [GET_PRD_API])
    fun getPredictions(@PathVariable(value = "text") text: String) : AutoCompleteItems {
        return eventRepository.getSearchPredictions(text)
    }

}