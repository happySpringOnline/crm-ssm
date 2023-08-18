package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.UserService;
import com.happyballoon.crm.workbench.domain.*;
import com.happyballoon.crm.workbench.mapper.CustomerMapper;
import com.happyballoon.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/tran")
public class TranController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private TranService tranService;
    @Autowired
    private TranRemarkService tranRemarkService;
    @Autowired
    private TranHistoryService tranHistoryService;

    @RequestMapping("/index.do")
    public String index(){
        return "workbench/transaction/index";
    }

    @RequestMapping("/toCreateTranPage.do")
    public String toCreateTranPage(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        return "workbench/transaction/save";
    }

    @RequestMapping("/queryAllCustomerName.do")
    public @ResponseBody Object queryAllCustomerName(String customerName){
        List<String> customerNames = customerService.queryAllCustomerNameByName(customerName);
        return customerNames;
    }

    @RequestMapping("/queryActivityListByAName.do")
    public @ResponseBody Object queryActivityListByAName(String activityName){
        List<Activity> activityList = activityService.queryActivityListAllByAName(activityName);
        return activityList;
    }

    @RequestMapping("/queryContactsListByCName.do")
    public @ResponseBody Object queryContactsListByCName(String contactsName){
        List<Contacts> contactsList = contactsService.queryContactsListByCName(contactsName);
        return contactsList;
    }

    @RequestMapping("/saveCreateTran.do")
    public @ResponseBody Object saveCreateTran(@RequestParam Map<String,Object> map, HttpSession session){
        //二次封装
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service方法，保存创建的交易
            tranService.saveCreateTran(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/queryTranListForPageByCondition.do")
    public @ResponseBody Object queryTranListForPageByCondition(@RequestParam Map<String,Object> map){

        int pageNo = Integer.parseInt((String) map.get("pageNo")) ;
        int pageSize = Integer.parseInt((String) map.get("pageSize"));
        int startIndex = (pageNo-1)*pageSize;

        map.put("startIndex",startIndex);
        map.put("pageSize",pageSize);

        List<Tran> tranList = tranService.queryTranListForPageByCondition(map);
        int totalRows = tranService.queryTotalCountForPageByCondition(map);

        Map<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("tranList",tranList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    @RequestMapping("/toEditPage.do")
    public String toEditPage(String id,HttpServletRequest request){
        Tran tran = tranService.queryTranEditForEditById(id);
        List<User> userList = userService.queryAllUsers();

        request.setAttribute("userList",userList);
        request.setAttribute("tran",tran);
        return "workbench/transaction/edit";
    }

    @RequestMapping("/saveEditedTran.do")
    public @ResponseBody Object saveEditedTran(@RequestParam Map<String,Object> map,HttpSession session){
        //二次封装
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try {
            //调用service方法，保存修改后的交易
            tranService.saveEditedTran(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/toDetailPage.do")
    public String toDetailPage(String tranId,HttpServletRequest request){

        ServletContext application = request.getServletContext();
        Map<String,Object> pMap = (Map<String, Object>) application.getAttribute("pMap");


        Tran tran = tranService.queryTranForDetailById(tranId);
        String possibility = (String) pMap.get(tran.getStage());
        tran.setPossibility(possibility);

        List<TranRemark> tranRemarks = tranRemarkService.queryTranRemarkForDetailByTranId(tranId);
        List<TranHistory> tranHistories = tranHistoryService.queryTranHistoryForDetailByTranId(tranId);

        List<String> stageList = (List<String>) application.getAttribute("stage");

        request.setAttribute("tran",tran);
        request.setAttribute("tranRemarks",tranRemarks);
        request.setAttribute("tranHistories",tranHistories);
        request.setAttribute("stageList",stageList);

        return "workbench/transaction/detail";
    }

    @RequestMapping("/deleteTranByIds.do")
    public @ResponseBody Object deleteContactsByIds(String[] id){

        ReturnObject returnObject = new ReturnObject();
        try {
            tranService.deleteContactsByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/saveTranRemark.do")
    public @ResponseBody Object saveTranRemark(TranRemark remark,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.formateDateTime(new Date()));
        remark.setCreateBy(currentUser.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);
        //调用service层，保存备注信息
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = tranRemarkService.saveTranRemark(remark);
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

    @RequestMapping("/updateTranRemark.do")
    public @ResponseBody Object updateTranRemark(TranRemark remark,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditBy(currentUser.getId());
        remark.setEditTime(DateUtil.formateDateTime(new Date()));
        //调用service层，保存修改后的备注
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = tranRemarkService.saveEditTranRemark(remark);
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

    @RequestMapping("/deleteTranRemark.do")
    public @ResponseBody Object deleteTranRemark(String id,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = tranRemarkService.deleteTranRemarkById(id);
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
