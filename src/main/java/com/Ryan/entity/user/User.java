package com.Ryan.entity.user;


import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
    private Integer id;
    private String username;
    private String image;
    private String password;
    private String email;
    private Integer areaId = 0;
    private Integer blogCount = 0;
    private Integer status = 1;
    private Integer collectionCount = 0;
    private String role = "user";
    private Data createdTime;
}

