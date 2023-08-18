package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.UserService;
import com.happyballoon.crm.workbench.domain.*;
import com.happyballoon.crm.workbench.service.ContactsService;
import com.happyballoon.crm.workbench.service.CustomerRemarkService;
import com.happyballoon.crm.workbench.service.CustomerService;
import com.happyballoon.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpRequest;
import org.springframework.stereotype.Controller;
import org.springframework.web.HttpRequestHandler;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequestMapping("/workbench/customer")
@Controller
public class CustomerController {

    @Autowired
    private UserService userService;
    @Autowired
    private CustomerService customerService;
    @Autowired
    private TranService tranService;
    @Autowired
    private ContactsService contactsService;
    @Autowired
    private CustomerRemarkService customerRemarkService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //存入request域
        request.setAttribute("userList",userList);
        return "workbench/customer/index";
    }

    @RequestMapping("/queryCustomerByConditionForPage.do")
    public @ResponseBody Object queryCustomerByConditionForPage(String name,String owner,String phone,String website,
                                                                int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("startIndex",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service层，查询客户
        List<Customer> customerList = customerService.queryCustomerByConditionForPage(map);
        int totalRows = customerService.queryTotalCountByConditionForPage(map);

        Map<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("customerList",customerList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    @RequestMapping("/saveCreateCustomer.do")
    public @ResponseBody Object saveCreateCustomer(Customer customer,HttpSession session){
        User currntUser = (User) session.getAttribute(Constants.SESSION_USER);
        customer.setId(UUIDUtil.getUUID());
        customer.setCreateBy(currntUser.getId());
        customer.setCreateTime(DateUtil.formateDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerService.saveCreateCustomer(customer);
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

    @RequestMapping("/editCustomerBefore.do")
    public @ResponseBody Object editCustomerBefore(String id){
        Customer customer = customerService.queryCustomerForEditById(id);
        return customer;
    }

    @RequestMapping("/updateCustomer.do")
    public @ResponseBody Object updateCustomer(Customer customer,HttpSession session){
        User currntUser = (User) session.getAttribute(Constants.SESSION_USER);
        customer.setEditBy(currntUser.getId());
        customer.setEditTime(DateUtil.formateDateTime(new Date()));

        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = customerService.saveEditCustomer(customer);
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

    @RequestMapping("/toDetailPage.do")
    public String toDetailPage(String id,HttpServletRequest request){
        List<User> userList = userService.queryAllUsers();
        Customer customer = customerService.queryCustomerForDetailById(id);
        List<CustomerRemark> customerRemarkList = customerService.queryCustomerRemarkListByCid(id);
        List<Tran> tranList = tranService.queryTranListByCustomerId(id);
        List<Contacts> contactsList = contactsService.queryContactsListByCustomerId(id);

        request.setAttribute("customer",customer);
        request.setAttribute("customerRemarkList",customerRemarkList);
        request.setAttribute("tranList",tranList);
        request.setAttribute("contactsList",contactsList);
        request.setAttribute("userList",userList);

        return "workbench/customer/detail";
    }

    @RequestMapping("/deleteCustomerByIds.do")
    public @ResponseBody Object deleteCustomerByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        try{
            customerService.deleteCustomerByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试...");
        }
        return returnObject;
    }

    @RequestMapping("/saveCustomerRemark.do")
    public @ResponseBody Object saveCustomerRemark(CustomerRemark remark, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setId(UUIDUtil.getUUID());
        remark.setCreateTime(DateUtil.formateDateTime(new Date()));
        remark.setCreateBy(currentUser.getId());
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_NO_EDITED);
        //调用service层，保存备注信息
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = customerRemarkService.saveCustomerRemark(remark);
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

    @RequestMapping("/updateCustomerRemark.do")
    public @ResponseBody Object updateCustomerRemark(CustomerRemark remark, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        remark.setEditFlag(Constants.REMARK_EDIT_FLAG_YES_EDITED);
        remark.setEditBy(currentUser.getId());
        remark.setEditTime(DateUtil.formateDateTime(new Date()));
        //调用service层，保存修改后的备注
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = customerRemarkService.saveEditCustomerRemark(remark);
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

    @RequestMapping("/deleteCustomerRemark.do")
    public @ResponseBody Object deleteCustomerRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = customerRemarkService.deleteCustomerRemarkById(id);
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
