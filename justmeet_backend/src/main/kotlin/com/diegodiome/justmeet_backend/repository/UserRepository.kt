package com.diegodiome.justmeet_backend.repository

import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USERS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USER_STATUS_FIELD
import com.diegodiome.justmeet_backend.model.User
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository

@Repository
class UserRepository : FirestoreRepository<User, String> {

    private val userRepositoryLogger = LoggerFactory.getLogger(UserRepository::class.java)

    private var db: Firestore = FirestoreClient.getFirestore()

    override fun addElement(element: User) {
        db.collection(USERS_COLLECTION).document(element.userId).create(element)
        userRepositoryLogger.info("[+] User with id : " + element.userId + " added")
    }

    override fun removeElement(elementId: String) {
        db.collection(USERS_COLLECTION).document(elementId).delete()
        userRepositoryLogger.info("[-] User with id : $elementId removed")
    }

    override fun updateElement(element: User) {
        db.collection(USERS_COLLECTION).document(element.userId).set(element)
        userRepositoryLogger.info("[~] User with id : " + element.userId + " updated")
    }

    override fun getElement(elementId: String) : User? {
        val docRef = db.collection(USERS_COLLECTION).document(elementId)
        val docSnap = docRef.get().get()
        if(docSnap.exists()) {
            userRepositoryLogger.info("[~] User with id : $elementId recovered")
            return docSnap.toObject(User::class.java)
        }
        return null
    }

    fun updateStatus(elementId: String, status: String) {
        db.collection(USERS_COLLECTION).document(elementId).update(USER_STATUS_FIELD, status)
        userRepositoryLogger.info("[~] User with id : $elementId stauts updated")
    }
}