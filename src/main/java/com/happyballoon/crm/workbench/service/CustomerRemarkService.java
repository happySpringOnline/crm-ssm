package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.domain.CustomerRemark;

public interface CustomerRemarkService {
    int saveCustomerRemark(CustomerRemark remark);
    int saveEditCustomerRemark(CustomerRemark remark);
    int deleteCustomerRemarkById(String id);
}
