package com.Ryan.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.system.HostInfo;
import cn.hutool.system.OsInfo;
import cn.hutool.system.SystemUtil;

import com.Ryan.dto.BlogDto;
import com.Ryan.dto.UserDto;
import com.Ryan.entity.announcement.Announcement;
import com.Ryan.entity.area.Area;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.log.OperationLog;
import com.Ryan.entity.logininfo.Logininfo;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.service.*;
import com.Ryan.dto.PageInfo;
import com.Ryan.util.PasswordUtils;
import com.Ryan.vo.AreaVo;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;
import org.apache.tomcat.util.net.openssl.ciphers.Authentication;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.HttpServletBean;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
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
    @Autowired
    private OperationLogService operationLogService;
    @Autowired
    private AnnouncementService announcementService;


    /*
     * 管理员登入
     */


    @GetMapping("/login")
    public String loginPage(HttpServletRequest request, Model model) {
        // 判断是否为AJAX请求
        boolean isXhr = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        model.addAttribute("xhr", isXhr);
        return "admin/login";
    }

    @PostMapping("/login/post")
    @ResponseBody
    public Result<Logininfo> login(@RequestBody @Valid User user, HttpServletResponse response) {
        Result<Logininfo> result = userService.loginSysAdmin(user);
        if (result.getCode() == 200) {
            // 设置HttpOnly Cookie
            Cookie cookie = new Cookie("Admin-Token", result.getData().getToken());
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setMaxAge(12 * 3600); // 12小时
            response.addCookie(cookie);
        }
        return result;
    }

    // 退出
    @PostMapping("/logout")
    public String logout(HttpServletRequest request) {
        return "redirect:/admin/login";
    }


    // 管理者首页,展示基本信息
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


    //用户信息修改
    @Transactional
    @PostMapping("/users/update")
    @ResponseBody
    public Result updateUse(@Valid UserDto userdto) {
        // 查找用户id
        User user = userService.findById(userdto.getId());
        if (Objects.isNull(user)) {
            return Result.error("用户不存在");
        }

        userdto.setUsername(user.getUsername());
        BeanUtils.copyProperties(userdto, user);

        String password = userdto.getPassword();
        if (StrUtil.isNotBlank(password)) {
            // 使用工具类加密
            user.setPassword(PasswordUtils.encrypt(user.getCreatedTime(), password));
        }
        if (userService.updateById(user)) {
            // 添加日志
            OperationLog operationLog = new OperationLog(null, 0, "修改用户信息", user.getId(), "user", LocalDateTime.now());
            int i = operationLogService.InsertOperationLog(operationLog);
            if (i > 0) {
                return Result.success();
            }
            return Result.error("操作日志更新失败");
        }
        return Result.error("用户信息修改失败");
    }


    //管理文章页面
    @GetMapping("/blogs")
    public String blogs(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "") Integer userId,
            @RequestParam(defaultValue = "") Integer areaId,
            Model model) {
        // 获取所有区域
        List<AreaVo> areasList = areaService.areasList();
        PageInfo<Blog> pageInfo = blogService.findByPage(page, pageSize, sort, keyword, userId, areaId);
        model.addAttribute("pageInfo", pageInfo);
        model.addAttribute("areas", areasList);

        return "/admin/blogs";
    }

    // 修改博客
    @PostMapping("/blogs/update")
    public String updateBlog(@Valid BlogDto blogdto) {
        // 根据id修改其的发布状态以及区域，调用Service层
        if (blogService.updateBlog(blogdto)) {
            // 添加日志
            OperationLog operationLog = new OperationLog(null, 0, "修改博客信息", blogdto.getId(), "blog", LocalDateTime.now());
            int i = operationLogService.InsertOperationLog(operationLog);
            if (i > 0) {
                return "redirect:/admin/blogs";
            }
            return "操作日志更新失败";
        }
        return "修改失败";
    }

    // 领域管理
    @GetMapping("/areas")
    public String areas(Model model) {
        List<AreaVo> areasList = areaService.areasList();
        model.addAttribute("areasList", areasList);
        return "/admin/areas";
    }


    // 区域删除（修正重定向并添加日志）
    @Transactional
    @DeleteMapping("/areas/delete")
    public String deleteArea(@RequestParam Integer id, RedirectAttributes attributes) {
        try {
            String name = areaService.getNameById(id);
            areaService.deleteAreaById(id);
            // 添加操作日志
            String logMessage = "删除区域: " + name;
            OperationLog operationLog = new OperationLog(
                    null,
                    0,
                    logMessage,
                    id,
                    "area",
                    LocalDateTime.now()
            );
            operationLogService.InsertOperationLog(operationLog);
            return "redirect:/admin/areas"; // 修正重定向路径
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "删除失败：" + e.getMessage());
            return "redirect:/admin/areas";
        }
    }

    // 区域创建
    @Transactional
    @PostMapping("/areas/create")
    public String createArea(@ModelAttribute Area area, RedirectAttributes attributes) {
        try {
            if (areaService.existsByName(area.getName())) {
                attributes.addFlashAttribute("error", "区域名称已存在");
                return "redirect:/admin/areas";
            }
            areaService.createArea(area);
            //获取新建区域id
            Integer id = areaService.getIdByName(area.getName());
            // 添加操作日志
            OperationLog operationLog = new OperationLog(
                    null,
                    0,
                    "创建区域",
                    id,
                    "area",
                    LocalDateTime.now()
            );
            operationLogService.InsertOperationLog(operationLog);
            return "redirect:/admin/areas";
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "创建失败：" + e.getMessage());
            return "redirect:/admin/areas";
        }
    }

    // 区域更新（添加日志）
    @Transactional
    @PostMapping("/areas/update")
    public String updateArea(@ModelAttribute Area area, RedirectAttributes attributes) {
        try {
            if (areaService.existsByName(area.getName())) {
                attributes.addFlashAttribute("error", "区域名称已存在");
                return "redirect:/admin/areas";
            }
            areaService.updateAreaById(area);
            // 添加操作日志
            OperationLog operationLog = new OperationLog(
                    null,
                    0,
                    "更新区域",
                    area.getId(),
                    "area",
                    LocalDateTime.now()
            );
            operationLogService.InsertOperationLog(operationLog);
            return "redirect:/admin/areas";
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "更新失败：" + e.getMessage());
            return "redirect:/admin/areas";
        }
    }

    // 管理页面，公告管理
    @GetMapping("/announcements")
    public String announcements(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "") String keyword,
            Model model) {
        PageInfo<Announcement> pageInfo = announcementService.findByPage(page, pageSize, keyword);
        model.addAttribute("pageInfo", pageInfo);
        return "/admin/announcements";
    }

    // 修改公告信息，前端传入id等信息
    @PostMapping("/announcements/update")
    public String updateAnnouncement(
            @ModelAttribute Announcement announcement,
            RedirectAttributes attributes
    ) {
        try {
            if (announcementService.updateAnnouncement(announcement)) {
                attributes.addFlashAttribute("success", "公告修改成功");
                // 添加操作日志
                OperationLog operationLog = new OperationLog(
                        null,
                        0,
                        "更新公告",
                        announcement.getId(),
                        "announcement",
                        LocalDateTime.now()
                );
                operationLogService.InsertOperationLog(operationLog);
                return "redirect:/admin/announcements";
            } else {
                attributes.addFlashAttribute("error", "公告修改失败");
                return "redirect:/admin/announcements";
            }
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "公告修改失败：" + e.getMessage());
            return "redirect:/admin/announcements";
        }

    }

    // 删除公告
    @GetMapping("/announcements/delete")
    public String deleteAnnouncement(@RequestParam Integer id, RedirectAttributes attributes) {
        try {
            if (announcementService.deleteAnnouncement(id)) {
                attributes.addFlashAttribute("success", "公告删除成功");
                // 添加操作日志
                OperationLog operationLog = new OperationLog(
                        null,
                        0,
                        "删除公告",
                        id,
                        "announcement",
                        LocalDateTime.now()
                );
                operationLogService.InsertOperationLog(operationLog);
                return "redirect:/admin/announcements";
            } else {
                attributes.addFlashAttribute("error", "公告删除失败");
                return "redirect:/admin/announcements";
            }
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "公告删除失败：" + e.getMessage());
            return "redirect:/admin/announcements";
        }
    }

    @PostMapping("/announcements/create")
    public String createAnnouncement(@ModelAttribute Announcement announcement, RedirectAttributes attributes) {
        try {
            if (announcementService.createAnnouncement(announcement)) {
                attributes.addFlashAttribute("success", "公告创建成功");
                // 添加操作日志
                OperationLog operationLog = new OperationLog(
                        null,
                        0,
                        "创建公告",
                        announcement.getId(),
                        "announcement",
                        LocalDateTime.now()
                );
            }
        } catch (Exception e) {
            attributes.addFlashAttribute("error", "公告创建失败：" + e.getMessage());
        }
        return "redirect:/admin/announcements";
    }

}



