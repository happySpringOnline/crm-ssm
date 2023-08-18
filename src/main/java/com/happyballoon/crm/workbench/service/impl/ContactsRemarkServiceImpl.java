package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.Contacts;
import com.happyballoon.crm.workbench.domain.ContactsRemark;
import com.happyballoon.crm.workbench.mapper.ContactsRemarkMapper;
import com.happyballoon.crm.workbench.service.ContactsRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service("contactsRemarkService")
public class ContactsRemarkServiceImpl implements ContactsRemarkService {

    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;

    public List<ContactsRemark> queryContactsByContactsId(String contactsId) {
        return contactsRemarkMapper.selectContactsRemarkByContactsId(contactsId);
    }

    public int saveContactsRemark(ContactsRemark remark) {
        return contactsRemarkMapper.insertSelective(remark);
    }

    public int deleteContactsRemarkById(String id) {
        return contactsRemarkMapper.deleteContactsRemarkById(id);
    }

    public int updateContactsRemark(ContactsRemark remark) {
        return contactsRemarkMapper.updateByPrimaryKeySelective(remark);
    }
}
