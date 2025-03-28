package com.Ryan.service.impl;

import com.Ryan.dto.BlogCreateDto;
import com.Ryan.dto.BlogDto;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.blog.BlogTag;
import com.Ryan.entity.tag.Tag;
import com.Ryan.mapper.BlogMapper;
import com.Ryan.mapper.BlogTagMapper;
import com.Ryan.service.BlogService;
import com.Ryan.dto.PageInfo;
import com.Ryan.util.JwtUtils;
import com.github.pagehelper.PageHelper;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.Cookie;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Date;
import java.util.List;
import java.util.UUID;


@Service
public class BlogServiceImpl implements BlogService {

    @Autowired
    public BlogMapper blogMapper;

    @Autowired
    public BlogTagMapper blogTagMapper;
    @Autowired
    private BlogTag blogTag;


    @Override
    public Integer count() {
        return blogMapper.count();
    }

    @Override
    public PageInfo<Blog> findByPage(Integer page, Integer pageSize, String sort, String keyword, Integer userId, Integer areaId) {
        int offset = (page - 1) * pageSize;
        List<Blog> blogs = blogMapper.findByPage(keyword, sort, offset, pageSize, userId, areaId);
        int total = blogMapper.countByKeyword(keyword, userId, areaId, null);
        PageInfo<Blog> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        pageInfo.setSort(sort);
        pageInfo.setTotal(total);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setPages((int) Math.ceil((double) total / pageSize));
        return pageInfo;
    }

    @Override
    public PageInfo<BlogDto> UserfindByPage(int page, int pageSize, String keyword) {
        int offset = (page - 1) * pageSize;
        // 查询数据，根据关键词，以及页数
        List<BlogDto> blogs = blogMapper.UserfindByPage(keyword, offset, pageSize);
        int total = blogMapper.countByKeyword(keyword, null, null, "approved");
        // 根据博客id查询tags
        for (BlogDto blog : blogs) {
            String[] tags = blogTagMapper.findTagsByBlogId(blog.getId());
            blog.setTags(tags);
        }
        PageInfo<BlogDto> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setTotal(total);
        pageInfo.setPages((int) Math.ceil((double) total / pageSize));
        return pageInfo;
    }

    @Override
    public boolean updateBlog(BlogDto blogdto) {
        if (blogMapper.updateBlog(blogdto) > 0) {
            return true;
        }
        return false;
    }

    @Override
    public PageInfo<BlogDto> HotfindByPage(Integer page, int pageSize) {
        int offset = (page - 1) * pageSize;
        // 查询数据，根据关键词，以及页数
        List<BlogDto> blogs = blogMapper.HotfindByPage(offset, pageSize);
        // 获取总数
        int total = blogMapper.countByKeyword(null, null, null, "approved");
        // 根据博客id查询tags
        for (BlogDto blog : blogs) {
            String[] tags = blogTagMapper.findTagsByBlogId(blog.getId());
            blog.setTags(tags);
        }
        PageInfo<BlogDto> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setTotal(total);
        pageInfo.setPages((int) Math.ceil((double) total / pageSize));
        return pageInfo;
    }

    @Override
    public List<Tag> getAllTags() {
        // 调用mapper层
        return blogMapper.getAllTags();
    }

    @Override
    public Blog createBlog(BlogCreateDto blogDto, String token) {
        // 获取clamis
        try {
            Claims claims = JwtUtils.parseToken(token);
            Integer userId = Integer.parseInt(claims.get("userId").toString());
            blogDto.setAuthorId(userId);
            blogMapper.createBlog(blogDto);
            // 获取博客id
            // 插入tags到blog_tag表
            for (Integer tagId : blogDto.getTagIds()) {
                blogTagMapper.insertBlogTag(blogDto.getId(), tagId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public List<BlogDto> findByUserId(Integer id) {
        // 调用mapper层
        List<BlogDto> blogs = blogMapper.findByUserId(id);
        return blogs;
    }
    @Override
    public PageInfo<Blog> getBlogsByAreaId(Long areaId, int page, int size) {
        PageHelper.startPage(page, size);
        List<Blog> blogs = blogMapper.selectByAreaId(areaId);
//        return new PageInfo<>(blogs);
        PageInfo<Blog> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        return pageInfo;
    }


    @Override
    public PageInfo<Blog> getAllBlogs(int page, int size) {
        PageHelper.startPage(page, size);
        List<Blog> blogs = blogMapper.selectAll();
        PageInfo<Blog> pageInfo = new PageInfo<>();
        pageInfo.setList(blogs);
        return pageInfo;
    }

}
