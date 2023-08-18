package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.Contacts;
import com.happyballoon.crm.workbench.domain.ContactsActivityRelation;
import com.happyballoon.crm.workbench.domain.ContactsRemark;

import java.util.List;
import java.util.Map;

public interface ContactsService {

    List<Contacts> queryContactsListByCName(String contactsName);

    List<Contacts> queryContactsForPageByCondition(Map<String,Object> map);

    int queryCountForPageByCondition(Map<String,Object> map);

    void saveContacts(Map<String,Object> map);

    Contacts queryContactsForDetailById(String id);

    Contacts queryContactsForEditById(String id);

    void saveEditedContacts(Map<String,Object> map);

    int deleteRelationByAidAndCid(Map<String,Object> map);

    int saveRelationsByList(List<ContactsActivityRelation> list);

    List<Contacts> queryContactsListByCustomerId(String customerId);

    void deleteContactsByIds(String[] id);
}
