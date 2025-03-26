package com.Ryan.controller;

import com.Ryan.dto.BlogCreateDto;
import com.Ryan.dto.BlogDto;
import com.Ryan.dto.PageInfo;
import com.Ryan.dto.RegisterDto;
import com.Ryan.entity.area.Area;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.logininfo.Logininfo;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.tag.Tag;
import com.Ryan.entity.user.User;
import com.Ryan.service.AreaService;
import com.Ryan.service.BlogService;
import com.Ryan.service.UserService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
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


    // 用户注册
    /*
     *@param
     */
    @PostMapping("/register")
    public ResponseEntity<Result<User>> register(RegisterDto registerDto, HttpServletRequest request) {
        // 获取cookie
        Cookie[] cookies = request.getCookies();
        // 遍历cookies中cookie中的token
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 存在则返回首页
                if ("token".equals(cookie.getName())) {
                    // 解析
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(Result.error("您已经登录了，请勿重复注册"));
                }
            }
        }
        // 调用 Service 注册
        Result result = userService.register(registerDto);
        // 判断结果状态码
        if (result.getCode() == 409 || result.getCode() == 400) {
            return ResponseEntity.status(HttpStatus.CONFLICT)
                    .body(result);
        }
        return ResponseEntity.ok(result);
    }

    //用户登录
    @PostMapping("/login")
    public ResponseEntity<Result<Logininfo>> login(RegisterDto registerDto, HttpServletRequest request, HttpServletResponse response) {
        // 获取cookie,判断是否已经登录
        Cookie[] cookies = request.getCookies();
        // 遍历cookies中cookie中的token
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                // 存在则返回首页
                if ("token".equals(cookie.getName())) {
                    // 解析
                    return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                            .body(Result.error("您已经登录了，请勿重复登录"));
                }
            }
        }
        Result<Logininfo> result = userService.Userlogin(registerDto);
        if (result.getCode() == 200) {
            // 设置HttpOnly Cookie
            Cookie cookie = new Cookie("Token", result.getData().getToken());
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(12 * 3600); // 12小时
            response.addCookie(cookie);
        }
        if (result.getCode() != 200){
            return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                    .body(result);
        }
        return ResponseEntity.ok(result);
    }



    // 首页
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

    // 编辑页面
//    @GetMapping("/edit_page")
//    public String editpage(Tag[] tags) {
//        return "/user/editpage";
//    }

    // 上传文件
    @PostMapping("/uploadFile")
    @ResponseBody
    public String uploadFile(@RequestParam("file") MultipartFile file, HttpServletRequest request) {
        // 处理文件上传逻辑
        if (!file.isEmpty()) {
            return "上传失败";
        }
        // 从cookie中获取用户id
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("token".equals(cookie.getName())) {
                    // 解析
                    return "上传成功";
                }
            }
        }
        // 返回上传成功信息
        return "上传成功";
    }

// 在UserController中添加以下方法

    // 获取所有区域
    @GetMapping("/areas")
    @ResponseBody
    public Result<List<Area>> getAllAreas() {
        List<Area> areas = areaService.getAllAreas();
        return Result.success(areas);
    }

    // 获取所有标签
    @GetMapping("/tags")
    @ResponseBody
    public Result<List<Tag>> getAllTags() {
        List<Tag> tags = blogService.getAllTags();
        return Result.success(tags);
    }

    // 博客编辑页面
    @GetMapping("/blog_edit")
    public String blogEditPage(Model model) {
        // 调用方法
        model.addAttribute("areas", areaService.getAllAreas());
        model.addAttribute("tags", blogService.getAllTags());


        return "user/edit";
    }

    @PostMapping("/uploadImage")
    @ResponseBody
    public String uploadImage(@RequestParam("file") MultipartFile file) throws IOException {
        if (file.isEmpty()) {
            return "文件不能为空";
        }

        // 生成唯一文件名
        String fileName = System.currentTimeMillis() + "_" + file.getOriginalFilename();

        // 保存到本地目录（确保uploads目录存在）
        Path uploadPath = Paths.get("uploads");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        file.transferTo(uploadPath.resolve(fileName));

        // 返回相对路径
        return "/uploads/" + fileName;
    }

    // 创建博客
    @PostMapping("/blog")
    @ResponseBody
    public Result<Blog> createBlog(@RequestBody BlogCreateDto blogDto, HttpServletRequest request) {
        try {
            // 验证用户登录
            String token = getTokenFromRequest(request);
            if (token == null) {
                return Result.error(401, "未登录");
            }

            // 验证数据
            if (blogDto.getTitle() == null || blogDto.getTitle().isEmpty()) {
                return Result.error(400, "标题不能为空");
            }

            if (blogDto.getContent() == null || blogDto.getContent().isEmpty()) {
                return Result.error(400, "内容不能为空");
            }

            // 创建博客
            Blog blog = blogService.createBlog(blogDto, token);
            return Result.success(blog);
        } catch (Exception e) {
            return Result.error(500, "创建博客失败: " + e.getMessage());
        }
    }

    // 从请求中获取token的辅助方法
    private String getTokenFromRequest(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("Token".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }

}
