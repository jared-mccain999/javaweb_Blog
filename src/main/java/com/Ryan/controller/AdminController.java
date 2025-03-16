package com.Ryan.controller;

import cn.hutool.system.HostInfo;
import cn.hutool.system.OsInfo;
import cn.hutool.system.SystemUtil;

import com.Ryan.entity.area.Area;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.user.User;
import com.Ryan.service.*;
import com.Ryan.util.page.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AreaService areaService;
    @Autowired
    private UserService userService;
    @Autowired
    private BlogService blogService;
    @Autowired
    private TagService tagService;
    @Autowired
    private BlogTagService blogTagService;


    // 管理者首页
    @GetMapping("/index")
    public String adminIndex(Model model) {
        //系统信息
        OsInfo osInfo = SystemUtil.getOsInfo();
        HostInfo hostInfo = SystemUtil.getHostInfo();
        model.addAttribute("osName", osInfo.getName());
        model.addAttribute("hostAddress", hostInfo.getAddress());
        //用户数量
        model.addAttribute("userCount", userService.count());
        //文章数量
        model.addAttribute("blogCount", blogService.count());
        model.addAttribute("tagCount", tagService.count());
        model.addAttribute("areaCount", areaService.count());
        return "/admin/index";
    }

    //管理用户页面
    @GetMapping("/users")
    public String users(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "") String keyword,
            Model model) {
        System.out.println(sort);
        System.out.println("controller");
        PageInfo<User> pageInfo = userService.findByPage(page, pageSize, sort, keyword);
        System.out.print(pageInfo.getList().toString());
        model.addAttribute("pageInfo", pageInfo);
        return "/admin/users";
    }

    // 文章页管理
//    @GetMapping("/blogs")
//    public String blogs(
//            @RequestParam(defaultValue = "1") Integer page,
//            @RequestParam(defaultValue = "10") Integer pageSize,
//            @RequestParam(defaultValue = "id") String sort,
//            @RequestParam(defaultValue = "") String keyword,
//            Model model) {
//        PageInfo<Blog> pageInfo = blogService.findByPage(page, pageSize, sort, keyword);
//        model.addAttribute("pageInfo", pageInfo);
//        return "/admin/blogs";
//    }
    @GetMapping("/blogs")
    public String blogs(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "") String keyword,
            Model model) {
        PageInfo<Blog> pageInfo = blogService.findByPage(page, pageSize, sort, keyword);
        model.addAttribute("pageInfo", pageInfo);
//        return pageInfo.toString();
        return "/admin/blogs";
    }

//    @PostMapping("/users/delete/{id}")
//    public CommonR



}
