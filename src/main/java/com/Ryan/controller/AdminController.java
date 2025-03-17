package com.Ryan.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.system.HostInfo;
import cn.hutool.system.OsInfo;
import cn.hutool.system.SystemUtil;

import com.Ryan.dto.UserDto;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.service.*;
import com.Ryan.dto.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.Objects;


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
        PageInfo<User> pageInfo = userService.findByPage(page, pageSize, sort, keyword);
        model.addAttribute("pageInfo", pageInfo);
        return "/admin/users";
    }


    @PostMapping("/users/update")
    @ResponseBody
    public Result updateUse(UserDto userdto){

        // 查询用户信息
        User user = userService.findById(userdto.getId());
        // 判断用户是否找到
        if (Objects.isNull(user)){
            return Result.error("用户不存在");
        }
        userdto.setUsername(user.getUsername());
        BeanUtils.copyProperties(userdto, user);
        // 密码加密
        Date userCreatedTime = user.getCreatedTime();
        String password = userdto.getPassword();
        if (StrUtil.isNotBlank(password)){
            // 用户密码加密，注册时间+密码，md5加密
            user.setPassword(SecureUtil.md5(userCreatedTime + password));
        }
        if(userService.updateById(user)){
            return Result.success();
        }

        return Result.error("用户信息修改失败");
    }





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
