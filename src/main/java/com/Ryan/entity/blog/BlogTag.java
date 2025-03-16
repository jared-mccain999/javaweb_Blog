package com.Ryan.entity.blog;

import com.Ryan.entity.tag.Tag;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;

import javax.persistence.*;

@Component
@Getter
@Setter
@Data
//@Table(name = "blog_tag")
public class BlogTag {
    private Integer id;
    private Integer blog_id;
    private Integer tag_id;
}

