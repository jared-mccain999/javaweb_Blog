// BlogCreateDto.java
package com.Ryan.dto;

import lombok.Data;
import java.util.List;

@Data
public class BlogCreateDto {
    private Integer id;
    private String title;
    private String content;
    private String image;
    private Integer areaId;
    private List<Integer> tagIds;
    private Integer authorId;// authorId 将从token中获取，不需要前端传递
}