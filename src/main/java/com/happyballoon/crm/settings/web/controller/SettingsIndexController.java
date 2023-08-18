package com.happyballoon.crm.settings.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@RequestMapping("/settings")
@Controller
public class SettingsIndexController {

    @RequestMapping("/index.do")
    public String toIndex(){
        return "settings/index";
    }
}
