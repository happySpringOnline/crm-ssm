package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.Contacts;
import com.happyballoon.crm.workbench.domain.ContactsRemark;

import java.util.List;

public interface ContactsRemarkService {

    List<ContactsRemark> queryContactsByContactsId(String contactsId);

    int saveContactsRemark(ContactsRemark remark);

    int deleteContactsRemarkById(String id);

    int updateContactsRemark(ContactsRemark remark);
}
