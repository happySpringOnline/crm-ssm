package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.workbench.domain.ActivityRemark;
import com.happyballoon.crm.workbench.service.ActivityRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.Date;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityRemarkController {
    @Autowired
    private ActivityRemarkService activityRemarkService;

    @RequestMapping("/saveActivityRemark.do")
    public @ResponseBody Object saveActivityRemark(ActivityRemark remark, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装参数
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.formateDateTime(new Date()));
        remark.setCreateBy(currentUser.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);

        ReturnObject returnObject = new ReturnObject();
        //调用service层，添加市场活动备注
        try{
            int ret = activityRemarkService.saveCreateActivityRemark(remark);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍候重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍候重试...");
        }
        return returnObject;

    }

    @RequestMapping("/deleteActivityRemarkById.do")
    public @ResponseBody Object deleteActivityRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service层方法，删除备注
            int ret = activityRemarkService.deleteActivityRemarkById(id);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/editActivityRemark.do")
    public @ResponseBody Object editActivityRemarkBy(ActivityRemark remark,HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装参数
        remark.setEditBy(user.getId());
        remark.setEditTime(DateUtil.formateDateTime(new Date()));
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);

        ReturnObject returnObject = new ReturnObject();
        //调用service层，修改更新市场活动备注信息
        try{
            int ret = activityRemarkService.editActivityRemark(remark);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                returnObject.setRetData(remark);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }
}
