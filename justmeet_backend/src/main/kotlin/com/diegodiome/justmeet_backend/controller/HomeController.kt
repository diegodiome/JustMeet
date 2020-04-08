package com.diegodiome.justmeet_backend.controller

import com.diegodiome.justmeet_backend.config.constants.ApiConstants.HOMEPAGE_URL
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping

@Controller
class HomeController {

    @RequestMapping(value = [HOMEPAGE_URL])
    fun homepageRequest() : String {
        return "index.html"
    }
}