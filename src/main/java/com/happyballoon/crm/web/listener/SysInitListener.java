package com.happyballoon.crm.web.listener;

import com.happyballoon.crm.settings.domain.DicType;
import com.happyballoon.crm.settings.domain.DicValue;
import com.happyballoon.crm.settings.service.DicTypeService;
import com.happyballoon.crm.settings.service.DicValueService;
import com.happyballoon.crm.settings.service.impl.DicTypeServiceImpl;
import com.happyballoon.crm.settings.service.impl.DicValueServiceImpl;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import java.util.*;

@Service
public class SysInitListener implements ServletContextListener,ApplicationContextAware {

    private static ApplicationContext applicationContext;

    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        SysInitListener.applicationContext = applicationContext;
    }

    public void contextInitialized(ServletContextEvent servletContextEvent) {
        System.out.println("上下文对象创建成功了============================================");
        ServletContext application = servletContextEvent.getServletContext();

        DicTypeService dicTypeService = applicationContext.getBean(DicTypeService.class);
        DicValueService dicValueService = applicationContext.getBean(DicValueService.class);

        List<DicType> dicTypeList = dicTypeService.queryAllDicType();
        for (DicType dicType:dicTypeList){
            String typeCode = dicType.getCode();
            List<DicValue> dicValueList = dicValueService.queryDicValueByTypeCode(typeCode);
            application.setAttribute(typeCode,dicValueList);
        }

        //***************************************************************************

        ResourceBundle bundle = ResourceBundle.getBundle("possibility");
        Enumeration<String> keys = bundle.getKeys();

        Map<String, String> pMap = new HashMap<String, String>();
        while (keys.hasMoreElements()){
            String stage = keys.nextElement();
            String possibility = bundle.getString(stage);
            pMap.put(stage,possibility);
        }

        application.setAttribute("pMap",pMap);

    }

    public void contextDestroyed(ServletContextEvent servletContextEvent) {
        System.out.println("上下文对象创建销毁了============================================");
    }
}
