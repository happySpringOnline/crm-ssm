package com.happyballoon.crm.settings.web.controller;

import com.happyballoon.crm.commons.domain.ReturnObject;
import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/settings/qx/user")
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/toLogin.do")
    public String toLogin(){
        System.out.println("跳转到登录页面");
        return "settings/qx/user/login";
    }

    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd,
                        String isRemPwd, HttpServletRequest request,
                        HttpServletResponse response){
        System.out.println("进入登录验证页面");

        //封装参数
        Map<String, Object> map = new HashMap<String, Object>();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        //调用service层，调用方法查询用户
        User user = userService.queryUserByLoginActAndLoginPwd(map);
        //根据查询结果，生成响应信息
        ReturnObject returnObject = new ReturnObject();
        if (user==null){
            //登录失败，用户不存在
            returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
            returnObject.setMessage("登录失败，账户名或者密码错误！");
        }else {//进一步判断账户是否合法
            //String expireTime = user.getExpireTime();
            //SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            //String nowStr = DateUtils.formateDate(new Date());
            if (DateUtil.formateDate(new Date()).compareTo(user.getExpireTime()) > 0 ){
                //登录失败，账号已过期
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("登录失败，账号已过期！");
            }else if("0".equals(user.getLockState())){
                //登录失败，状态被锁定
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("登录失败，状态被锁定！");
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())){
                //登录失败，ip受限
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_FAIL);
                returnObject.setMessage("登录失败，ip受限！");
            }else {
                //验证成功
                returnObject.setCode(Constants.RETURN_OBJECT_CODE_SUCCESS);
                //把查出来的user存入session域中
                request.getSession().setAttribute(Constants.SESSION_USER,user);

                //如果需要记住密码，则往外写cookie
                if ("true".equals(isRemPwd)){
                    //创建Cookie对象存储登录名
                    Cookie c1 = new Cookie("loginAct", user.getLoginAct());
                    //创建Cookie对象存储登录密码
                    Cookie c2 = new Cookie("loginPwd", user.getLoginPwd());
                    //设置cookie的有效期为十天
                    c1.setMaxAge(10*24*60*60);
                    c2.setMaxAge(10*24*60*60);
                    //响应cookie给浏览器
                    response.addCookie(c1);
                    response.addCookie(c2);
                }else {
                    Cookie c1 = new Cookie("loginAct", "1");
                    Cookie c2 = new Cookie("loginPwd", "1");
                    c1.setMaxAge(0);
                    c2.setMaxAge(0);
                    response.addCookie(c1);
                    response.addCookie(c2);
                }
            }
        }
        return returnObject;
    }

    @RequestMapping("/logout.do")
    public String logout(HttpServletResponse response, HttpSession session){
        System.out.println("正在操作退出系统之前的准备...");
        //清空cookie
        Cookie c1 = new Cookie("loginAct", "1");
        Cookie c2 = new Cookie("loginPwd", "1");
        c1.setMaxAge(0);
        c2.setMaxAge(0);
        response.addCookie(c1);
        response.addCookie(c2);
        //销毁session
        session.invalidate();
        //跳转首页
        return "redirect:/";

    }
}
