package com.Ryan.service;

import com.Ryan.entity.blog.Blog;
import com.Ryan.service.impl.BlogServiceImpl;
import com.Ryan.util.page.PageInfo;
import org.springframework.stereotype.Service;


public interface BlogService{
    Object count();

    public PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword);
}
