package com.Ryan.controller;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import cn.hutool.system.HostInfo;
import cn.hutool.system.OsInfo;
import cn.hutool.system.SystemUtil;

import com.Ryan.dto.UserDto;
import com.Ryan.entity.area.Area;
import com.Ryan.entity.blog.Blog;
import com.Ryan.entity.log.OperationLog;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.service.*;
import com.Ryan.dto.PageInfo;
import com.Ryan.vo.AreaVo;
import jakarta.validation.Valid;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
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


    //事件绑定
    @Transactional
    @PostMapping("/users/update")
    @ResponseBody
    public Result updateUse(@Valid UserDto userdto) {

        // 查询用户信息
        User user = userService.findById(userdto.getId());
        // 判断用户是否找到
        if (Objects.isNull(user)) {
            return Result.error("用户不存在");
        }
        userdto.setUsername(user.getUsername());
        BeanUtils.copyProperties(userdto, user);
        // 密码加密
        Date userCreatedTime = user.getCreatedTime();
        String password = userdto.getPassword();
        if (StrUtil.isNotBlank(password)) {
            // 用户密码加密，注册时间+密码，md5加密
            user.setPassword(SecureUtil.md5(userCreatedTime + password));
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


    @GetMapping("/blogs")
    public String blogs(
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer pageSize,
            @RequestParam(defaultValue = "id") String sort,
            @RequestParam(defaultValue = "") String keyword,
            @RequestParam(defaultValue = "") Integer userId,
            @RequestParam(defaultValue = "") Integer areaId,
            Model model) {
        // 检查用户id是否为空,不为空，按用户id查询

        PageInfo<Blog> pageInfo = blogService.findByPage(page, pageSize, sort, keyword, userId,areaId);
        model.addAttribute("pageInfo", pageInfo);

        return "/admin/blogs";
    }

    // 领域管理
    @GetMapping("/areas")
    public String areas(Model model) {
        List<AreaVo> areasList = areaService.areasList();
        model.addAttribute("areasList", areasList);
        return "/admin/areas";
    }

    // ====================== AdminController.java ======================
// 区域删除（修正重定向并添加日志）
    @Transactional
    @GetMapping("/areas/delete")
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
}
