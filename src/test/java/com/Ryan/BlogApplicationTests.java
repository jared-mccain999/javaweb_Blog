package com.Ryan;

import com.Ryan.entity.user.User;
import com.Ryan.service.UserService;
import com.Ryan.util.PasswordUtils;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class BlogApplicationTests {

	@Autowired
	UserService userService;

	@Test
	void contextLoads() {
		//
		// password encryption
		User user = new User(1, "洪锐", "https://avatars.githubusercontent.com/u/10236901?v=4", "123456", "ryan@gmail.com", 1, 0, 1, 0, "sys_admin", null);
		User u = userService.findById(0);
		user.setCreatedTime(u.getCreatedTime());
		userService.updateById(user);
	}

}
