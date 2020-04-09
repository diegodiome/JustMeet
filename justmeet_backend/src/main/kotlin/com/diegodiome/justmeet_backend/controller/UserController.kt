package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.USER_API
import com.diegodiome.justmeet_backend.model.User
import com.diegodiome.justmeet_backend.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@RestController
@RequestMapping(value = [USER_API])
class UserController {

    @Autowired
    lateinit var userRepository: UserRepository

    @PostMapping(value = [ADD_USER_API])
    fun createUser(@RequestBody newUser: User) {
        userRepository.addElement(newUser)
    }

}