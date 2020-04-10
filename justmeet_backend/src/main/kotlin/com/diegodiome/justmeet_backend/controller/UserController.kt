package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.ADD_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.DEL_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.GET_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.S_UPD_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.UPD_USER_API
import com.diegodiome.justmeet_backend.config.constants.ApiConstants.USER_API
import com.diegodiome.justmeet_backend.model.User
import com.diegodiome.justmeet_backend.repository.UserRepository
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.web.bind.annotation.*

@RestController
@RequestMapping(value = [USER_API])
class UserController {

    @Autowired
    lateinit var userRepository: UserRepository

    @PostMapping(value = [ADD_USER_API])
    fun createUser(@RequestBody newUser: User) {
        userRepository.addElement(newUser)
    }

    @DeleteMapping(value = [DEL_USER_API])
    fun deleteUser(@PathVariable(value = "userId") userId: String) {
        userRepository.removeElement(userId)
    }

    @GetMapping(value = [GET_USER_API])
    fun getUser(@PathVariable(value = "userId") userId: String) : User? {
        return userRepository.getElement(userId)
    }

    @PutMapping(value = [UPD_USER_API])
    fun updateUser(@RequestBody updatedUser: User) {
        userRepository.updateElement(updatedUser)
    }

    @PutMapping(value = [S_UPD_USER_API])
    fun updateUserStatus(@PathVariable(value = "userId") userId: String,
                         @PathVariable(value = "status") newStatus: String) {
        userRepository.updateStatus(userId, newStatus)
    }

}