package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.Activity;
import com.happyballoon.crm.workbench.mapper.ActivityMapper;
import com.happyballoon.crm.workbench.mapper.ActivityRemarkMapper;
import com.happyballoon.crm.workbench.mapper.ClueActivityRelationMapper;
import com.happyballoon.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.happyballoon.crm.workbench.service.ActivityRemarkService;
import com.happyballoon.crm.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("activityService")
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;
    @Autowired
    private ActivityRemarkMapper activityRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;

    public int saveCreateActivity(Activity activity) {
        return activityMapper.insertActivity(activity);
    }

    public List<Activity> queryActivityByConditionForPage(Map<String, Object> map) {
        return activityMapper.selectActivityByConditionForPage(map);
    }

    public int queryCountOfActivityByCondition(Map<String, Object> map) {
        return activityMapper.selectCountOfActivityByCondition(map);
    }

    public void deleteActivityByIds(String[] ids) {
        //删除市场活动备注
        activityRemarkMapper.deleteActivityRemarkByAids(ids);
        //删除市场活动的关联关系：联系人/线索
        clueActivityRelationMapper.deleteRelationByAids(ids);
        contactsActivityRelationMapper.deleteRelationByAids(ids);
        //删除市场活动
        activityMapper.deleteActivityByIds(ids);
    }

    public Activity queryActivityById(String id) {
        return activityMapper.selectActivityById(id);
    }

    public int saveEditedActivity(Activity activity) {
        return activityMapper.updateEditedActivity(activity);
    }

    public List<Activity> queryAllActivities() {
        return activityMapper.selectAllActivities();
    }

    public List<Activity> querySelectedActivities(String[] ids) {
        return activityMapper.selectSelectedActivities(ids);
    }

    public int saveCreateActivityByList(List<Activity> activityList) {
        return activityMapper.insertActivityByList(activityList);
    }

    public Activity queryActivityForDetailById(String id) {
        return activityMapper.selectActivityForDetailById(id);
    }

    public List<Activity> queryActivityForDetailByClueId(String clueId) {
        return activityMapper.selectActivityForDetailByClueId(clueId);
    }

    public List<Activity> queryActivityForDetailByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForDetailByNameAndClueId(map);
    }

    public List<Activity> queryActivityForDetailByIds(String[] ids) {
        return activityMapper.selectActivityForDetailByIds(ids);
    }

    public List<Activity> queryActivityForConvertByNameAndClueId(Map<String, Object> map) {
        return activityMapper.selectActivityForConvertByNameAndClueId(map);
    }

    public List<Activity> queryActivityListAllByAName(String activityName) {
        return activityMapper.selectActivityListAllByAName(activityName);
    }

    public List<Activity> queryActivityListByContactsId(String contactsId) {
        return activityMapper.selectActivityListByContactsId(contactsId);
    }

    public List<Activity> queryActivityListForBundRelationByAnameAndCid(Map<String, Object> map) {
        return activityMapper.selectActivityListForBundRelationByAnameAndCid(map);
    }


}
