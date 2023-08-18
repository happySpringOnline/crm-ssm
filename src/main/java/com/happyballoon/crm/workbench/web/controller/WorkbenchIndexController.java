package com.happyballoon.crm.workbench.web.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/workbench")
public class WorkbenchIndexController {

    /**
     * 这个是工作区主页面
     * @return
     */
    @RequestMapping("/toIndex.do")
    public String toIndex(){
        return "workbench/index";
    }

}
