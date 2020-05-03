package com.diegodiome.justmeet_backend.model

enum class AutoCompleteItemType {Event, User}

data class AutoCompleteItems(
        val predictions: List<AutoCompleteItem>
)

data class AutoCompleteItem(
        val id: String,
        val text: String,
        val detail: AutoCompleteItemMatchDetail,
        val type: AutoCompleteItemType
)

data class AutoCompleteItemMatchDetail (
    val offset: Int,
    val length: Int
)