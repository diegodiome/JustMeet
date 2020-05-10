package com.diegodiome.justmeet_backend.repository

import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.EVENTS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USERS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USER_REPORTS_COLLECTION
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USER_STATUS_FIELD
import com.diegodiome.justmeet_backend.config.constants.FirestoreConstants.USER_TOKEN_FIELD
import com.diegodiome.justmeet_backend.model.*
import com.diegodiome.justmeet_backend.service.FirebaseCloudMessagingService
import com.diegodiome.justmeet_backend.util.PredictionsUtils
import com.google.cloud.firestore.FieldValue
import com.google.cloud.firestore.Firestore
import com.google.firebase.cloud.FirestoreClient
import org.slf4j.LoggerFactory
import org.springframework.beans.factory.annotation.Autowired
import org.springframework.stereotype.Repository

@Repository
class UserRepository : FirestoreRepository<User, String> {

    private val userRepositoryLogger = LoggerFactory.getLogger(UserRepository::class.java)

    @Autowired
    private lateinit var fcm :FirebaseCloudMessagingService

    private var db: Firestore = FirestoreClient.getFirestore()

    @Autowired
    lateinit var eventRepository: EventRepository

    override fun addElement(element: User) {
        db.collection(USERS_COLLECTION).document(element.userUid).create(element)
        userRepositoryLogger.info("[+] User with id : " + element.userUid + " added")
    }

    override fun removeElement(elementId: String) {
        db.collection(USERS_COLLECTION).document(elementId).delete()
        userRepositoryLogger.info("[-] User with id : $elementId removed")
    }

    override fun updateElement(element: User) {
        db.collection(USERS_COLLECTION).document(element.userUid).set(element)
        userRepositoryLogger.info("[~] User with id : " + element.userUid + " updated")
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

    fun addReporting(elementId: String, newReporting: UserReporting) {
        val docRef = db.collection(USERS_COLLECTION).document(elementId)
                .collection(FirestoreConstants.USER_REPORTS_COLLECTION).document(newReporting.reportingId!!)
        docRef.create(newReporting)
        userRepositoryLogger.info("[+] Reporting with id : " + newReporting.reportingId + " added")
    }

    fun getReports(elementId: String) : List<UserReporting> {
        val colRef = db.collection(USERS_COLLECTION).document(elementId)
                .collection(USER_REPORTS_COLLECTION)
        val docsSnap = colRef.get().get().documents
        val reports = ArrayList<UserReporting>()
        for(doc in docsSnap) {
            reports.add((doc.toObject(UserReporting::class.java)))
        }
        userRepositoryLogger.info("[~] Reports recovered")
        return reports
    }

    fun updateStatus(elementId: String, status: String) {
        db.collection(USERS_COLLECTION).document(elementId).update(USER_STATUS_FIELD, status)
        userRepositoryLogger.info("[~] User with id : $elementId stauts updated")
    }

    fun updateToken(elementId: String, token: String) {
        db.collection(USERS_COLLECTION).document(elementId).update(USER_TOKEN_FIELD, token)
        userRepositoryLogger.info("[~] User with id : $elementId token updated")
    }

    fun getRequests(userId: String) : List<Request> {
        val colRef = db.collection(EVENTS_COLLECTION)
        val docsSnap = colRef.whereEqualTo(FirestoreConstants.EVENT_CREATOR_FIELD, userId).get().get().documents
        val requests = ArrayList<Request>()
        for(doc in docsSnap) {
            val event = doc.toObject(Event::class.java)
            if(event.eventRequest != null && event.eventRequest.isNotEmpty()) {
                for (request in event.eventRequest) {
                    requests.add(
                            Request(
                                    eventId = event.eventId!!,
                                    userId = request,
                                    event = eventRepository.getElement(event.eventId),
                                    user = getElement(request)
                            )
                    )
                }
            }
        }
        userRepositoryLogger.info("[~] Requests recovered")
        return requests
    }

    fun acceptRequest(userId: String, eventId: String) {
        val docRef = db.collection(EVENTS_COLLECTION).document(eventId)
        docRef.update(FirestoreConstants.EVENT_REQUEST_FIELD, FieldValue.arrayRemove(userId))
        docRef.update(FirestoreConstants.EVENT_PARTICIPANTS_FIELD, FieldValue.arrayUnion(userId))
        userRepositoryLogger.info("[+] Participant to event with id : $eventId added")
        val context = HashMap<String, String>()
        context["accept"] = userId
        fcm.sendMessage(
                data =  context,
                request = NotificationRequest("Richiesta accettata", "Utente accettato", "Eventi", getUserFcmToken(userId))
        )
        userRepositoryLogger.info("[+] Notification to user with id : $userId sended")
    }

    fun getUserFcmToken(userId: String) : String {
        return getElement(userId)!!.userFcmToken!!
    }

    fun updateFcmToken(elementId: String, fcmToken: String) {
        db.collection(USERS_COLLECTION).document(elementId).update(FirestoreConstants.USER_FCM_TOKEN_FIELD, fcmToken)
        userRepositoryLogger.info("[~] User with id : $elementId fcm token updated")
    }

    fun getSearchPredictions(text: String) : AutoCompleteItems {
        val colRef = db.collection(USERS_COLLECTION)
        val docsSnap = colRef.get().get().documents
        val usersName = ArrayList<AutoCompleteItem>()
        for(doc in docsSnap) {
            val match = PredictionsUtils().getStringMatchDetail(text, doc.get(FirestoreConstants.USER_NAME_FIELD).toString())
            if(match.length >= 2) {
                usersName.add(AutoCompleteItem(
                        text = doc.get(FirestoreConstants.USER_NAME_FIELD).toString(),
                        detail = match,
                        type = AutoCompleteItemType.User,
                        id = doc.id
                ))
            }
        }
        return AutoCompleteItems(
                predictions = usersName
        )
    }
}