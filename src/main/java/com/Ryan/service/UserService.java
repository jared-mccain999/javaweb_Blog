package com.Ryan.service;

import com.Ryan.entity.user.User;
import com.Ryan.util.page.PageInfo;

import java.util.List;


public interface UserService {
    List<User> findAll();

    Object count();

    PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword);
}
