package com.Ryan.entity.announcement;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Date;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Announcement {
    Integer id;
    String title;
    String content;
    String image;
    Date publishTime;
    Date cancelTime;
}
