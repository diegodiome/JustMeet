package com.diegodiome.justmeet_backend.repository

import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USERS_COLLECTION
import com.diegodiome.justmeet_backend.model.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.springframework.stereotype.Repository

@Repository
class UserRepository : FirestoreRepository<User, String> {

    private var db: Firestore = FirestoreClient.getFirestore()

    override fun addElement(element: User) {
        db.collection(USERS_COLLECTION).document().create(element)
    }

    override fun removeElement(elementId: String) {
        TODO("Not yet implemented")
    }

    override fun updateElement(element: User) {
        TODO("Not yet implemented")
    }

    override fun getElement(elementId: String) {
        TODO("Not yet implemented")
    }

}