package com.diegodiome.justmeet_backend.controller;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    @RequestMapping(value = "/")
    public String homePage() {
        return "index.html";
    }
    
}