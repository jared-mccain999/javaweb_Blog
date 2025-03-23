package com.Ryan.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface BlogTagMapper {
    @Select("SELECT t.tag_name FROM blog_tag bt INNER JOIN tag t ON bt.tag_id = t.id WHERE bt.blog_id = #{id}")
    String[] findTagsByBlogId(Integer id);
}
