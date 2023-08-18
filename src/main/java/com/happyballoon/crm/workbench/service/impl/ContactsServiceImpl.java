package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.workbench.domain.Contacts;
import com.happyballoon.crm.workbench.domain.ContactsActivityRelation;
import com.happyballoon.crm.workbench.domain.ContactsRemark;
import com.happyballoon.crm.workbench.domain.Customer;
import com.happyballoon.crm.workbench.mapper.ContactsActivityRelationMapper;
import com.happyballoon.crm.workbench.mapper.ContactsMapper;
import com.happyballoon.crm.workbench.mapper.ContactsRemarkMapper;
import com.happyballoon.crm.workbench.mapper.CustomerMapper;
import com.happyballoon.crm.workbench.service.ContactsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    ContactsRemarkMapper contactsRemarkMapper;

    public List<Contacts> queryContactsListByCName(String contactsName) {
        return contactsMapper.selectContactsListAllByCName(contactsName);
    }

    public List<Contacts> queryContactsForPageByCondition(Map<String, Object> map) {
        return contactsMapper.selectContactsForPageByCondition(map);
    }

    public int queryCountForPageByCondition(Map<String, Object> map) {
        return contactsMapper.selectCountForPageByCondition(map);
    }

    public void saveContacts(Map<String,Object> map) {
        String customerName = (String) map.get("customerName");
        User currentUser = (User) map.get(Constants.SESSION_USER);
        //根据客户名字查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer==null){//查不到客户，新建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(currentUser.getId());
            customer.setCreateBy(currentUser.getId());
            customer.setCreateTime(DateUtil.formateDateTime(new Date()));
            customer.setName(customerName);

            customerMapper.insertCustomer(customer);
        }
        Contacts contacts = new Contacts();

        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner((String) map.get("owner"));
        contacts.setSource((String) map.get("source"));
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setJob((String) map.get("job"));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        contacts.setBirth((String) map.get("birth"));
        contacts.setCreateBy(currentUser.getId());
        contacts.setCustomerId(customer.getId());
        contacts.setCreateTime(DateUtil.formateDateTime(new Date()));

        contactsMapper.insertContacts(contacts);
    }

    public Contacts queryContactsForDetailById(String id) {
        return contactsMapper.selectContactsForDetailById(id);
    }

    public Contacts queryContactsForEditById(String id) {
        return contactsMapper.selectContactsForEditById(id);
    }

    public void saveEditedContacts(Map<String, Object> map) {
        User currentUser = (User) map.get(Constants.SESSION_USER);
        String customerName = (String) map.get("customerName");
        //根据客户名字查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer==null){//查不到客户，新建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setOwner(currentUser.getId());
            customer.setCreateBy(currentUser.getId());
            customer.setCreateTime(DateUtil.formateDateTime(new Date()));
            customer.setName(customerName);

            customerMapper.insertCustomer(customer);
        }
        Contacts contacts = new Contacts();

        contacts.setId((String) map.get("id"));
        contacts.setOwner((String) map.get("owner"));
        contacts.setSource((String) map.get("source"));
        contacts.setFullname((String) map.get("fullname"));
        contacts.setAppellation((String) map.get("appellation"));
        contacts.setEmail((String) map.get("email"));
        contacts.setMphone((String) map.get("mphone"));
        contacts.setJob((String) map.get("job"));
        contacts.setDescription((String) map.get("description"));
        contacts.setContactSummary((String) map.get("contactSummary"));
        contacts.setNextContactTime((String) map.get("nextContactTime"));
        contacts.setAddress((String) map.get("address"));
        contacts.setBirth((String) map.get("birth"));
        contacts.setEditBy(currentUser.getId());
        contacts.setCustomerId(customer.getId());
        contacts.setEditTime(DateUtil.formateDateTime(new Date()));

        contactsMapper.updateByPrimaryKeySelective(contacts);
    }

    public int deleteRelationByAidAndCid(Map<String, Object> map) {
        return contactsActivityRelationMapper.deleteRelationByAidAndCid(map);
    }

    public int saveRelationsByList(List<ContactsActivityRelation> list) {
        return contactsActivityRelationMapper.insertRelationByList(list);
    }

    public List<Contacts> queryContactsListByCustomerId(String customerId) {
        return contactsMapper.selectContactsListByCustomerId(customerId);
    }

    public void deleteContactsByIds(String[] id) {
        //删除联系人备注
        contactsRemarkMapper.deleteContactsRemarkByContactsIds(id);
        //删除联系人的关联关系
        contactsActivityRelationMapper.deleteRelationByCids(id);
        //删除联系人
        contactsMapper.deleteContactsByIds(id);
    }
}
