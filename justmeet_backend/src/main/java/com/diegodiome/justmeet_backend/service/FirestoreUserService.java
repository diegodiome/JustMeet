package com.diegodiome.justmeet_backend.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;
import com.diegodiome.justmeet_backend.model.User;
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
        usersCollection.document(document.getUserUid()).set(new HashMap<String, Object>() {
            private static final long serialVersionUID = 1L;
            {
                put(FirestoreConstants.USER_EMAIL_FIELD, document.getUserEmail());
                put(FirestoreConstants.USER_DISPLAY_NAME_FIELD, document.getUserDisplayName());
                put(FirestoreConstants.USER_BANNED_FIELD, false);
                put(FirestoreConstants.USER_PHOTO_URL_FIELD, document.getUserPhotoUrl());
                put(FirestoreConstants.USER_STATUS_FIELD, document.getUserStatus());
                put(FirestoreConstants.USER_TOKEN_FIELD, document.getUserToken());
            }
        });
    }

    @Override
    public User get(String documentId) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        DocumentReference user = usersCollection.document(documentId);
        return user.get().get().toObject(User.class);
    }

    @Override
    public List<User> getAll() throws InterruptedException, ExecutionException {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        List<User> allUsers = new ArrayList<>();
        List<QueryDocumentSnapshot> documents = usersCollection.get().get().getDocuments();
        for (QueryDocumentSnapshot document : documents) {
            User currentUser = document.toObject(User.class);
            allUsers.add(currentUser);
        }
        return allUsers;
    }

    @Override
    public void update(User documentUpdated) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(documentUpdated.getUserUid()).set(
            new HashMap<String, Object> () {
                private static final long serialVersionUID = 1L;
                {
                    put(FirestoreConstants.USER_EMAIL_FIELD , documentUpdated.getUserEmail());
                    put(FirestoreConstants.USER_DISPLAY_NAME_FIELD, documentUpdated.getUserDisplayName());
                    put(FirestoreConstants.USER_TOKEN_FIELD, documentUpdated.getUserToken());
                    put(FirestoreConstants.USER_PHOTO_URL_FIELD, documentUpdated.getUserPhotoUrl());
                    put(FirestoreConstants.USER_STATUS_FIELD, documentUpdated.getUserStatus());
                }
            }
        );
    }

    public void updateStatus(String userUid, String status) {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(userUid).update(
            FirestoreConstants.USER_STATUS_FIELD, status
        );
    }

    @Override
    public void remove(String documentId) throws Exception {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(documentId).delete();
    }

    public void addEvent(String userId, String eventId) {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(userId).update(FirestoreConstants.USER_EVENTS_FIELD, FieldValue.arrayUnion(eventId));
    }

    public void banUser(String userId) {
        usersCollection = db.collection(FirestoreConstants.USERS_COLLECTION);
        usersCollection.document(userId).update(FirestoreConstants.USER_BANNED_FIELD, true);
    }
}