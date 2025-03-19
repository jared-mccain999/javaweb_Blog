package com.Ryan.service.impl;

import com.Ryan.dto.PageInfo;
import com.Ryan.entity.announcement.Announcement;
import com.Ryan.entity.user.User;
import com.Ryan.mapper.AnnouncementMapper;
import com.Ryan.service.AnnouncementService;
import com.github.pagehelper.PageHelper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class AnnouncementServiceImpl implements AnnouncementService {


    @Autowired
    private AnnouncementMapper announcementMapper;


    @Override
    public PageInfo<Announcement> findByPage(Integer page, Integer pageSize, String keyword) {

        int offset = (page - 1) * pageSize;
        List<Announcement> announcements = announcementMapper.findByPage(keyword, offset, pageSize);
        int total = announcementMapper.countByKeyword(keyword);
        PageInfo<Announcement> pageInfo = new PageInfo<>();
        pageInfo.setList(announcements);
        pageInfo.setTotal(total);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setPages((int) Math.ceil((double)total / pageSize));

        return pageInfo;
    }
}
