package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.domain.CustomerRemark;
import com.happyballoon.crm.workbench.mapper.CustomerRemarkMapper;
import com.happyballoon.crm.workbench.service.CustomerRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("customerRemarkService")
public class CustomerRemarkServiceImpl implements CustomerRemarkService {

    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    public int saveCustomerRemark(CustomerRemark remark) {
        return customerRemarkMapper.insert(remark);
    }

    public int saveEditCustomerRemark(CustomerRemark remark) {
        return customerRemarkMapper.updateByPrimaryKeySelective(remark);
    }

    public int deleteCustomerRemarkById(String id) {
        return customerRemarkMapper.deleteByPrimaryKey(id);
    }
}
