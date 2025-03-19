package com.Ryan.service;

import com.Ryan.entity.blog.Blog;
import com.Ryan.dto.PageInfo;


public interface BlogService{
    Object count();

    public PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword, Integer userId);

}
