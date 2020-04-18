package com.diegodiome.justmeet_backend.model

data class AutoCompleteItems(
        val predictions: List<AutoCompleteItem>
)

data class AutoCompleteItem(
        val text: String,
        val detail: AutoCompleteItemMatchDetail
)

data class AutoCompleteItemMatchDetail (
    val offset: Int,
    val lenght: Int
)