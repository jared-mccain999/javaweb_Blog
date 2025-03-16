package com.Ryan.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface TagMapper {

    @Select("select count(*) from tag")
    Integer count();
}
