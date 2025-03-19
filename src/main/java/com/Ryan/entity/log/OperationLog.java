package com.Ryan.entity.log;


import com.Ryan.entity.enums.TargetType;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Component
public class OperationLog {
    private Integer id;
    private Integer adminId;
    private String action;
    private Integer targetId;//用户id
    private String targetType;
    private LocalDateTime timestamp = LocalDateTime.now();
}

