package com.diegodiome.justmeet_backend.config;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.annotation.PostConstruct;

import com.google.auth.oauth2.GoogleCredentials;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableConfigurationProperties
@ConfigurationProperties(prefix = "firebase")
public class FirebaseConfig {

    @PostConstruct
    public void init() {

        try {
            FirebaseApp.getInstance();
        } catch (IllegalStateException e) {
            try {
                FileInputStream inputStream = new FileInputStream(
                        "justmeet-3fd33-firebase-adminsdk-y0dnq-43425c64fd.json");

                try {
                    FirebaseOptions options = new FirebaseOptions.Builder()
                            .setCredentials(GoogleCredentials.fromStream(inputStream)).build();

                    FirebaseApp.initializeApp(options);
                } catch (IOException ioE) {
                    ioE.printStackTrace();
                }
            } catch (NullPointerException nullE) {
                nullE.printStackTrace();
            } catch (FileNotFoundException ex) {
                ex.printStackTrace();
            }
        }

    }
}