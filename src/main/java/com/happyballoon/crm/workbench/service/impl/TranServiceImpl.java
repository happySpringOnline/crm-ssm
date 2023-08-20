package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.commons.Constants;
import com.happyballoon.crm.commons.utils.DateUtil;
import com.happyballoon.crm.commons.utils.UUIDUtil;
import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.workbench.domain.Customer;
import com.happyballoon.crm.workbench.domain.FunnelVO;
import com.happyballoon.crm.workbench.domain.Tran;
import com.happyballoon.crm.workbench.domain.TranHistory;
import com.happyballoon.crm.workbench.mapper.CustomerMapper;
import com.happyballoon.crm.workbench.mapper.TranHistoryMapper;
import com.happyballoon.crm.workbench.mapper.TranMapper;
import com.happyballoon.crm.workbench.mapper.TranRemarkMapper;
import com.happyballoon.crm.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;

@Service("tranService")
public class TranServiceImpl implements TranService {

    @Autowired
    private TranMapper tranMapper;
    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private TranHistoryMapper tranHistoryMapper;
    @Autowired
    private TranRemarkMapper tranRemarkMapper;

    public void saveCreateTran(Map<String,Object> map) {
        String customerName = (String) map.get("customerName");
        User currentUser = (User) map.get(Constants.SESSION_USER);
        //根据客户名字查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer==null){//查不到客户，新建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(currentUser.getId());
            customer.setCreateTime(DateUtil.formateDateTime(new Date()));
            customer.setName(customerName);
            customer.setOwner(currentUser.getId());

            customerMapper.insertCustomer(customer);
        }
        //保存创建的交易
        Tran tran = new Tran();

        tran.setId(UUIDUtil.getUUID());
        tran.setMoney((String) map.get("money"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setCreateBy(currentUser.getId());
        tran.setCreateTime(DateUtil.formateDateTime(new Date()));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setStage((String) map.get("stage"));
        tran.setOwner((String) map.get("owner"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setName((String) map.get("name"));

        tranMapper.insertTran(tran);

        //保存交易历史
        TranHistory tranHistory = new TranHistory();
        tranHistory.setCreateBy(currentUser.getId());
        tranHistory.setCreateTime(DateUtil.formateDateTime(new Date()));
        tranHistory.setExpectedDate(tran.getExpectedDate());
        tranHistory.setId(UUIDUtil.getUUID());
        tranHistory.setMoney(tran.getMoney());
        tranHistory.setStage(tran.getStage());
        tranHistory.setTranId(tran.getId());

        tranHistoryMapper.insertTranHistory(tranHistory);

    }

    public int queryTotalCountForPageByCondition(Map<String, Object> map) {
        return tranMapper.selectTotalCountForPageByCondition(map);
    }

    public List<Tran> queryTranListForPageByCondition(Map<String, Object> map) {
        return tranMapper.selectTranListForPageByCondition(map);
    }

    public Tran queryTranEditForEditById(String id) {
        return tranMapper.selectTranForEditById(id);
    }

    public void saveEditedTran(Map<String, Object> map) {
        String customerName = (String) map.get("customerName");
        User currentUser = (User) map.get(Constants.SESSION_USER);
        //根据客户名字查询客户
        Customer customer = customerMapper.selectCustomerByName(customerName);
        if (customer==null){//查不到客户，新建客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setCreateBy(currentUser.getId());
            customer.setCreateTime(DateUtil.formateDateTime(new Date()));
            customer.setName(customerName);

            customerMapper.insertCustomer(customer);
        }
        //保存修改后的交易
        Tran tran = new Tran();

        tran.setId((String) map.get("id"));
        tran.setMoney((String) map.get("money"));
        tran.setExpectedDate((String) map.get("expectedDate"));
        tran.setCustomerId(customer.getId());
        tran.setType((String) map.get("type"));
        tran.setSource((String) map.get("source"));
        tran.setActivityId((String) map.get("activityId"));
        tran.setContactsId((String) map.get("contactsId"));
        tran.setEditBy(currentUser.getId());
        tran.setEditTime(DateUtil.formateDateTime(new Date()));
        tran.setDescription((String) map.get("description"));
        tran.setContactSummary((String) map.get("contactSummary"));
        tran.setStage((String) map.get("stage"));
        tran.setOwner((String) map.get("owner"));
        tran.setNextContactTime((String) map.get("nextContactTime"));
        tran.setName((String) map.get("name"));

        tranMapper.updateByPrimaryKeySelective(tran);
    }

    public Tran queryTranForDetailById(String id) {
        return tranMapper.selectTranForDetailById(id);
    }

    public List<FunnelVO> queryCountOfTranGroupByStage() {
        return tranMapper.selectCountOfTranGroupByStage();
    }

    public List<Tran> queryTranListByContactsId(String contactsId) {
        List<Tran> tranList = tranMapper.selectTranListByContactsId(contactsId);
        for (Tran t:tranList){
            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibilty = bundle.getString(t.getStage());
            t.setPossibility(possibilty);
        }
        return tranList;
    }

    public void deleteContactsByIds(String[] id) {
        //删除交易备注
        tranRemarkMapper.deleteTranRemarkByTranIds(id);
        //删除交易历史
        tranHistoryMapper.deleteTranHistoryByTranIds(id);
        //删除交易
        tranMapper.deleteContactsByIds(id);
    }

    public List<Tran> queryTranListByCustomerId(String customerId) {
        List<Tran> tranList = tranMapper.selectTranListByCustomerId(customerId);
        for (Tran t:tranList){
            ResourceBundle bundle = ResourceBundle.getBundle("possibility");
            String possibilty = bundle.getString(t.getStage());
            t.setPossibility(possibilty);
        }
        return tranList;
    }

    public void updateStage(Tran tran, TranHistory tranHitsory) {
        tranMapper.updateByPrimaryKeySelective(tran);
        tranHistoryMapper.insertTranHistory(tranHitsory);
    }

}
