package com.Ryan.controller;

import com.Ryan.dto.BlogDto;
import com.Ryan.dto.PageInfo;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.user.User;
import com.Ryan.service.AreaService;
import com.Ryan.service.BlogService;
import com.Ryan.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;
    @Autowired
    private AreaService areaService;
    @Autowired
    private BlogService blogService;

    // 用户登入
    @GetMapping("/index")
    public String index(Model model, @RequestParam(defaultValue = "1") Integer page) {
        // 分页查询逻辑
        PageInfo<BlogDto> pageInfo = blogService.UserfindByPage(page, 30, null);
        model.addAttribute("pageInfo", pageInfo);
        return "user/index";
    }


    // 按照热度排序
    @GetMapping("/hot")
    public String hot(Model model, @RequestParam(defaultValue = "1") Integer page) {
        // 分页查询逻辑
        PageInfo<BlogDto> pageInfo = blogService.HotfindByPage(page, 30);
        model.addAttribute("pageInfo", pageInfo);
        return "user/hot";
    }

}
