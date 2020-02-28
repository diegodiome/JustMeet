package com.diegodiome.justmeet_backend.service;

import java.util.List;
import java.util.concurrent.ExecutionException;

public interface FirestoreService<T, E> {

    /**
     * create new Document
     * @param document
     */
    void create(T document) throws Exception;

    /**
     * Get document
     * @param documentId
     * @return 
     */
    T get(E documentId) throws Exception;

    /**
     * Get list of all documents
     * @return
     */
    List<T> getAll() throws InterruptedException, ExecutionException;

    /**
     * Update specif document
     * @param documentId
     */
    void update(T documentUpdated) throws Exception;

    /**
     * Remove a document
     * @param documentId
     */
    void remove(E documentId) throws Exception;
}