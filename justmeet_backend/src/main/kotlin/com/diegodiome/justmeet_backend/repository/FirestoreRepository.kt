package com.diegodiome.justmeet_backend.repository

import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient

interface FirestoreRepository<E, T> {

    fun addElement(element: E)

    fun removeElement(elementId: T)

    fun updateElement(element: E)

    fun getElement(elementId: T) : E?
}