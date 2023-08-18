package com.happyballoon.crm.workbench.web.controller;

import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.HSSFUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.UserService;
import com.happyballoon.crm.workbench.domain.Activity;
import com.happyballoon.crm.workbench.domain.ActivityRemark;
import com.happyballoon.crm.workbench.service.ActivityRemarkService;
import com.happyballoon.crm.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.*;
import java.util.*;

@Controller
@RequestMapping("/workbench/activity")
public class ActivityController {

    @Autowired
    private UserService userService;
    @Autowired
    private ActivityService activityService;
    @Autowired
    private ActivityRemarkService activityRemarkService;

    /**
     * 跳转市场活动首页
     * 下拉菜单所有者铺值后端
     * @param request
     * @return
     */
    @RequestMapping("/index.do")
    public String index(HttpServletRequest request){
        //调用service层查询所有用户
        List<User> userList = userService.queryAllUsers();
        //把数据保存到request中
        request.setAttribute("userList",userList);
        //请求转发跳转到市场活动index页面
        return "workbench/activity/index";
    }

    /**
     * 保存市场活动
     * @param activity
     * @param session
     * @return
     */
    //返回json的，返回类型设置为Object
    @RequestMapping("/saveCreateActivity.do")
    public @ResponseBody Object saveCreateActivity(Activity activity, HttpSession session){
        User user = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        activity.setId(UUIDUtil.getUUID());
        activity.setCreateTime(DateUtil.formateDateTime(new Date()));
        activity.setCreateBy(user.getId());

        ReturnObject returnObject = new ReturnObject();
        //调用service层方法，保存创建的市场活动
        try{
            int ret = activityService.saveCreateActivity(activity);

            if (ret > 0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            }else {
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("系统繁忙，请稍后..");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后..");
        }

        return returnObject;
    }

    /**
     * 展示市场活动列表
     * @param name
     * @param owner
     * @param startDate
     * @param endDate
     * @param pageNo
     * @param pageSize
     * @return
     */
    @RequestMapping("/queryActivityByConditionForPage.do")
    public @ResponseBody Object queryActivityByConditionForPage(String name,String owner,String startDate,
                                                                String endDate,int pageNo,int pageSize){
        System.out.println("展示市场活动列表页面");
        //封装参数
        Map<String,Object> map = new HashMap<String, Object>();
        map.put("name",name);
        map.put("owner",owner);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("startIndex",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        //调用service层方法，查询数据
        List<Activity> activityList = activityService.queryActivityByConditionForPage(map);
        int totalRows = activityService.queryCountOfActivityByCondition(map);
        //根据查询结果，生成响应信息
        Map<String,Object> returnMap = new HashMap<String,Object>();
        returnMap.put("activityList",activityList);
        returnMap.put("totalRows",totalRows);

        return returnMap;
    }

    /**
     * 删除市场活动
     * @param id
     * @return
     */
    @RequestMapping("/deleteActivityByIds.do")
    public @ResponseBody Object deleteActivityByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();
        //调用service层方法，删除市场活动
        try{
            activityService.deleteActivityByIds(id);
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);

        }catch (Exception e){
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍后重试...");
        }
        return returnObject;
    }

    /**
     * 通过id查询市场活动
     * @param id
     * @return
     */
    @RequestMapping("/queryActivityById.do")
    public @ResponseBody Object queryActivityById(String id){
        //调用service层，查询市场活动
        Activity activity = activityService.queryActivityById(id);
        //根据查询结果，返回响应信息
        return activity;
    }

