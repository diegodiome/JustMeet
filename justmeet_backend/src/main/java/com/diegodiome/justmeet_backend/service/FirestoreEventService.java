package com.diegodiome.justmeet_backend.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.diegodiome.justmeet_backend.model.Category;
import com.diegodiome.justmeet_backend.model.Event;
import com.diegodiome.justmeet_backend.model.EventReporting;
import com.diegodiome.justmeet_backend.util.FirestoreConstants;
import com.diegodiome.justmeet_backend.util.MessageConstants;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;

import org.springframework.stereotype.Service;

@Service
public class FirestoreEventService implements FirestoreService<Event, String> {

    private Firestore db;
    private CollectionReference eventsReference;

    private static final Logger LOGGER = Logger.getLogger(FirestoreEventService.class.getName());

    public FirestoreEventService() {
        this.db = FirestoreClient.getFirestore();
    }

    @Override
    public void create(final Event document) throws Exception {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference documentReference = eventsReference.document();
        joinEvent(document.getEventAdmin(), documentReference.getId());
        final Map<String, Object> data = new HashMap<>();
        data.put(FirestoreConstants.EVENT_NAME_FIELD, document.getEventName());
        data.put(FirestoreConstants.EVENT_ADMIN_FIELD, document.getEventAdmin());
        data.put(FirestoreConstants.EVENT_DESCRIPTION_FIELD, document.getEventDescription());
        data.put(FirestoreConstants.EVENT_IMAGE_FIELD, document.getEventImageUrl());
        data.put(FirestoreConstants.EVENT_DATE_FIELD, document.getEventDate());
        data.put(FirestoreConstants.EVENT_LOCATION_FIELD, document.getEventLocation());
        data.put(FirestoreConstants.EVENT_CATEGORY_FIELD, document.getEventCategory().toString());
        data.put(FirestoreConstants.EVENT_IS_PRIVATE_FIELD, document.getEventPrivate());
        documentReference.set(data);
    }

    @Override
    public Event get(final String documentId) throws Exception {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference documentReference = eventsReference.document(documentId);
        final ApiFuture<DocumentSnapshot> future = documentReference.get();
        final DocumentSnapshot document = future.get();
        if (!document.exists()) {
            LOGGER.log(Level.WARNING, MessageConstants.EVENT_NOT_FOUND_MESSAGE);
            return null;
        }
        final Event event = document.toObject(Event.class);
        event.setEventId(documentId);
        return event;
    }

    @Override
    public List<Event> getAll() throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final ApiFuture<QuerySnapshot> future = eventsReference.get();
        final List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        final List<Event> events = new ArrayList<>();
        for (final QueryDocumentSnapshot document : documents) {
            final Event event = document.toObject(Event.class);
            event.setEventId(document.getId());
            events.add(event);
        }
        return events;
    }

    public List<Event> getAllBy(final Category documentCategory) throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final List<Event> events = new ArrayList<>();
        final ApiFuture<QuerySnapshot> future = eventsReference
                .whereEqualTo(FirestoreConstants.EVENT_CATEGORY_FIELD, documentCategory.toString()).get();
        final List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        for (final QueryDocumentSnapshot document : documents) {
            final Event event = document.toObject(Event.class);
            event.setEventId(document.getId());
            events.add(event);
        }
        return events;
    }

    @Override
    public void update(final Event documentUpdated) throws Exception {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference documentReference = eventsReference.document(documentUpdated.getEventId());
        documentReference.set(documentUpdated);
    }

    @Override
    public void remove(final String documentId) throws Exception {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference documentReference = eventsReference.document(documentId);
        documentReference.delete();
    }

    public List<Event> getAllFrom(final String documentCreator) throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final List<Event> events = new ArrayList<>();
        final ApiFuture<QuerySnapshot> future = eventsReference
                .whereEqualTo(FirestoreConstants.EVENT_ADMIN_FIELD, documentCreator).get();
        final List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        for (final QueryDocumentSnapshot document : documents) {
            final Event event = document.toObject(Event.class);
            event.setEventId(document.getId());
            events.add(event);
        }
        return events;
    }

    public void joinEvent(final String displayName, final String documentId)
            throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference participant = eventsReference.document(documentId)
                .collection(FirestoreConstants.PARTICIPANTS_COLLECTION).document(displayName);
        if (!participant.get().get().exists()) {
            participant.set(new HashMap<String, Object>() {
                private static final long serialVersionUID = 1L;
                {
                    put(FirestoreConstants.PARTICIPANTS_SIGN_IN_TIME_FIELD, new Date());
                }
            });
        }
    }

    public void addReporting(final EventReporting document) throws Exception {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final DocumentReference reporting = eventsReference.document(document.getEventId())
                .collection(FirestoreConstants.EVENT_REPORTS_COLLECTION).document();
        reporting.set(new HashMap<String, Object>() {
            private static final long serialVersionUID = 1L;
            {
                put(FirestoreConstants.REPORTING_CREATOR_FIELD, document.getReportingCreator());
                put(FirestoreConstants.REPORTING_CONTENT_FIELD, document.getReportingBody());
            }
        });
    }

    public List<EventReporting> getAllReportsBy(final String documentId)
            throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        final CollectionReference reportsCollection = eventsReference.document(documentId)
                .collection(FirestoreConstants.EVENT_REPORTS_COLLECTION);
        final List<QueryDocumentSnapshot> documents = reportsCollection.get().get().getDocuments();
        final List<EventReporting> reports = new ArrayList<>();
        for (final QueryDocumentSnapshot document : documents) {
            final EventReporting reporting = document.toObject(EventReporting.class);
            reporting.setReportingId(document.getId());
            reports.add(reporting);
        }
        return reports;
    }

    public void addRequest(final String eventId, final String userEmail) {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        eventsReference.document(eventId)
            .update(FirestoreConstants.EVENT_REQUESTS_FIELD, FieldValue.arrayUnion(userEmail));
    }

    public double getAverageRate(final String eventId) throws InterruptedException, ExecutionException {
        eventsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION);
        DocumentSnapshot event = eventsReference.document(eventId).get().get();
        double sum = 0;
        if (event.contains(FirestoreConstants.EVENT_RATING_FIELD)) {
            if(event.get(FirestoreConstants.EVENT_RATING_FIELD) instanceof ArrayList) {
                ArrayList<?> ratesObject = (ArrayList<?>) event.get(FirestoreConstants.EVENT_RATING_FIELD);
                for(Object val : ratesObject) {
                    if(val instanceof Double) {
                        sum += (double)val;
                    }
                    else {
                        sum += Long.valueOf((Long)val).doubleValue();
                    }
                }
                return sum / ratesObject.size();
            }
        }
        return 0;
    }
}