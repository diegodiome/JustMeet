package com.diegodiome.justmeet_backend.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;

import com.diegodiome.justmeet_backend.model.EventOrganizer;
import com.diegodiome.justmeet_backend.model.User;
import com.diegodiome.justmeet_backend.model.UserAuthenticated;
import com.diegodiome.justmeet_backend.util.FirestoreConstants;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.FieldValue;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.firebase.cloud.FirestoreClient;

import org.springframework.stereotype.Service;

@Service
public class FirestoreUserService implements FirestoreService<User, String> {

    Firestore db;
    CollectionReference usersCollection;

    public FirestoreUserService() {
        this.db = FirestoreClient.getFirestore();
    }

    @Override
    public void create(User document) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(document.getUserId()).set(new HashMap<String, Object>() {
            private static final long serialVersionUID = 1L;
            {
                put(FirestoreConstants.USER_EMAIL_FIELD, document.getUserEmail());
                put(FirestoreConstants.USER_BANNED_FIELD, document.isBanned());
                put(FirestoreConstants.USER_AUTH_PROVIDER_FIELD, document.getAuthProvider().toString());
            }
        });
    }

    @Override
    public User get(String documentId) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        DocumentReference user = usersCollection.document(documentId);
        if(user.get().get().contains(FirestoreConstants.USER_EVENTS_FIELD)) {
            return user.get().get().toObject(EventOrganizer.class);
        }
        return user.get().get().toObject(UserAuthenticated.class);
    }

    @Override
    public List<User> getAll() throws InterruptedException, ExecutionException {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        List<User> allUsers = new ArrayList<>();
        List<QueryDocumentSnapshot> documents = usersCollection.get().get().getDocuments();
        for(QueryDocumentSnapshot document : documents) {
            if(document.contains(FirestoreConstants.USER_EVENTS_FIELD)) {
                EventOrganizer eventOrganizer = document.toObject(EventOrganizer.class);
                eventOrganizer.setUserId(document.getId());
                allUsers.add(eventOrganizer);
            } else {
                UserAuthenticated user = document.toObject(UserAuthenticated.class);
                user.setUserId(document.getId());
                allUsers.add(user);
            }
        }
        return allUsers;
    }

    @Override
    public void update(User documentUpdated) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(documentUpdated.getUserId()).set(documentUpdated);
    }

    @Override
    public void remove(String documentId) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(documentId).delete();
    }

    public void addEvent(String userId, String eventId) {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(userId)
            .update(FirestoreConstants.USER_EVENTS_FIELD, FieldValue.arrayUnion(eventId));
    }

    public void banUser(String userId) {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(userId)
            .update(FirestoreConstants.USER_BANNED_FIELD, true);
    }
}