package com.Ryan.mapper;

import com.Ryan.dto.PageInfo;
import com.Ryan.entity.announcement.Announcement;
import org.apache.ibatis.annotations.*;

import java.util.List;

@Mapper
public interface AnnouncementMapper {

    // 添加判断
    @Select({"<script>",
            "SELECT id, title, content, publish_time, cancel_time, image FROM announcement",
            "<where>",
            "   <if test='keyword != null and keyword != \"\"'>",
            "       title LIKE CONCAT('%', #{keyword}, '%')",
            "   </if>",
            "</where>",
            "ORDER BY cancel_time DESC",
            "LIMIT #{offset}, #{pageSize}",
            "</script>"})
    List<Announcement> findByPage(String keyword, int offset, Integer pageSize);

    @Select("SELECT COUNT(*) FROM announcement WHERE title LIKE CONCAT('%', #{keyword}, '%')")
    int countByKeyword(String keyword);

    @Update("UPDATE announcement SET title = #{title}, content = #{content}, publish_time = #{publishTime}, cancel_time = #{cancelTime} WHERE id = #{id}")
    int updateAnnouncementById(Announcement announcement);

    @Delete("DELETE FROM announcement WHERE id = #{id}")
    int deleteAnnouncementById(Integer id);

    @Insert("INSERT INTO announcement (title, content, publish_time, cancel_time) VALUES (#{title}, #{content}, #{publishTime}, #{cancelTime})")
    int createAnnouncement(Announcement announcement);
}
