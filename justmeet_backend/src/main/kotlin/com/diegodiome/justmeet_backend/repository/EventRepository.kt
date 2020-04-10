package com.diegodiome.justmeet_backend.repository

import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.EVENTS_COLLECTION
import com.diegodiome.justmeet_backend.model.Event
import com.google.firebase.cloud.FirestoreClient
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Repository
import java.util.*
import kotlin.collections.ArrayList

@Repository
class EventRepository : FirestoreRepository<Event, String> {

    private val eventRepositoryLogger = LoggerFactory.getLogger(EventRepository::class.java)

    private var db = FirestoreClient.getFirestore()

    override fun addElement(element: Event) {
        db.collection(EVENTS_COLLECTION).document(element.eventId!!).create(element)
        eventRepositoryLogger.info("[+] Event with id : " + element.eventId + " added")
    }

    override fun removeElement(elementId: String) {
        db.collection(EVENTS_COLLECTION).document(elementId).delete()
        eventRepositoryLogger.info("[-] Event with id : $elementId deleted")
    }

    override fun updateElement(element: Event) {
        db.collection(EVENTS_COLLECTION).document(element.eventId!!).set(element)
        eventRepositoryLogger.info("[~] Event with id : " + element.eventId + " updated")
    }

    override fun getElement(elementId: String): Event? {
        val docRef = db.collection(EVENTS_COLLECTION).document(elementId)
        val docSnap = docRef.get().get()
        if(docSnap.exists()) {
            eventRepositoryLogger.info("[~] Event with id : $elementId recovered")
            return docSnap.toObject(Event::class.java)
        }
        return null
    }

    fun getEvents() : List<Event> {
        val docRef = db.collection(EVENTS_COLLECTION)
        val docsSnap = docRef.get().get().documents
        val events = ArrayList<Event>()
        for(doc in docsSnap) {
            val event = doc.toObject(Event::class.java)
            if(event.eventDate.after(Date())) {
                events.add(doc.toObject(Event::class.java))
            }
        }
        return events
    }

}