package com.Ryan.service.impl;

import cn.hutool.core.util.StrUtil;
import com.Ryan.dto.RegisterDto;
import com.Ryan.entity.logininfo.Logininfo;
import com.Ryan.entity.result.Result;
import com.Ryan.entity.user.User;
import com.Ryan.mapper.UserMapper;
import com.Ryan.service.UserService;
import com.Ryan.dto.PageInfo;
import com.Ryan.util.JwtUtils;
import com.Ryan.util.PasswordUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<User> findAll() {
        return userMapper.findAll();
    }

    @Override
    public Integer count() {
        // 统计列表数量
        try {
            return userMapper.count();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }


    @Override
    public PageInfo<User> findByPage(Integer page, Integer pageSize, String sort, String keyword) {
        int offset = (page - 1) * pageSize;
        List<User> users = userMapper.findByPage(keyword, sort, offset, pageSize);
        int total = userMapper.countByKeyword(keyword);
        PageInfo<User> pageInfo = new PageInfo<>();
        pageInfo.setList(users);
        pageInfo.setSort(sort);
        pageInfo.setTotal(total);
        pageInfo.setPage(page);
        pageInfo.setPageSize(pageSize);
        pageInfo.setPages((int) Math.ceil((double) total / pageSize));

        return pageInfo;
    }

    @Override
    public User findById(Integer id) {
        return userMapper.findById(id);
    }

    @Override
    public boolean updateById(User user) {
        if (user.getPassword() != null) {
            // 密码加密
            user.setPassword(PasswordUtils.encrypt(user.getCreatedTime(), user.getPassword()));
        }
        if (userMapper.updateById(user) > 0) {
            return true;
        }
        return false;
    }

    // 系统管理员登录
    @Override
    public Result<Logininfo> loginSysAdmin(User user) {
        // 1. 参数校验
        if (StrUtil.isBlank(user.getUsername()) || StrUtil.isBlank(user.getPassword())) {
            return Result.error(400, "用户名或密码不能为空");
        }

        // 2. 查询用户（修正为按用户名查询）
        User dbUser = userMapper.findByUsername(user.getUsername());
        if (dbUser == null) {
            return Result.error(404, "用户不存在");
        }

        // 3. 角色验证（使用equals比较字符串）
        if (!"sys_admin".equals(dbUser.getRole())) {
            return Result.error(403, "权限不足，非系统管理员");
        }

        // 4. 密码验证（修正参数顺序）
        if (!PasswordUtils.verify(user.getPassword(), dbUser.getCreatedTime(), dbUser.getPassword())) {
            return Result.error(401, "密码错误");
        }

        // 5. 生成Token（添加角色声明）
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", dbUser.getId());
        claims.put("username", dbUser.getUsername());
        claims.put("role", dbUser.getRole()); // 添加角色信息
        String jwt = JwtUtils.generateToken(claims);

        // 6. 返回登录信息（使用数据库用户数据）
        return Result.success(
                new Logininfo(
                        dbUser.getId(),
                        dbUser.getUsername(),
                        dbUser.getRole(),
                        jwt
                )
        );
    }

    @Override
    public Result<Logininfo> loginSysUser(User user) {
        // 1. 参数校验
        if (StrUtil.isBlank(user.getUsername()) || StrUtil.isBlank(user.getPassword())) {
            return Result.error(400, "用户名或密码不能为空");
        }

        // 2. 查询用户（修正为按用户名查询）
        User dbUser = userMapper.findByUsername(user.getUsername());
        if (dbUser == null) {
            return Result.error(404, "用户不存在");
        }


        // 3. 角色验证（使用equals比较字符串）
        if (!"sys_user".equals(dbUser.getRole())) {
            return Result.error(403, "权限不足，非系统用户");
        }
        // 4. 密码验证（修正参数顺序）
        if (!PasswordUtils.verify(user.getPassword(), dbUser.getCreatedTime(), dbUser.getPassword())) {
            return Result.error(401, "密码错误");
        }

        // 5. 生成Token（添加角色声明）
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", dbUser.getId());
        claims.put("username", dbUser.getUsername());
        claims.put("role", dbUser.getRole()); // 添加角色信息
        String jwt = JwtUtils.generateToken(claims);

        // 6. 返回登录信息（使用数据库用户数据）
        return Result.success(
                new Logininfo(
                        dbUser.getId(),
                        dbUser.getUsername(),
                        dbUser.getRole(),
                        jwt
                )
        );
    }

    @Override
    public Result<User> register(RegisterDto registerDto) {
        // 密码一致性验证
        if (!registerDto.getPassword().equals(registerDto.getConfirmPassword())) {
            return Result.error(400, "两次密码不一致"); // 明确指定错误码
        }
        // 查重验证
        if (userMapper.findByUsername(registerDto.getUsername()) != null) {
            return Result.error(409, "用户名已被占用");
        }
        if (userMapper.findByEmail(registerDto.getEmail()) != null) {
            return Result.error(409, "邮箱已被注册");
        }
        // 调用mapper层，进行注册
        User user = new User();
        user.setUsername(registerDto.getUsername());
        // 设置用户创建时间为当前
        user.setCreatedTime(new Date());
        user.setPassword(PasswordUtils.encrypt(user.getCreatedTime(), registerDto.getPassword()));
        user.setEmail(registerDto.getEmail());
        user.setRole("user");
        userMapper.insertuser(user);
        return Result.success(user);

    }

    @Override
    public Result<Logininfo> Userlogin(RegisterDto registerDto) {
        // 1. 参数校验
        if (StrUtil.isBlank(registerDto.getUsername()) || StrUtil.isBlank(registerDto.getPassword())) {
            return Result.error(400, "用户名或密码不能为空");
        }

        // 2. 查询用户（修正为按用户名查询）
        User dbUser = userMapper.findByUsername(registerDto.getUsername());
        if (dbUser == null) {
            return Result.error(404, "用户不存在");
        }

        // 3. 密码验证（修正参数顺序）
        if (!PasswordUtils.verify(registerDto.getPassword(), dbUser.getCreatedTime(), dbUser.getPassword())) {
            return Result.error(401, "密码错误");
        }

        // 4. 生成Token（添加角色声明）
        Map<String, Object> claims = new HashMap<>();
        claims.put("userId", dbUser.getId());
        claims.put("username", dbUser.getUsername());
        claims.put("role", dbUser.getRole()); // 添加角色信息
        String jwt = JwtUtils.generateToken(claims);

        // 5. 返回登录信息（使用数据库用户数据）
        return Result.success(
                new Logininfo(
                        dbUser.getId(),
                        dbUser.getUsername(),
                        dbUser.getRole(),
                        jwt
                )
        );
    }
}
