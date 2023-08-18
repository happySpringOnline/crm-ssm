package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.workbench.domain.*;
import com.happyballoon.crm.workbench.mapper.*;
import com.happyballoon.crm.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

@Service("clueService")
public class ClueServiceImpl implements ClueService {

    @Autowired
    private ClueMapper clueMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private ContactsMapper contactsMapper;
    @Autowired
    private ClueRemarkMapper clueRemarkMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;
    @Autowired
    private ContactsRemarkMapper contactsRemarkMapper;
    @Autowired
    private ClueActivityRelationMapper clueActivityRelationMapper;
    @Autowired
    private ContactsActivityRelationMapper contactsActivityRelationMapper;
    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;

    public int saveCreateClue(Clue clue) {
        return clueMapper.insertCreateClue(clue);
    }

    public List<Clue> queryClueByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueByConditionForPage(map);
    }

    public int queryClueCountByConditionForPage(Map<String, Object> map) {
        return clueMapper.selectClueCountByConditionForPage(map);
    }

    public Clue queryClueForDetailById(String id) {
        return clueMapper.selectClueForDetailById(id);
    }

    public Clue queryClueForEditById(String id) {
        return clueMapper.selectByPrimaryKey(id);
    }

    public int saveEditedClue(Clue clue) {
        return clueMapper.updateByPrimaryKeySelective(clue);
    }

    public void saveConvertClue(Map<String, Object> map) {
        String clueId = (String) map.get("clueId");
        User user = (User) map.get(Constants.SESSION_USER);
        //根据id查询线索的具体信息
        Clue clue = clueMapper.selectClueForConvertById(clueId);
        //把该线索中有关公司的信息转换到客户表中
        Customer customer = new Customer();
        customer.setId(UUIDUtil.getUUID());
        customer.setOwner(user.getId());//当前用户
        customer.setName(clue.getCompany());
        customer.setWebsite(clue.getWebsite());
        customer.setPhone(clue.getPhone());
        customer.setCreateBy(user.getId());//当前用户
        customer.setCreateTime(DateUtil.formateDateTime(new Date()));
        customer.setContactSummary(clue.getContactSummary());
        customer.setNextContactTime(clue.getNextContactTime());
        customer.setDescription(clue.getDescription());
        customer.setAddress(clue.getAddress());
        customerMapper.insertCustomer(customer);
        //把该线索中有关个人的信息转换到联系人表中
        Contacts contacts = new Contacts();
        contacts.setId(UUIDUtil.getUUID());
        contacts.setOwner(user.getId());
        contacts.setSource(clue.getSource());
        contacts.setCustomerId(customer.getId());
        contacts.setFullname(clue.getFullname());
        contacts.setAppellation(clue.getAppellation());
        contacts.setEmail(clue.getEmail());
        contacts.setMphone(clue.getMphone());
        contacts.setJob(clue.getJob());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(DateUtil.formateDateTime(new Date()));
        contacts.setDescription(clue.getDescription());
        contacts.setContactSummary(clue.getContactSummary());
        contacts.setNextContactTime(clue.getNextContactTime());
        contacts.setAddress(clue.getAddress());
        contactsMapper.insertContacts(contacts);

        //根据clueId查询该线索下所有的备注
        List<ClueRemark> clueRemarkList = clueRemarkMapper.selectClueRemarkByClueId(clueId);
        //把该线索下的所有备注转换到客户备注表中一份
        if (clueRemarkList!=null&&clueRemarkList.size()>0){
            CustomerRemark customerRemark = null;
            ContactsRemark contactsRemark = null;
            List<ContactsRemark> contactsRemarks = new ArrayList<ContactsRemark>();
            List<CustomerRemark> customerRemarks = new ArrayList<CustomerRemark>();
            //遍历clueRemarkList，封装客户备注/封装联系人备注
            for(ClueRemark cr:clueRemarkList){
                customerRemark = new CustomerRemark();

                customerRemark.setId(UUIDUtil.getUUID());
                customerRemark.setNoteContent(cr.getNoteContent());
                customerRemark.setCreateBy(cr.getCreateBy());
                customerRemark.setCreateTime(cr.getCreateTime());
                customerRemark.setEditBy(cr.getEditBy());
                customerRemark.setEditTime(cr.getEditTime());
                customerRemark.setEditFlag(cr.getEditFlag());
                customerRemark.setCustomerId(customer.getId());

                customerRemarks.add(customerRemark);

                contactsRemark = new ContactsRemark();

                contactsRemark.setId(UUIDUtil.getUUID());
                contactsRemark.setNoteContent(cr.getNoteContent());
                contactsRemark.setCreateBy(cr.getCreateBy());
                contactsRemark.setCreateTime(cr.getCreateTime());
                contactsRemark.setEditBy(cr.getEditBy());
                contactsRemark.setEditTime(cr.getEditTime());
                contactsRemark.setEditFlag(cr.getEditFlag());
                contactsRemark.setContactsId(contacts.getId());

                contactsRemarks.add(contactsRemark);
            }
            customerRemarkMapper.insertCustomerRemarkByList(customerRemarks);
            contactsRemarkMapper.insertContactsRemarkByList(contactsRemarks);
        }

        //根据clueId查询该线索和市场活动的关联关系
        List<ClueActivityRelation> clueActivityRelationList = clueActivityRelationMapper.selectRelationByClueId(clueId);

        if (clueActivityRelationList!=null && clueActivityRelationList.size()>0){
            ContactsActivityRelation contactsActivityRelation = null;
            List<ContactsActivityRelation> contactsActivityRelations = new ArrayList<ContactsActivityRelation>();
            //遍历clueActivityRelationList，封装联系人和市场活动关系表
            for (ClueActivityRelation car:clueActivityRelationList){
                contactsActivityRelation = new ContactsActivityRelation();
                contactsActivityRelation.setId(UUIDUtil.getUUID());
                contactsActivityRelation.setContactsId(contacts.getId());
                contactsActivityRelation.setActivityId(car.getActivityId());

                contactsActivityRelations.add(contactsActivityRelation);
            }
            contactsActivityRelationMapper.insertRelationByList(contactsActivityRelations);
        }

        //如果需要创建交易，创建交易。
        String isCreateTransaction = (String) map.get("isCreateTransaction");
        if ("true".equals(isCreateTransaction)){
            Tran tran = new Tran();

            tran.setId(UUIDUtil.getUUID());
            tran.setOwner(user.getId());
            tran.setMoney((String) map.get("money"));
            tran.setName((String) map.get("name"));
            tran.setExpectedDate((String) map.get("expectedDate"));
            tran.setCustomerId(customer.getId());
            tran.setStage((String) map.get("stage"));
            tran.setActivityId((String) map.get("activityId"));
            tran.setContactsId(contacts.getId());
            tran.setCreateBy(user.getId());
            tran.setCreateTime(DateUtil.formateDateTime(new Date()));

            tranMapper.insertTran(tran);

            //保存交易历史
            TranHistory tranHistory = new TranHistory();
            tranHistory.setCreateBy(user.getId());
            tranHistory.setCreateTime(DateUtil.formateDateTime(new Date()));
            tranHistory.setExpectedDate(tran.getExpectedDate());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setStage(tran.getStage());
            tranHistory.setTranId(tran.getId());

            tranHistoryMapper.insertTranHistory(tranHistory);

            //还需要把该线索下所有的备注转换到交易备注
            if (clueRemarkList!=null&&clueRemarkList.size()>0){
                TranRemark tranRemark = null;
                List<TranRemark> tranRemarks = new ArrayList<TranRemark>();

                for (ClueRemark cr:clueRemarkList){
                    tranRemark = new TranRemark();
                    tranRemark.setId(UUIDUtil.getUUID());
                    tranRemark.setNoteContent(cr.getNoteContent());
                    tranRemark.setCreateBy(cr.getCreateBy());
                    tranRemark.setCreateTime(cr.getCreateTime());
                    tranRemark.setEditFlag(cr.getEditFlag());
                    tranRemark.setEditBy(cr.getEditBy());
                    tranRemark.setEditTime(cr.getEditTime());
                    tranRemark.setTranId(tran.getId());

                    tranRemarks.add(tranRemark);

                }
                tranRemarkMapper.insertTranRemarkByList(tranRemarks);

            }
        }

        //删除该线索下所有的备注
        clueRemarkMapper.deleteClueRemarkByclueId(clueId);

        //删除该线索关联关系
        clueRemarkMapper.deleteClueRemarkByclueId(clueId);

        //删除该线索
        clueMapper.deleteByPrimaryKey(clueId);


    }

    public void deleteClueByIds(String[] ids) {
        //删除线索备注
        clueRemarkMapper.deleteClueRemarkByClueIds(ids);
        //删除线索关联的关系
        clueActivityRelationMapper.deleteRelationByclueIds(ids);
        //删除线索
        clueMapper.deleteClueByIds(ids);
    }


}
