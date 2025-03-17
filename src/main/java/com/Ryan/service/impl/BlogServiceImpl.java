package com.Ryan.service.impl;

import com.Ryan.entity.blog.Blog;
import com.Ryan.mapper.BlogMapper;
import com.Ryan.service.BlogService;
import com.Ryan.dto.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;



@Service
public class BlogServiceImpl implements BlogService {

    @Autowired
    public BlogMapper blogMapper;


    //@Override
//public PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword) {
//    int offset = (page - 1) * pageSize;
//    List<User> users = userMapper.findByPage(keyword, sort, offset, pageSize);
//    System.out.println("Service");
//    System.out.println(users.toString());
//    int total = userMapper.countByKeyword(keyword);
//
//    PageInfo<User> pageInfo = new PageInfo<>();
//    pageInfo.setList(users);
//    pageInfo.setSort(sort);
//    pageInfo.setTotal(total);
//    pageInfo.setPage(page);
//    pageInfo.setPageSize(pageSize);
//    pageInfo.setPages((int) Math.ceil((double)total / pageSize));
//
//    return pageInfo;
//}
    @Override
    public Integer count() {
        return blogMapper.count();
    }

    @Override
    public PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword) {
        int offset = (page - 1) * pageSize;
        List<Blog> blogs = blogMapper.findByPage(keyword, sort, offset, pageSize);
        System.out.println("Service" + blogs.toString());
        int total = blogMapper.countByKeyword(keyword);
        PageInfo<Blog> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        pageInfo.setSort(sort);
        pageInfo.setTotal(total);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setPages((int) Math.ceil((double)total / pageSize));
        return pageInfo;
    }
}
