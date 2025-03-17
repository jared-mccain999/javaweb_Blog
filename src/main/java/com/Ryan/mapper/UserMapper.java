package com.Ryan.mapper;

import com.Ryan.entity.user.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import java.util.List;


@Mapper
public interface UserMapper {

    @Select("select id, username, image, email, role, created_time from user")
    List<User> findAll();

    @Select("select count(*) from user")
    Integer count();

    @Select({
            "<script>",
            "SELECT id, username, image, email, role, created_time, blog_count, collection_count, status",
            "FROM user ",
            "<where>",
            "  <if test='keyword != null and keyword != \"\"'>",
            "    username LIKE CONCAT('%', #{keyword}, '%')",
            "  </if>",
            "</where>",
            "ORDER BY ",
            "  <choose>",
            "    <when test=\"sort == 'blog_count'\">blog_count DESC</when>",          // 添加 DESC
            "    <when test=\"sort == 'collection_count'\">collection_count DESC</when>", // 添加 DESC
            "    <otherwise>id</otherwise>",  // 默认按 id 升序（保持原逻辑）
            "  </choose>",
            "LIMIT #{pageSize} OFFSET #{offset}",
            "</script>"
    })
    List<User> findByPage(
            @Param("keyword") String keyword,
            @Param("sort") String sort,
            @Param("offset") int offset,
            @Param("pageSize") int pageSize);

    @Select({
            "<script>",
            "SELECT COUNT(*) FROM user",
            "<where>",
            "  <if test='keyword != null and keyword != \"\"'>",
            "    (username LIKE CONCAT('%', #{keyword}, '%'))",
            "  </if>",
            "</where>",
            "</script>"
    })
    Integer countByKeyword(@Param("keyword") String keyword);


    @Select("select id, username, image, email, role, password, created_time, blog_count, collection_count, status from user where id = #{id}")
    User findById(Integer id);

    // 更新用户信息
    @Update("update user set username = #{username}, password = #{password}, role = #{role}, status = #{status} where id = #{id}")
    int updateById(User user);
}
