package com.happyballoon.crm.settings.service.impl;

import com.happyballoon.crm.settings.domain.User;
import com.happyballoon.crm.settings.mapper.UserMapper;
import com.happyballoon.crm.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("userService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    public User queryUserByLoginActAndLoginPwd(Map<String, Object> map) {
        return userMapper.selectUserByLoginActAndLoginPwd(map);
    }

    public List<User> queryAllUsers() {
        return userMapper.selectAllUsers();
    }
}
