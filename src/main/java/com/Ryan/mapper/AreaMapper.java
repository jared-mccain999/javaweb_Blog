package com.Ryan.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface AreaMapper {

    @Select("select count(*) from area")
    Integer count();
}
