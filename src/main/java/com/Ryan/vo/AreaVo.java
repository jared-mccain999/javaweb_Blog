package com.Ryan.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


@Data
@AllArgsConstructor
@NoArgsConstructor
public class AreaVo {
    private Integer id;
    private String name;// 领域名
    private Integer blogsCount;// 该领域下的博客数量
}
