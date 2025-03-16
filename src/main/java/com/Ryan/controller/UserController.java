package com.Ryan.controller;

import com.Ryan.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

//    @RequestMapping("/users")
//    public List<User> list(){
//        System.out.println("users:");
//        return userService.findAll();
//    }

//    @RequestMapping("/list")
//    public String userlist(UserListPageDto userListPageDto){
//        Integer pageNumber = userListPageDto.getPageNumber();
//        Integer pageSize = userListPageDto.getPageSize();
//
//        IPage
//
//    }

}
