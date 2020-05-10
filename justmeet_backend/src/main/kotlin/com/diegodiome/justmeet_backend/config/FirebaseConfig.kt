package com.diegodiome.justmeet_backend.config

import com.google.auth.oauth2.GoogleCredentials
import com.google.firebase.FirebaseApp
import com.google.firebase.FirebaseOptions
import org.slf4j.LoggerFactory
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.context.annotation.Configuration
import org.springframework.core.io.ClassPathResource
import java.io.IOException
import javax.annotation.PostConstruct

@Configuration
@EnableConfigurationProperties
class FirebaseConfig {

    private var firebaseConfigLogger = LoggerFactory.getLogger(FirebaseConfig::class.java)

    @PostConstruct
    fun init() {
        try {
            val options = FirebaseOptions
                    .builder()
                    .setCredentials(GoogleCredentials
                            .fromStream(ClassPathResource("serviceAccount.json").inputStream))
                    .build()
            FirebaseApp.initializeApp(options)
            firebaseConfigLogger.info("Firebase initialized")
        } catch (ex: IOException) {
            firebaseConfigLogger.warn("Firebase initialization failed : ", ex)
        }
    }
}