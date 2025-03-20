package com.Ryan.entity.announcement;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Announcement {
    Integer id;
    String title;
    String content;
    String image;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    Date publishTime;
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm")
    Date cancelTime;
}
