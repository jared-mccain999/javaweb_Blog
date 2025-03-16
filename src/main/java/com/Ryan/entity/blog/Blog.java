package com.Ryan.entity.blog;


import com.Ryan.entity.enums.Status;
import lombok.*;
import java.time.LocalDateTime;
import java.util.Date;


@Data
@AllArgsConstructor
@NoArgsConstructor
//@Table(name = "blog")
public class Blog {
    private Integer id;
    private String title;
    private String content;
    private String image;
    private Integer areaId;
    private Status status = Status.PENDING;
    private Integer authorId;
    private Integer likesCount = 0;
    private Integer favoritesCount = 0;
    private Integer viewsCount = 0;
    private Date scheduledTime;//定时发布时间
//    private LocalDateTime createdTime = LocalDateTime.now();
    private Date createdTime = Date.from(LocalDateTime.now().plusDays(1).atZone(java.time.ZoneId.systemDefault()).toInstant());
    private String area;
    private String author;
    private String tags;
}
