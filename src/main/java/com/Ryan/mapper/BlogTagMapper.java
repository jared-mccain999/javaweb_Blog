package com.Ryan.mapper;

import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface BlogTagMapper {
    @Select("SELECT t.tag_name FROM blog_tag bt INNER JOIN tag t ON bt.tag_id = t.id WHERE bt.blog_id = #{id}")
    String[] findTagsByBlogId(Integer id);

    // 插入博客blog_id，tag_id
    @Insert("insert into blog_tag(blog_id, tag_id) values(#{id}, #{tagId})")
    void insertBlogTag(Integer id, Integer tagId);
}
