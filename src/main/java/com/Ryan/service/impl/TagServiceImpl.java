package com.Ryan.service.impl;

import com.Ryan.mapper.TagMapper;
import com.Ryan.service.TagService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TagServiceImpl implements TagService {


    @Autowired
    public TagMapper tagMapper;
    @Override
    public Object count() {
        return tagMapper.count();
    }
}
