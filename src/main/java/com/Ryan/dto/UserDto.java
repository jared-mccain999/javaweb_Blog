package com.Ryan.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

@Data
public class UserDto {
    // 修改用户信息
    // 密码，邮箱，名称，角色，状态
    private Integer id;
    private String password;
    private String email;
    private String username;
    private String role;
    private Integer status;
    private String area;
}
