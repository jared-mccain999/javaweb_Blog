package com.Ryan.service;

import com.Ryan.dto.PageInfo;
import com.Ryan.entity.announcement.Announcement;
import org.springframework.stereotype.Service;


public interface AnnouncementService {
    PageInfo<Announcement> findByPage(Integer page, Integer pageSize, String keyword);
}
