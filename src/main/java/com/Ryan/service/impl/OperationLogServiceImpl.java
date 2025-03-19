package com.Ryan.service.impl;

import com.Ryan.entity.log.OperationLog;
import com.Ryan.mapper.OperationLogMapper;
import com.Ryan.service.OperationLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class OperationLogServiceImpl implements OperationLogService {

    @Autowired
    private OperationLogMapper operationLogMapper;

    @Override
    public int InsertOperationLog(OperationLog operationLog) {
        return operationLogMapper.insert(operationLog);
    }
}
