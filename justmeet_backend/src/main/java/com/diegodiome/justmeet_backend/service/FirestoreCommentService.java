package com.diegodiome.justmeet_backend.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutionException;

import com.diegodiome.justmeet_backend.model.Comment;
import com.diegodiome.justmeet_backend.util.FirestoreConstants;
import com.google.api.core.ApiFuture;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.firebase.cloud.FirestoreClient;

import org.springframework.stereotype.Service;

@Service
public class FirestoreCommentService implements FirestoreService<Comment, Map<String,String>> {

    private Firestore db;
    private CollectionReference commentsReference;

    public static final String COMMENT_EVENT_ID_MAP_KEY = "EVENT_ID";
    public static final String COMMENT_ID_MAP_KEY = "COMMENT_ID";

    public FirestoreCommentService() {
        this.db = FirestoreClient.getFirestore();
    }

    @Override
    public void create(Comment document) throws Exception {
        commentsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION) 
            .document(document.getEventId())
            .collection(FirestoreConstants.COMMENTS_COLLECTION);
        DocumentReference comment = commentsReference.document();
        comment.set(new HashMap<String, Object>() {
            private static final long serialVersionUID = 1L;
            {
                put(FirestoreConstants.COMMENT_CREATOR_FIELD, document.getCommentCreator());
                put(FirestoreConstants.COMMENT_BODY_FIELD, document.getCommentBody());
                put(FirestoreConstants.COMMENT_DATE_FIELD, document.getCommentDate());
            }
        });
    }

    @Override
    public List<Comment> getAll() throws InterruptedException, ExecutionException {
        return null;
    }

    @Override
    public void update(Comment documentUpdated) throws Exception {
        commentsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION) 
            .document(documentUpdated.getEventId())
            .collection(FirestoreConstants.COMMENTS_COLLECTION);
        commentsReference.document(documentUpdated.getCommentId())
            .set(documentUpdated);
    }

    public List<Comment> getAllBy(String eventId) throws InterruptedException, ExecutionException {
        commentsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION)
            .document(eventId)
            .collection(FirestoreConstants.COMMENTS_COLLECTION);
        ApiFuture<QuerySnapshot> future = commentsReference.get();
        List<QueryDocumentSnapshot> documents = future.get().getDocuments();
        List<Comment> comments = new ArrayList<>();
        for (QueryDocumentSnapshot document : documents) {
            Comment comment = document.toObject(Comment.class);
            comment.setCommentId(document.getId());
            comment.setEventId(eventId);
            comments.add(comment);
        }
        return comments;
    }

    @Override
    public Comment get(Map<String, String> documentId) throws Exception {
        commentsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION)
            .document(documentId.get(COMMENT_EVENT_ID_MAP_KEY))
            .collection(FirestoreConstants.COMMENTS_COLLECTION);
        ApiFuture<DocumentSnapshot> future = commentsReference
            .document(documentId.get(COMMENT_ID_MAP_KEY)).get();
        if(!future.get().exists()) {
            return null;
        }
        Comment comment = future.get().toObject(Comment.class);
        comment.setCommentId(documentId.get(COMMENT_ID_MAP_KEY));
        comment.setEventId(documentId.get(COMMENT_EVENT_ID_MAP_KEY));
        return comment;
    }

    @Override
    public void remove(Map<String, String> documentId) throws Exception {
        commentsReference = db.collection(FirestoreConstants.EVENTS_COLLECTION)
            .document(documentId.get(COMMENT_EVENT_ID_MAP_KEY))
            .collection(FirestoreConstants.COMMENTS_COLLECTION);
        commentsReference.document(documentId.get(COMMENT_ID_MAP_KEY)).delete();
    }
}
