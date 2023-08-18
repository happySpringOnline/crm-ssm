package com.happyballoon.crm.workbench.service;

import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.domain.Customer;
import com.happyballoon.crm.workbench.domain.CustomerRemark;

import java.util.List;
import java.util.Map;

public interface CustomerService {

    List<Customer> queryCustomerByConditionForPage(Map<String,Object> map);

    int queryTotalCountByConditionForPage(Map<String,Object> map);

    List<String> queryAllCustomerNameByName(String customerName);

    Customer queryCustomerByName(String customerName);

    int saveCreateCustomer(Customer customer);

    Customer queryCustomerForEditById(String id);

    int saveEditCustomer(Customer customer);

    Customer queryCustomerForDetailById(String id);

    List<CustomerRemark> queryCustomerRemarkListByCid(String id);

    void deleteCustomerByIds(String[] id);


}
