package com.diegodiome.justmeet_backend.model

import com.diegodiome.justmeet_backend.model.enums.REPORTING_TYPE
import java.util.*

open class Reporting(
        val reportingId: String? = UUID.randomUUID().toString(),
        val reportingCreator: String,
        val reportingType: REPORTING_TYPE
) {
    constructor() : this( UUID.randomUUID().toString(),"", REPORTING_TYPE.Spam)
}