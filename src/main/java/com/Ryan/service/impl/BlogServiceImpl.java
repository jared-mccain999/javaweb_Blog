package com.Ryan.service.impl;

import com.Ryan.dto.BlogDto;
import com.Ryan.entity.blog.Blog;
import com.Ryan.mapper.BlogMapper;
import com.Ryan.mapper.BlogTagMapper;
import com.Ryan.service.BlogService;
import com.Ryan.dto.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;


@Service
public class BlogServiceImpl implements BlogService {

    @Autowired
    public BlogMapper blogMapper;

    @Autowired
    public BlogTagMapper blogTagMapper;

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

}
