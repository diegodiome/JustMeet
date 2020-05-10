package com.diegodiome.justmeet_backend.util

import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseToken

class SecurityUtils {

    companion object {
        val instance = SecurityUtils()
    }

    fun checkToken(token: String, other: String) : Boolean{
        val firebaseToken = FirebaseAuth.getInstance().verifyIdTokenAsync(token).get()
        if(firebaseToken.uid.compareTo(other) == 0) {
            return true
        }
        return false
    }
}