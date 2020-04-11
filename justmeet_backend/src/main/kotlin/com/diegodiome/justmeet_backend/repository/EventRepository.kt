package com.diegodiome.justmeet_backend.repository

import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.COMMENTS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.EVENTS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.EVENT_REPORTS_COLLECTION
import com.diegodiome.justmeet_backend.model.Comment
import com.diegodiome.justmeet_backend.model.Event
import com.diegodiome.justmeet_backend.model.EventReporting
import com.google.cloud.firestore.FieldValue
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
        val colRef = db.collection(EVENTS_COLLECTION)
        val docsSnap = colRef.get().get().documents
        val events = ArrayList<Event>()
        for(doc in docsSnap) {
            val event = doc.toObject(Event::class.java)
            if(event.eventDate.after(Date())) {
                events.add(event)
            }
        }
        eventRepositoryLogger.info("[~] Events recovered")
        return events
    }

    fun addComment(elementId: String, newComment: Comment) {
        val docRef = db.collection(EVENTS_COLLECTION).document(elementId)
                .collection(COMMENTS_COLLECTION).document(newComment.commentId!!)
        docRef.create(newComment)
        eventRepositoryLogger.info("[+] Comment with id : " + newComment.commentId + " added")
    }

    fun getComments(elementId: String) : List<Comment> {
        val colRef = db.collection(EVENTS_COLLECTION).document(elementId)
                .collection(COMMENTS_COLLECTION)
        val docsSnap = colRef.get().get().documents
        val comments = ArrayList<Comment>()
        for(doc in docsSnap) {
            comments.add(doc.toObject(Comment::class.java))
        }
        eventRepositoryLogger.info("[~] Comments recovered")
        return comments
    }

    fun addReporting(elementId: String, newReporting: EventReporting) {
        val docRef = db.collection(EVENTS_COLLECTION).document(elementId)
                .collection(FirestoreConstants.EVENT_REPORTS_COLLECTION).document(newReporting.reportingId!!)
        docRef.create(newReporting)
        eventRepositoryLogger.info("[+] Reporting with id : " + newReporting.reportingId + " added")
    }

    fun getReports(elementId: String) : List<EventReporting> {
        val colRef = db.collection(EVENTS_COLLECTION).document(elementId)
                .collection(EVENT_REPORTS_COLLECTION)
        val docsSnap = colRef.get().get().documents
        val reports = ArrayList<EventReporting>()
        for(doc in docsSnap) {
            reports.add((doc.toObject(EventReporting::class.java)))
        }
        eventRepositoryLogger.info("[~] Reports recovered")
        return reports
    }

    fun addRequest(elementId: String, userId: String) {
        val docRef = db.collection(EVENTS_COLLECTION).document(elementId)
        docRef.update(FirestoreConstants.EVENT_REQUEST_FIELD, FieldValue.arrayUnion(userId))
        eventRepositoryLogger.info("[+] Request to event with id : $elementId added")
    }
}