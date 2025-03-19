package com.Ryan.mapper;

import com.Ryan.entity.area.Area;
import com.Ryan.vo.AreaVo;
import org.apache.ibatis.annotations.*;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.List;

@Mapper
public interface AreaMapper {

    @Select("select count(*) from area")
    Integer count();


    @Select("select id, name, (select count(*) from blog where area_id = a.id) as blogs_count from area a")
    List<AreaVo> areasList();

    @Select("select count(*) from area where name = #{name}")
    int countByName(String name);


    @Insert("insert into area(name) values(#{name})")
    void createArea(Area area);

    @Update("update area set name = #{name} where id = #{id}")
    void updateAreaById(Area area);

    @Delete("delete from area where id = #{id}")
    void deleteAreaById(Integer id);

    @Select("select id from area where name = #{name}")
    Integer getIdByName(String name);

    @Select("select name from area where id = #{id}")
    String getNameById(Integer id);
}
