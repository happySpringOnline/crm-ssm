package com.happyballoon.crm.settings.web.controller;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.DicType;
import com.happyballoon.crm.settings.domain.DicValue;
import com.happyballoon.crm.settings.service.DicTypeService;
import com.happyballoon.crm.settings.service.DicValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/settings/dictionary")
public class DicController {

    @Autowired
    private DicTypeService dicTypeService;
    @Autowired
    private DicValueService dicValueService;

    @RequestMapping("/index.do")
    public String index(){
        return "settings/dictionary/index";
    }

    @RequestMapping("/type/index.do")
    public String dicTypeIndex(HttpServletRequest request){
        //调用service层，查询所有的dicType
        List<DicType> dicTypeList = dicTypeService.queryAllDicType();
        //存到request域里
        request.setAttribute("dicTypeList",dicTypeList);
        //请求转发跳转页面
        return "settings/dictionary/type/index";
    }

    @RequestMapping("/type/toSaveDicTypePage.do")
    public String toSaveDicTypePage(){
        return "settings/dictionary/type/save";
    }

    @RequestMapping("/type/saveCreateDicType.do")
    public @ResponseBody Object saveCreateDicType(DicType dicType){
        //调用service层，保存数据字典类型
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = dicTypeService.saveCreateDicType(dicType);
            if (ret > 0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试...");
        }
        return returnObject;

    }

    @RequestMapping("/type/toEditDicTypePage.do")
    public String toEditDicTypePage(String code,HttpServletRequest request){
        //调用service层，查询该code对应的数据字典类型对象，返回dictype
        DicType dicType = dicTypeService.queryDicTypeByCode(code);
        //存储到request域中
        request.setAttribute("dicType",dicType);
        //请求转发跳转页面
        return "settings/dictionary/type/edit";
    }

    @RequestMapping("/type/updateDicTypeByCode.do")
    public @ResponseBody Object updateDicTypeByCode(DicType dicType){
        //调用service层，根据code更新数据字典的记录
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = dicTypeService.updateDicTypeByCode(dicType);
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

    @RequestMapping("/type/deleteDicTypeByBatch.do")
    public @ResponseBody Object deleteDicTypeByBatch(String[] code){
        //调用service层，根据code删除数据字典的记录
        ReturnObject returnObject = new ReturnObject();
        try {
            int count1 = dicValueService.queryDelCountByTypeCodes(code);
            int count2 = dicValueService.deleteDicValueByTypeCodes(code);
            if (count1==count2){
                int ret = dicTypeService.deleteDicTypeByBatch(code);
                if (ret>0){
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                    returnObject.setRetData(ret);
                }else {
                    returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                    returnObject.setMessage("系统忙，请稍后重试...");
                }
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

    @RequestMapping("/value/index.do")
    public String dicValueIndex(HttpServletRequest request){
        //调用service层，查询所有的字典值，返回DicValueList
        List<DicValue> dicValueList = dicValueService.queryAllDicValue();
        //把dicValueList存入request域中
        request.setAttribute("dicValueList",dicValueList);
        //请求转发跳转页面
        return "settings/dictionary/value/index";
    }

    @RequestMapping("/value/queryDicValueByConditionForPage.do")
    public @ResponseBody Object queryDicValueByConditionForPage(int pageNo,int pageSize){
        Map<String,Object> map = new HashMap<String,Object>();

        map.put("startIndex",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<DicValue> dicValueList = dicValueService.queryDicValueByConditionForPage(map);
        int totalRows = dicValueService.queryTotalDicValueCount();

        HashMap<String, Object> returnMap = new HashMap<String, Object>();
        returnMap.put("dicValueList",dicValueList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    @RequestMapping("/value/toSaveDicValuePage.do")
    public String toSaveDicValuePage(HttpServletRequest request){
        //调用service层，查询所有的dicType
        List<DicType> dicTypeList = dicTypeService.queryAllDicType();
        //存到request域里
        request.setAttribute("dicTypeList",dicTypeList);
        //请求跳转页面
        return "settings/dictionary/value/save";
    }

    @RequestMapping("/value/saveDicValue.do")
    public @ResponseBody Object saveDicValue(DicValue dicValue){
        //二次封装
        dicValue.setId(UUIDUtil.getUUID());
        //调用service层，保存字典值
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = dicValueService.saveDicValue(dicValue);
            if (ret > 0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统忙,请稍后重试...");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统忙,请稍后重试...");
        }
        return returnObject;
    }
}
