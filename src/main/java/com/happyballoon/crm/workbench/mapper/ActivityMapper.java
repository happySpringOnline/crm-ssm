package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.Activity;
import com.happyballoon.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Sat Aug 05 16:47:18 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Sat Aug 05 16:47:18 CST 2023
     */
    int insertSelective(Activity row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Sat Aug 05 16:47:18 CST 2023
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Sat Aug 05 16:47:18 CST 2023
     */
    int updateByPrimaryKeySelective(Activity row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbg.generated Sat Aug 05 16:47:18 CST 2023
     */
    int updateByPrimaryKey(Activity row);

    /**
     * 保存创建的市场活动
     */
    int insertActivity(Activity activity);

    /**
     * 根据条件分页查询市场活动的列表
     * @param map
     * @return
     */
    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    /**
     * 根据条件查询市场活动的总条数
     * @param map
     * @return
     */
    int selectCountOfActivityByCondition(Map<String,Object> map);

    /**
     * 根据ids批量删除市场活动
     * @param ids
     * @return
     */
    int deleteActivityByIds(String[] ids);

    /**
     * 根据id查询市场活动的信息
     * @param id
     * @return
     */
    Activity selectActivityById(String id);

    /**
     * 保存修改后的市场活动
     * @return
     */
    int updateEditedActivity(Activity activity);

    /**
     * 查询所有的市场活动
     * @return
     */
    List<Activity> selectAllActivities();

    /**
     * 根据ids查询市场活动信息
     */
    List<Activity> selectSelectedActivities(String[] ids);

    /**
     *批量保存创建的市场活动
     * @param activityList
     * @return
     */
    int insertActivityByList(List<Activity> activityList);

    /**
     * 根据id查询市场活动的明细信息
     * @param id
     * @return
     */
    Activity selectActivityForDetailById(String id);

    /**
     * 根据clueId查询相关联的市场活动明细页面
     * @param clueID
     * @return
     */
    List<Activity> selectActivityForDetailByClueId(String clueID);

    List<Activity> selectActivityForDetailByNameAndClueId(Map<String,Object> map);

    List<Activity> selectActivityForDetailByIds(String[] ids);

    List<Activity> selectActivityForConvertByNameAndClueId(Map<String,Object> map);

    List<Activity> selectActivityListAllByAName(String activityName);

    List<Activity> selectActivityListByContactsId(String contactsId);

    List<Activity> selectActivityListForBundRelationByAnameAndCid(Map<String,Object> map);

}