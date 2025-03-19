package com.Ryan.mapper;

import com.Ryan.entity.log.OperationLog;
import com.Ryan.entity.result.Result;
import org.apache.ibatis.annotations.Insert;

public interface OperationLogMapper {
//    id INT AUTO_INCREMENT PRIMARY KEY COMMENT '日志ID',
//    admin_id INT NOT NULL COMMENT '管理员ID',
//    action VARCHAR(255) NOT NULL COMMENT '操作内容',
//    target_id INT NOT NULL COMMENT '操作对象ID',
//    target_type ENUM('user', 'blog', 'comment', 'tag', 'other') NOT NULL COMMENT '操作对象类型',
//    timestamp DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '操作时间',
//    FOREIGN KEY (admin_id) REFERENCES user(id) ON DELETE CASCADE
    @Insert("INSERT INTO operation_log (admin_id, action, target_id, target_type) VALUES (#{adminId}, #{action}, #{targetId}, #{targetType})")
    int insert(OperationLog operationLog);



}
