package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.Activity;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int saveCreateActivity(Activity activity);

    List<Activity> queryActivityByConditionForPage(Map<String,Object> map);

    int queryCountOfActivityByCondition(Map<String,Object> map);

   void deleteActivityByIds(String[] ids);

    Activity queryActivityById(String id);

    int saveEditedActivity(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> querySelectedActivities(String[] ids);

    int saveCreateActivityByList(List<Activity> activityList);

    Activity queryActivityForDetailById(String id);

    List<Activity> queryActivityForDetailByClueId(String clueId);

    List<Activity> queryActivityForDetailByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityForDetailByIds(String[] ids);

    List<Activity> queryActivityForConvertByNameAndClueId(Map<String,Object> map);

    List<Activity> queryActivityListAllByAName(String activityName);

    List<Activity> queryActivityListByContactsId(String contactsId);

    List<Activity> queryActivityListForBundRelationByAnameAndCid(Map<String,Object> map);
}
