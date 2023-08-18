package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.DicValue;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.DicValueService;
import com.happyballoon.crm.settings.service.UserService;
import com.happyballoon.crm.workbench.domain.Activity;
import com.happyballoon.crm.workbench.domain.Clue;
import com.happyballoon.crm.workbench.domain.ClueActivityRelation;
import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.service.ActivityService;
import com.happyballoon.crm.workbench.service.ClueActivityRelationService;
import com.happyballoon.crm.workbench.service.ClueRemarkService;
import com.happyballoon.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

    @Autowired
    private UserService userService;
    @Autowired
    private ClueService clueService;
    @Autowired
    private ClueRemarkService clueRemarkService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        //调用service层方法，查询所有的用户
        List<User> userList = userService.queryAllUsers();
        //存入request域
        request.setAttribute("userList",userList);
        //请求转发跳转页面
        return "workbench/clue/index";
    }

    @RequestMapping("/saveCreateClue.do")
    public @ResponseBody Object saveCreateClue(Clue clue, HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //二次封装
        clue.setCreateTime(DateUtil.formateDateTime(new Date()));
        clue.setCreateBy(currentUser.getId());
        clue.setId(UUIDUtil.getUUID());
        //调用service层,保存创建的线索
        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueService.saveCreateClue(clue);
            if (ret > 0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试....");
        }
        return returnObject;

    }

    @RequestMapping("/queryClueByConditionForPage.do")
    public @ResponseBody Object queryClueByConditionForPage(String fullname,String company,String phone,String owner,
                                                            String mphone,String source,String state,
                                                            int pageNo,int pageSize){
        //封装参数
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("fullname",fullname);
        map.put("owner",owner);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mphone",mphone);
        map.put("source",source);
        map.put("state",state);
        map.put("startIndex",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<Clue> clueList = clueService.queryClueByConditionForPage(map);
        int totalRows = clueService.queryClueCountByConditionForPage(map);

        HashMap<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("clueList",clueList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    @RequestMapping("/detailClue.do")
    public String detailClue(String id,HttpServletRequest request){
        //调用service层方法，查询数据
        Clue clue = clueService.queryClueForDetailById(id);
        List<ClueRemark> clueRemarkList = clueRemarkService.queryClueRemarkForDetailByClueId(id);
        List<Activity> activityList = activityService.queryActivityForDetailByClueId(id);
        //存入request域中
        request.setAttribute("clue",clue);
        request.setAttribute("clueRemarkList",clueRemarkList);
        request.setAttribute("activityList",activityList);
        //请求转发跳转页面
        return "workbench/clue/detail";
    }

    @RequestMapping("/queryActivityForDetailByNameAndClueId.do")
    public @ResponseBody Object queryActivityForDetailByNameAndClueId(String clueId,String activityName){
        //封装参数
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueId",clueId);
        map.put("activityName",activityName);
        //调用service层，查询关联的市场活动
        List<Activity> activityList = activityService.queryActivityForDetailByNameAndClueId(map);
        //返回对象
        return activityList;
    }

    @RequestMapping("/saveCreateClueActivityRelation.do")
    public @ResponseBody Object saveCreateClueActivityRelation(String[] activityId,String clueId){
        //封装参数
        List<ClueActivityRelation> relations = new ArrayList<ClueActivityRelation>();
        ClueActivityRelation relation = null;
        for (String aid:activityId){
            relation = new ClueActivityRelation();
            relation.setClueId(clueId);
            relation.setId(UUIDUtil.getUUID());
            relation.setActivityId(aid);
            relations.add(relation);
        }

        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service层,批量保存线索和市场活动的关联关系
            int ret = clueActivityRelationService.saveCreateClueActivityRelationByList(relations);
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

    @RequestMapping("/deleteClueActivityRelation.do")
    public @ResponseBody Object deleteClueActivityRelation(ClueActivityRelation relation){
        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service层，删除市场活动和线索的关联关系
            int ret = clueActivityRelationService.deleteClueActivityRelationByClueIdActivityId(relation);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试....");
        }
        return returnObject;
    }

    @RequestMapping("/editClueBefore.do")
    public @ResponseBody Object editClueBefore(String id){
        Clue clue = clueService.queryClueForEditById(id);
        return clue;
    }

    @RequestMapping("/updateClue.do")
    public @ResponseBody Object updateClue(Clue clue,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        clue.setEditTime(DateUtil.formateDateTime(new Date()));
        clue.setEditBy(currentUser.getId());

        ReturnObject returnObject = new ReturnObject();
        try{
            int ret = clueService.saveEditedClue(clue);
            if (ret>0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙,请稍后重试....");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙,请稍后重试....");
        }
        return returnObject;

    }

    @RequestMapping("/toConvertPage.do")
    public String toConvertPage(String id,HttpServletRequest request){
        Clue clue = clueService.queryClueForDetailById(id);
        request.setAttribute("clue",clue);
        return "workbench/clue/convert";
    }

    @RequestMapping("/queryActivityForConvert.do")
    public @ResponseBody Object queryActivityForConvert(String activityName,String clueId){
        //封装参数
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("activityName",activityName);
        map.put("clueId",clueId);
        //调用service层，查询市场活动
        List<Activity> activityList = activityService.queryActivityForConvertByNameAndClueId(map);
        return activityList;
    }

    @RequestMapping("/saveConvertClue.do")
    public @ResponseBody Object saveConvertClue(String clueId,String money,String name,
                                            String expectedDate,String stage,String acyivityId,
                                            String isCreateTransaction,HttpSession session){
        //封装参数
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("clueId",clueId);
        map.put("money",money);
        map.put("name",name);
        map.put("expectedDate",expectedDate);
        map.put("stage",stage);
        map.put("acyivityId",acyivityId);
        map.put("isCreateTransaction",isCreateTransaction);
        map.put(Constants.SESSION_USER,session.getAttribute(Constants.SESSION_USER));

        ReturnObject returnObject = new ReturnObject();
        try{
            //调用service层，保存转换信息
            clueService.saveConvertClue(map);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }

        return returnObject;
    }

    @RequestMapping("/deleteClue.do")
    public @ResponseBody Object deleteClue(String[] id){

        ReturnObject returnObject = new ReturnObject();
        try{
           clueService.deleteClueByIds(id);
           returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙，请稍后重试...");
        }

        return returnObject;
    }

}
