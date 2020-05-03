package com.diegodiome.justmeet_backend.util

import com.diegodiome.justmeet_backend.model.AutoCompleteItemMatchDetail

class PredictionsUtils {

    companion object {
        val instance = SecurityUtils()
    }

    fun getStringMatchDetail(text1: String, text2: String) : AutoCompleteItemMatchDetail {
        var count: Int = 0
        if(text2.contains(text1, ignoreCase = true)) {
            count = text1.length
        }
        return AutoCompleteItemMatchDetail(
                offset = 0,
                length = count
        )
    }
}