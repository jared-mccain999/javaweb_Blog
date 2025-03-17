package com.Ryan.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PageInfo<T> {
    private List<T> list;
    private int total;
    private int page;
    private int pageSize;
    private int pages;
    private String sort;
    private String keyword;
}
