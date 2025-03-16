package com.Ryan.service.impl;

import com.Ryan.mapper.AreaMapper;
import com.Ryan.service.AreaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AreaServiceImpl implements AreaService {

    @Autowired
    public AreaMapper areaMapper;
    @Override
    public Integer count() {
        return areaMapper.count();
    }
}
