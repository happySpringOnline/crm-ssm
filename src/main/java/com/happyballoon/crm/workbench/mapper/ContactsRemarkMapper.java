package com.happyballoon.crm.workbench.mapper;

import com.happyballoon.crm.workbench.domain.Contacts;
import com.happyballoon.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkMapper {

    int deleteByPrimaryKey(String id);

    int insert(ContactsRemark row);

    int insertSelective(ContactsRemark row);

    ContactsRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ContactsRemark row);

    int updateByPrimaryKey(ContactsRemark row);

    int insertContactsRemarkByList(List<ContactsRemark> list);

    List<ContactsRemark> selectContactsRemarkByContactsId(String contactsId);

    int deleteContactsRemarkById(String id);

    int deleteContactsRemarkByContactsIds(String[] id);


}