    /**
     * 更新修改后的市场活动
     * @param activity
     * @param session
     * @return
     */
    @RequestMapping("/saveEditedActivity.do")
    public @ResponseBody Object saveEditedActivity(Activity activity,HttpSession session){
        User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
        //封装参数
        activity.setEditBy(currentUser.getId());
        activity.setEditTime(DateUtil.formateDateTime(new Date()));
        //调用service层，修改市场活动
        ReturnObject returnObject = new ReturnObject();
        try {
            int ret = activityService.saveEditedActivity(activity);
            if (ret > 0){
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
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

    @RequestMapping("/fileDownload.do")
    public void fileDownload(HttpServletResponse response) throws IOException {
        //1.设置响应类型---响应给浏览器的是输出流：application/octet-stream，网页：text/html
        response.setContentType("application/octet-stream;charset=UTF-8");
        //2.获取输出流
        //PrintWriter out = response.getWriter();//字符流
        OutputStream out = response.getOutputStream();//字节流

        //浏览器接收到响应信息之后，默认情况下，直接在显示窗口中打开响应信息：即使打不开，也会调用应用程序打开；只有实在打不开，才会激活文件下载目录。
        //可以设置响应头信息，使浏览器接收到响应信息，直接激活文件下载窗口，即使能打开也不打开
        response.addHeader("Content-Disposition","attachment;filename=mystudentList.xls");

        //读取excel文件(InputStream),把输出到浏览器(OutputStream)
        FileInputStream in = new FileInputStream("E:\\JavaProjects\\studentList.xls");
        byte[] buff = new byte[256];
        int len = 0;
        while ((len=in.read(buff))!=-1){
            out.write(buff,0,len);
        }

        //关闭资源
        in.close();
        out.flush();
    }

    /**
     * 全部导出
     * @param response
     * @throws Exception
     */
    @RequestMapping("/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws Exception{
        //调用service层方法，查询所有的市场活动
        List<Activity> activityList = activityService.queryAllActivities();
        //创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet("市场活动列表");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("id");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        //遍历activityList，创建HSSFRow对象，生成所有的数据行
        if (activityList != null && activityList.size()>0){
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);

                //每遍历出一个activity，生成一行
                row = sheet.createRow(i+1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        //根据workbook对象生成excel文件
        /*FileOutputStream out = new FileOutputStream("E:\\JavaProjects\\studentList.xls");
        hssfWorkbook.write(out);*/

        //关闭资源
        /*out.close();
        hssfWorkbook.close();*/

        //把生成的excel文件下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        OutputStream outputStream = response.getOutputStream();

        //设置响应头信息
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");

        /*FileInputStream in = new FileInputStream("E:\\JavaProjects\\studentList.xls");
        byte[] bytes = new byte[256];
        int len = 0;
        while ((len=in.read(bytes))!=-1){
            outputStream.write(bytes,0,len);
        }*/

        //直接从内存响应给浏览器
        hssfWorkbook.write(outputStream);

        //关闭资源
        //in.close();
        hssfWorkbook.close();
        outputStream.flush();
    }

    /**
     * 选择导出
     * @param id
     * @param response
     * @throws IOException
     */
    @RequestMapping("/exportSelectedActivities.do")
    public void exportSelectedActivities(String[] id,HttpServletResponse response) throws IOException {
        //调用service层，根据ids查询市场活动
        List<Activity> activityList = activityService.querySelectedActivities(id);
        //创建excel文件，并且把activityList写入到excel文件中
        HSSFWorkbook hssfWorkbook = new HSSFWorkbook();
        HSSFSheet sheet = hssfWorkbook.createSheet("市场活动信息列表(根据选择导出)");
        HSSFRow row = sheet.createRow(0);
        HSSFCell cell = row.createCell(0);
        cell.setCellValue("id");
        cell = row.createCell(1);
        cell.setCellValue("所有者");
        cell = row.createCell(2);
        cell.setCellValue("名称");
        cell = row.createCell(3);
        cell.setCellValue("开始日期");
        cell = row.createCell(4);
        cell.setCellValue("结束日期");
        cell = row.createCell(5);
        cell.setCellValue("成本");
        cell = row.createCell(6);
        cell.setCellValue("描述");
        cell = row.createCell(7);
        cell.setCellValue("创建时间");
        cell = row.createCell(8);
        cell.setCellValue("创建者");
        cell = row.createCell(9);
        cell.setCellValue("修改时间");
        cell = row.createCell(10);
        cell.setCellValue("修改者");

        if (activityList!=null && activityList.size()!=0){
            Activity activity = null;
            for (int i = 0; i < activityList.size(); i++) {
                activity = activityList.get(i);
                row = sheet.createRow(i + 1);
                cell = row.createCell(0);
                cell.setCellValue(activity.getId());
                cell = row.createCell(1);
                cell.setCellValue(activity.getOwner());
                cell = row.createCell(2);
                cell.setCellValue(activity.getName());
                cell = row.createCell(3);
                cell.setCellValue(activity.getStartDate());
                cell = row.createCell(4);
                cell.setCellValue(activity.getEndDate());
                cell = row.createCell(5);
                cell.setCellValue(activity.getCost());
                cell = row.createCell(6);
                cell.setCellValue(activity.getDescription());
                cell = row.createCell(7);
                cell.setCellValue(activity.getCreateTime());
                cell = row.createCell(8);
                cell.setCellValue(activity.getCreateBy());
                cell = row.createCell(9);
                cell.setCellValue(activity.getEditTime());
                cell = row.createCell(10);
                cell.setCellValue(activity.getEditBy());
            }
        }

        //把生成的excel的下载到客户端
        response.setContentType("application/octet-stream;charset=UTF-8");
        ServletOutputStream outputStream = response.getOutputStream();

        //设置响应头信息
        response.addHeader("Content-Disposition","attachment;filename=selectedActivityList.xls");

        //响应给客户端
        hssfWorkbook.write(outputStream);

        //关闭资源（自己new的流关闭）
        hssfWorkbook.close();
        outputStream.flush();

    }

    /**
     * 配置springmvc的文件上传解析器
     * @param userName
     * @param myFile
     * @return
     */
    @RequestMapping("/fileUpload.do")
    public @ResponseBody Object fileUpload(String userName, MultipartFile myFile) throws IOException {
        //把文本数据打印到控制台
        System.out.println("username="+userName);
        //把文件在服务器指定的目录中生成一个同样的文件
        String originalFilename = myFile.getOriginalFilename();
        //System.out.println(originalFilename);//crm搭建开发环境.txt
        File file = new File("E:\\JavaProjects\\08-crm_project\\",originalFilename);
        myFile.transferTo(file);

        //返回响应信息
        ReturnObject returnObject = new ReturnObject();
        returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
        returnObject.setMessage("上传成功");
        return returnObject;
    }

    /**
     * 导入市场活动
     * @return
     */
    @RequestMapping("/importActivity.do")
    public @ResponseBody Object importActivity(MultipartFile activityFile,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        try {
            //把excel文件写到磁盘目录中
            /*String originalFilename = activityFile.getOriginalFilename();
            File file = new File("E:\\JavaProjects\\08-crm_project\\serverDir", originalFilename);
            activityFile.transferTo(file);*/

            //解析excel文件，获取文件中的数据，并且封装成activityList
            //FileInputStream in = new FileInputStream("E:\\JavaProjects\\08-crm_project\\serverDir\\" + originalFilename);

            //直接从内存到内存，不经过磁盘
            InputStream in = activityFile.getInputStream();

            HSSFWorkbook hssfWorkbook = new HSSFWorkbook(in);
            HSSFSheet sheet = hssfWorkbook.getSheetAt(0);

            HSSFRow row = null;
            HSSFCell cell = null;

            User currentUser = (User) session.getAttribute(Constants.SESSION_USER);
            Activity activity = null;
            List<Activity> activityList = new ArrayList<Activity>();

            for (int i = 0; i <= sheet.getLastRowNum(); i++) {
                row = sheet.getRow(i);
                //每一行就是一个市场活动
                activity = new Activity();
                activity.setId(UUIDUtil.getUUID());
                activity.setOwner(currentUser.getId());
                activity.setCreateTime(DateUtil.formateDateTime(new Date()));
                activity.setCreateBy(currentUser.getId());

                for (int j = 0; j < row.getLastCellNum(); j++) {
                    //根据row获取HSSFCell对象，封装了一列的所有信息
                    cell = row.getCell(j);

                    String cellValue = HSSFUtil.getCellValueForStr(cell);

                    if (j==0){
                        activity.setName(cellValue);
                    }else if(j==1){
                        activity.setStartDate(cellValue);
                    }else if(j==2) {
                        activity.setEndDate(cellValue);
                    }else if(j==3) {
                        activity.setCost(cellValue);
                    }else if(j==4) {
                        activity.setDescription(cellValue);
                    }
                }
                //一行中所有列都封装完成之后，把activity保存到list中
                activityList.add(activity);
            }

            //所有行都遍历结束之后，保存市场活动
            //调用service层，保存市场活动
            int ret = activityService.saveCreateActivityByList(activityList);

            returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
            returnObject.setRetData(ret);
        } catch (IOException e) {
            e.printStackTrace();
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("系统繁忙，请稍候重试...");
        }

        return returnObject;
    }


    @RequestMapping("/detailActivity.do")
    public String detailActivityPage(String id,HttpServletRequest request){
        //调用service层方法，查询数据
        Activity activity = activityService.queryActivityForDetailById(id);
        List<ActivityRemark> activityRemarkList = activityRemarkService.queryActivityRemarkForDetailByActivityId(id);
        //把数据保存到request中
        request.setAttribute("activity",activity);
        request.setAttribute("remarkList",activityRemarkList);
        //请求转发
        return "workbench/activity/detail";
    }
}



































