package com.Ryan.service;

import com.Ryan.entity.logininfo.Logininfo;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.dto.PageInfo;

import java.util.List;


public interface UserService {
    List<User> findAll();

    Object count();

    PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword);

    User findById(Integer id);

    boolean updateById(User user);

    Result<Logininfo> loginSysAdmin(User user);
}
