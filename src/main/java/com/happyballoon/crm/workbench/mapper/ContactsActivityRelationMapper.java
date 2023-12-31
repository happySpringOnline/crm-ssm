package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.ContactsActivityRelation;

import java.util.List;
import java.util.Map;

public interface ContactsActivityRelationMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    int insert(ContactsActivityRelation row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    int insertSelective(ContactsActivityRelation row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    ContactsActivityRelation selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    int updateByPrimaryKeySelective(ContactsActivityRelation row);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_contacts_activity_relation
     *
     * @mbg.generated Fri Aug 18 18:59:02 CST 2023
     */
    int updateByPrimaryKey(ContactsActivityRelation row);

    int insertRelationByList(List<ContactsActivityRelation> list);

    int deleteRelationByAidAndCid(Map<String,Object> map);

    int deleteRelationByCids(String[] contactsId);

    int deleteRelationByAids(String[] activityId);
}