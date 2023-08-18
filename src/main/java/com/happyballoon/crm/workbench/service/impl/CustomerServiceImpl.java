package com.happyballoon.crm.workbench.service.impl;

import com.happyballoon.crm.workbench.domain.ClueRemark;
import com.happyballoon.crm.workbench.domain.Customer;
import com.happyballoon.crm.workbench.domain.CustomerRemark;
import com.happyballoon.crm.workbench.mapper.CustomerMapper;
import com.happyballoon.crm.workbench.mapper.CustomerRemarkMapper;
import com.happyballoon.crm.workbench.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Autowired
    private CustomerMapper customerMapper;
    @Autowired
    private CustomerRemarkMapper customerRemarkMapper;

    public List<Customer> queryCustomerByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectCustomerForPageByCondition(map);
    }

    public int queryTotalCountByConditionForPage(Map<String, Object> map) {
        return customerMapper.selectTotalCountForPageByCondition(map);
    }

    public List<String> queryAllCustomerNameByName(String customerName) {
        return customerMapper.selectAllCustomerNameByName(customerName);
    }

    public Customer queryCustomerByName(String customerName) {
        return customerMapper.selectCustomerByName(customerName);
    }

    public int saveCreateCustomer(Customer customer) {
        return customerMapper.insertCustomer(customer);
    }

    public Customer queryCustomerForEditById(String id) {
        return customerMapper.selectByPrimaryKey(id);
    }

    public int saveEditCustomer(Customer customer) {
        return customerMapper.updateByPrimaryKeySelective(customer);
    }

    public Customer queryCustomerForDetailById(String id) {
        return customerMapper.selectCustomerForDetailById(id);
    }

    public List<CustomerRemark> queryCustomerRemarkListByCid(String id) {
        return customerRemarkMapper.selectCustomerRemarkListByCid(id);
    }

    public void deleteCustomerByIds(String[] id) {
        //删除客户备注
        customerRemarkMapper.deleteCustomerRemarkBycustomerIds(id);
        //删除客户
        customerMapper.deleteCustomerByIds(id);
    }

    public int saveEditCustomerRemark(CustomerRemark remark) {
        return customerRemarkMapper.updateByPrimaryKeySelective(remark);
    }
}
