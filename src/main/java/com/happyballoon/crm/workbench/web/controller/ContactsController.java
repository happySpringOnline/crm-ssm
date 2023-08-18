package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.UserService;
import com.happyballoon.crm.workbench.domain.*;
import com.happyballoon.crm.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/contacts")
public class ContactsController {

    @Autowired
    private UserService userService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private ContactsRemarkService contactsRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private TranService tranService;


    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        request.setAttribute("userList",userList);
        return "workbench/contacts/index";
    }

    @RequestMapping("/queryContactsForPageByCondition.do")
    public @ResponseBody Object queryContactsForPageByCondition(@RequestParam Map<String,Object> map){
        int pageNo = Integer.parseInt((String) map.get("pageNo"));
        int pageSize = Integer.parseInt((String) map.get("pageSize"));
        int startIndex = (pageNo-1)*pageSize;

        map.put("startIndex",startIndex);
        map.put("pageSize",pageSize);

        List<Contacts> contactsList = contactsService.queryContactsForPageByCondition(map);
        int totalRows = contactsService.queryCountForPageByCondition(map);

        Map<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("contactsList",contactsList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    @RequestMapping("/saveContacts.do")
    public @ResponseBody Object saveContacts(@RequestParam Map<String,Object> map, HttpSession session) {
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        map.put(Constants.SESSION_USER,currentUser);

        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.saveContacts(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/showContactsRemarkList.do")
    public @ResponseBody Object showContactsRemarkList(String contactsId){
        List<ContactsRemark> contactsRemarkList = contactsRemarkService.queryContactsByContactsId(contactsId);
        return contactsRemarkList;
    }

    @RequestMapping("/toDetailPage.do")
    public String toDetailPage(String id,HttpServletRequest request){
        //联系人
        Contacts contacts = contactsService.queryContactsForDetailById(id);
        //联系人关联的市场活动
        List<Activity> activityList = activityService.queryActivityListByContactsId(id);
        //联系人关联的交易
        List<Tran> tranList = tranService.queryTranListByContactsId(id);
        request.setAttribute("contact",contacts);
        request.setAttribute("activityList",activityList);
        request.setAttribute("tranList",tranList);
        return "workbench/contacts/detail";
    }

    @RequestMapping("/queryContactsForEdit.do")
    public @ResponseBody Object queryContactsForEdit(String id){
        Contacts contacts = contactsService.queryContactsForEditById(id);
        return contacts;
    }

    @RequestMapping("/saveEditedContacts.do")
    public @ResponseBody Object saveEditedContacts(@RequestParam Map<String,Object> map,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        map.put(Constants.SESSION_USER,currentUser);
        ReturnObject returnObject = new ReturnObject();
        try {
            contactsService.saveEditedContacts(map);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/saveContactsRemark.do")
    public @ResponseBody Object saveContactsRemark(ContactsRemark remark,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.formateDateTime(new Date()));
        remark.setCreateBy(currentUser.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);
        //调用service层，保存备注信息
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = contactsRemarkService.saveContactsRemark(remark);
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

    @RequestMapping("/deleteContactsRemarkById.do")
    public @ResponseBody Object deleteContactsRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = contactsRemarkService.deleteContactsRemarkById(id);
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

    @RequestMapping("/updateContactsRemark.do")
    public @ResponseBody Object updateContactsRemark(ContactsRemark remark,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditBy(currentUser.getId());
        remark.setEditTime(DateUtil.formateDateTime(new Date()));
        //调用service层，保存修改后的备注
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = contactsRemarkService.updateContactsRemark(remark);
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

    @RequestMapping("/unbundRelation.do")
    public @ResponseBody Object unbundRelation(@RequestParam Map<String,Object> map){

        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = contactsService.deleteRelationByAidAndCid(map);
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

    @RequestMapping("/queryActivityForDetailByNameAndContactsId.do")
    public @ResponseBody Object queryActivityForDetailByNameAndContactsId(String contactsId,String activityName){
        //封装参数
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("contactsId",contactsId);
        map.put("activityName",activityName);
        //调用service层，查询关联的市场活动
        List<Activity> activityList = activityService.queryActivityListForBundRelationByAnameAndCid(map);
        //返回对象
        return activityList;
    }

    @RequestMapping("/saveContactsActivityRelation.do")
    public @ResponseBody Object saveContactsActivityRelation(String[] activityId,String contactsId){
        List<ContactsActivityRelation> relations = new ArrayList<ContactsActivityRelation>();
        ContactsActivityRelation relation = null;
        for (String aid:activityId){
            relation = new ContactsActivityRelation();
            relation.setId(UUIDUtil.getUUID());
            relation.setActivityId(aid);
            relation.setContactsId(contactsId);
            relations.add(relation);
        }

        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service层,批量保存线索和市场活动的关联关系
            int ret = contactsService.saveRelationsByList(relations);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                List<Activity> activityList = activityService.queryActivityForDetailByIds(activityId);
                returnObject.setRetData(activityList);
            }else{
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/deleteContactsByIds.do")
    public @ResponseBody Object deleteContactsByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            contactsService.deleteContactsByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }
        return returnObject;

    }
}
