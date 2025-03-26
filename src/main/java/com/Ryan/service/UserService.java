package com.Ryan.service;

import com.Ryan.dto.RegisterDto;
import com.Ryan.entity.logininfo.Logininfo;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.dto.PageInfo;
import jakarta.validation.Valid;

import java.util.List;


public interface UserService {
    List<User> findAll();

    Object count();

    PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword);

    User findById(Integer id);

    boolean updateById(User user);

    Result<Logininfo> loginSysAdmin(User user);

    Result<Logininfo> loginSysUser(@Valid User user);

    Result<User> register(RegisterDto registerDto);

    Result<Logininfo> Userlogin(RegisterDto registerDto);

    User getUserByToken(String token) throws Exception;
}
