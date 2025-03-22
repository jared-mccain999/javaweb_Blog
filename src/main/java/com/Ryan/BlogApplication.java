package com.Ryan;

import com.Ryan.entity.user.User;
import com.Ryan.service.UserService;
import com.Ryan.util.PasswordUtils;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.Ryan.mapper")
public class BlogApplication {
    @Autowired
    UserService userService;

    public static void main(String[] args) {
        SpringApplication.run(BlogApplication.class, args);
    }

    // password encryption
    User user = new User(0, "Ryan", "https://avatars.githubusercontent.com/u/10236901?v=4", "123456", "ryan@gmail.com", 1, 0, 1, 0, "user", null);

    public void upudte() {
        user.setPassword(PasswordUtils.encrypt(user.getCreatedTime(), user.getPassword()));
        userService.updateById(user);
    }

}

