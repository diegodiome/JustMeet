package com.diegodiome.justmeet_backend.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.concurrent.ExecutionException;

import com.diegodiome.justmeet_backend.model.UserReporting;
import com.diegodiome.justmeet_backend.util.FirestoreConstants;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.firebase.cloud.FirestoreClient;

import org.springframework.stereotype.Service;

@Service
public class FirestoreUserReportingService implements FirestoreService<UserReporting, String> {

    private Firestore db;
    private CollectionReference reportsReference;

    //private static final Logger LOGGER = Logger.getLogger(FirestoreEventService.class.getName());

    public FirestoreUserReportingService() {
        this.db = FirestoreClient.getFirestore();
    }

    @Override
    public void create(UserReporting document) throws Exception {
        reportsReference = db.collection(FirestoreConstants.USERS_COLLECTION)
            .document(document.getUserId()).collection(FirestoreConstants.USER_REPORTS_COLLECTION);
        reportsReference.document().set(
            new HashMap<String, Object>() { 
                private static final long serialVersionUID = 1L;
                {
                    put(FirestoreConstants.REPORTING_CREATOR_FIELD, document.getReportingCreator());
                    put(FirestoreConstants.REPORTING_CONTENT_FIELD, document.getReportingBody());    
                }
            }    
        );
    }

    @Override
    public UserReporting get(String documentId) throws Exception {
        return null;
    }

    @Override
    public List<UserReporting> getAll() throws InterruptedException, ExecutionException {
        return null;
    }

    @Override
    public void update(UserReporting documentUpdated) throws Exception {
        return;
    }

    @Override
    public void remove(String documentId) throws Exception {
        return;
    }

    public List<UserReporting> getAllByUser(String userId) throws InterruptedException, ExecutionException {
        reportsReference = db.collection(FirestoreConstants.USERS_COLLECTION)
            .document(userId).collection(FirestoreConstants.USER_REPORTS_COLLECTION);
        List<QueryDocumentSnapshot> documents = reportsReference.get().get().getDocuments();
        List<UserReporting> reports = new ArrayList<>();
        for (QueryDocumentSnapshot document : documents) {
            UserReporting reporting = document.toObject(UserReporting.class);
            reporting.setReportingId(document.getId());
            reporting.setUserId(userId);
            reports.add(reporting);
        }
        return reports;
    }
}