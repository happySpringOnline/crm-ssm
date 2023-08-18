package com.happyballoon.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench/main")
public class MainController {

    /**
     * 进入工作区，默认打开的页面
     * @return
     */
    @RequestMapping("/index.do")
    public String index(){
        return "workbench/main/index";
    }
}
