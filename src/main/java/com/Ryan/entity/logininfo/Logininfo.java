package com.Ryan.entity.logininfo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Logininfo {
    private Integer id;
    private String username;
    private String role;
    private String token;
}
