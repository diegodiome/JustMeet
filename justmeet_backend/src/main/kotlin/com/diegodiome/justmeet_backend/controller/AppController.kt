package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_PRD_API
import com.diegodiome.justmeet_backend.model.AutoCompleteItems
import com.diegodiome.justmeet_backend.repository.EventRepository
import com.diegodiome.justmeet_backend.repository.UserRepository
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

@RestController
class AppController  {

    private val appControllerLogger = LoggerFactory.getLogger(AppController::class.java)

    @Autowired
    lateinit var eventRepository: EventRepository

    @Autowired
    lateinit var userRepository: UserRepository

    @GetMapping(value = [GET_PRD_API])
    fun getPredictions(@PathVariable(value = "text") text: String) : AutoCompleteItems {
        val items = eventRepository.getSearchPredictions(text).predictions.union(userRepository.getSearchPredictions(text).predictions).toList()
        print(items)
        return AutoCompleteItems(predictions = items)
    }
}