package com.Ryan.service;

import com.Ryan.dto.BlogCreateDto;
import com.Ryan.dto.BlogDto;
import com.Ryan.entity.blog.Blog;
import com.Ryan.dto.PageInfo;
import com.Ryan.entity.tag.Tag;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;


public interface BlogService{
    Object count();

    PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword, Integer userId, Integer areaId);

    PageInfo<BlogDto> UserfindByPage(int page,int pageSize,String keyword);

    boolean updateBlog(BlogDto blogdto);

    PageInfo<BlogDto> HotfindByPage(Integer page, int pageSize);

    List<Tag> getAllTags();

    Blog createBlog(BlogCreateDto blogDto, String token);

    List<BlogDto> findByUserId(Integer id);

    PageInfo<Blog> getBlogsByAreaId(Long areaId, int page, int size);

    PageInfo<Blog> getAllBlogs(int page, int size);
}
