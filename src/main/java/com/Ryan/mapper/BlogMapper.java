package com.Ryan.mapper;

import com.Ryan.entity.blog.Blog;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface BlogMapper {

    @Select("SELECT COUNT(*) FROM blog")
    Integer count();

// 添加userid限制
    @Select({
            "<script>",
            "SELECT",
            "  b.id,",
            "  b.title,",
            "  b.content,",
            "  b.image,",
            "  a.name AS area_name,",
            "  u.username AS author_name,",
            "  b.likes_count,",
            "  b.favorites_count,",
            "  b.views_count,",
            "  b.created_time,",
            "  GROUP_CONCAT(DISTINCT t.tag_name) AS tags ",
            "FROM blog b",
            "  INNER JOIN user u ON b.author_id = u.id",
            "  INNER JOIN area a ON b.area_id = a.id",
            "  LEFT JOIN blog_tag bt ON b.id = bt.blog_id",
            "  LEFT JOIN tag t ON bt.tag_id = t.id",
            "<where>",
            "  <if test='keyword != null and keyword != \"\"'>",
            "    AND (u.username LIKE CONCAT('%', #{keyword}, '%')",
            "      OR t.tag_name LIKE CONCAT('%', #{keyword}, '%')",
            "      OR a.name LIKE CONCAT('%', #{keyword}, '%')",
            "      OR b.title LIKE CONCAT('%', #{keyword}, '%'))",
            "  </if>",
            "  <if test='userid != null and userid != \"\"'>",
            "    AND (u.id LIKE CONCAT('%', #{userid}, '%'))",
            "  </if>",
            "  <if test='areaid != null and areaid != \"\"'>",
            "    AND (a.id LIKE CONCAT('%', #{areaid}, '%'))",
            "  </if>",
            "</where>",
            "GROUP BY b.id, b.title, b.content, b.image, a.name, u.username,",
            "  b.likes_count, b.favorites_count, b.views_count, b.created_time",
            "ORDER BY",
            "  <choose>",
            "    <when test='sort == \"favorites\"'>b.favorites_count DESC</when>",
            "    <when test='sort == \"likes\"'>b.likes_count DESC</when>",
            "    <when test='sort == \"views\"'>b.views_count DESC</when>",
            "    <otherwise>b.created_time DESC</otherwise>",
            "  </choose>",
            "LIMIT #{offset}, #{pageSize}",
            "</script>"
    })
    @Results({
            @Result(property = "id", column = "id", id = true),
            @Result(property = "title", column = "title"),
            @Result(property = "content", column = "content"),
            @Result(property = "image", column = "image"),
            @Result(property = "area", column = "area_name"),
            @Result(property = "author", column = "author_name"),
            @Result(property = "likesCount", column = "likes_count"),
            @Result(property = "favoritesCount", column = "favorites_count"),
            @Result(property = "viewsCount", column = "views_count"),
            @Result(property = "createdTime", column = "created_time"),
            @Result(property = "tags", column = "tags")
    })
    List<Blog> findByPage(
            @Param("keyword") String keyword,
            @Param("sort") String sort,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize,
            @Param("userid") Integer userid,
            @Param("areaid") Integer areaid
    );



    @Select({
            "<script>",
            "SELECT COUNT(DISTINCT b.id)",
            "FROM blog b",
            "  INNER JOIN user u ON b.author_id = u.id",
            "  INNER JOIN area a ON b.area_id = a.id",
            "  LEFT JOIN blog_tag bt ON b.id = bt.blog_id",
            "  LEFT JOIN tag t ON bt.tag_id = t.id",
            "<where>",
            "  <if test='keyword != null and keyword != \"\"'>",
            "    (u.username LIKE CONCAT('%', #{keyword}, '%')",
            "      OR t.tag_name LIKE CONCAT('%', #{keyword}, '%')",
            "      OR a.name LIKE CONCAT('%', #{keyword}, '%')",
            "      OR b.title LIKE CONCAT('%', #{keyword}, '%')",
            "  </if>",
            "  <if test='userid != null and userid != \"\"'>",
            "    AND (u.id LIKE CONCAT('%', #{userid}, '%'))",
            "  </if>",
            "  <if test='areaid != null and areaid != \"\"'>",
            "    AND (a.id LIKE CONCAT('%', #{areaid}, '%'))",
            "  </if>",
            "</where>",
            "</script>"
    })
    Integer countByKeyword(@Param("keyword") String keyword, @Param("userid") Integer userid, @Param("areaid") Integer areaid);
}