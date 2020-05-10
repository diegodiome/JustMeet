package com.diegodiome.justmeet_backend.service

import com.diegodiome.justmeet_backend.model.NotificationRequest
import com.google.firebase.messaging.*
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class FirebaseCloudMessagingService {

    private val notificationServiceLogger = LoggerFactory.getLogger(FirebaseCloudMessagingService::class.java)

    fun sendMessage(data: Map<String, String>, request: NotificationRequest) {
        val message = getPreconfiguredMessage(data, request)
        val response = sendAndGetResponse(getPreconfiguredMessage(data, request))
        notificationServiceLogger.info("Sent message to token. Device token: " + request.token + ", " + response)
    }

    private fun sendAndGetResponse(message: Message) : String{
        return FirebaseMessaging.getInstance().sendAsync(message).get()
    }

    private fun getApnsConfig(topic: String) : ApnsConfig {
        return ApnsConfig.builder()
                .setAps(Aps.builder().setCategory(topic).setThreadId(topic).build()).build()
    }

    private fun getPreconfiguredMessage(data: Map<String, String>, request: NotificationRequest) : Message{
        return Message.builder()
                .setApnsConfig(getApnsConfig(request.topic)).setToken(request.token)
                .setNotification(Notification(request.title, request.message)).build()
    }
}