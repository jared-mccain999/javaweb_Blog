package com.Ryan.service.impl;

import com.Ryan.entity.user.User;
import com.Ryan.mapper.UserMapper;
import com.Ryan.service.UserService;
import com.Ryan.dto.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public Integer count() {
        // 统计列表数量
        try {
            return userMapper.count();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


    @Override
    public PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword) {
        int offset = (page - 1) * pageSize;
        List<User> users = userMapper.findByPage(keyword, sort, offset, pageSize);
        int total = userMapper.countByKeyword(keyword);
        PageInfo<User> pageInfo = new PageInfo<>();
        pageInfo.setList(users);
        pageInfo.setSort(sort);
        pageInfo.setTotal(total);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setPages((int) Math.ceil((double)total / pageSize));

        return pageInfo;
    }

    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }

    @Override
    public boolean updateById(User user) {
        if(userMapper.updateById(user) > 0){
            return true;
        }
        return false;
    }
}
