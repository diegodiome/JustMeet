package com.diegodiome.justmeet_backend

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.scheduling.annotation.EnableScheduling

@SpringBootApplication
@EnableScheduling
class JustMeetApplication

fun main(args: Array<String>) {
	runApplication<JustMeetApplication>(*args)
}
