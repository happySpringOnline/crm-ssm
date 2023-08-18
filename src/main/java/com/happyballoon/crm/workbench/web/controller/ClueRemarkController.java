package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.service.ClueRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/clue")
public class ClueRemarkController {

    @Autowired
    private ClueRemarkService clueRemarkService;

    @RequestMapping("/saveClueRemark.do")
    public @ResponseBody Object saveClueRemark(ClueRemark remark, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.formateDateTime(new Date()));
        remark.setCreateBy(currentUser.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);
        //调用service层，保存备注信息
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueRemarkService.saveClueRemark(remark);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试..");
            }
        }catch (Exception e){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试..");
        }
        return returnObject;
    }

    @RequestMapping("/updateClueRemark.do")
    public @ResponseBody Object updateClueRemark(ClueRemark remark, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditBy(currentUser.getId());
        remark.setEditTime(DateUtil.formateDateTime(new Date()));
        //调用service层，保存修改后的备注
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueRemarkService.saveEditClueRemark(remark);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试..");
            }
        }catch (Exception e){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试..");
        }
        return returnObject;

    }

    @RequestMapping("/deleteClueRemark.do")
    public @ResponseBody Object deleteClueRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueRemarkService.deleteClueRemarkById(id);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试..");
            }
        }catch (Exception e){
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试..");
        }
        return returnObject;
    }
}
