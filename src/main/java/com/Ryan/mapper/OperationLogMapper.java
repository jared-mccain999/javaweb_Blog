package com.Ryan.mapper;

import com.Ryan.entity.log.OperationLog;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface OperationLogMapper {

    @Insert("INSERT INTO operation_log (admin_id, action, target_id, target_type,timestamp) VALUES (#{adminId}, #{action}, #{targetId}, #{targetType},#{timestamp})")
    int insert(OperationLog operationLog);



}
