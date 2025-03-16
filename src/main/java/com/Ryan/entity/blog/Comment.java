package com.Ryan.entity.blog;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
@Data
@AllArgsConstructor
@NoArgsConstructor
//@Table(name = "comment")
public class Comment {
    private Integer id;
    private Integer blog_id;
    private Integer user_id;
    private String content;
    private Integer likeCount = 0;
    private Integer parentId = 0;
    private LocalDateTime commentTime = LocalDateTime.now();
}
