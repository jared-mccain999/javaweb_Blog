package com.Ryan.service;

import com.Ryan.dto.BlogDto;
import com.Ryan.entity.blog.Blog;
import com.Ryan.dto.PageInfo;


public interface BlogService{
    Object count();

    PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword, Integer userId, Integer areaId);

    PageInfo<BlogDto> UserfindByPage(int page,int pageSize,String keyword);

    boolean updateBlog(BlogDto blogdto);

    PageInfo<BlogDto> HotfindByPage(Integer page, int pageSize);
}
