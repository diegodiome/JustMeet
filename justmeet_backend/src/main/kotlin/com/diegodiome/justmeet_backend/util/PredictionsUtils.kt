package com.diegodiome.justmeet_backend.util

import com.diegodiome.justmeet_backend.model.AutoCompleteItemMatchDetail

class PredictionsUtils {

    companion object {
        val instance = SecurityUtils()
    }

    fun getStringMatchDetail(text1: String, text2: String) : AutoCompleteItemMatchDetail {
        val count = text1.count {
            text2.contains(it)
        }
        return AutoCompleteItemMatchDetail(
                offset = 0,
                length = count
        )
    }
}