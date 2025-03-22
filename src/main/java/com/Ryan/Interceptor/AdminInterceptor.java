package com.Ryan.Interceptor;

import com.Ryan.util.AdminJwtUtils;
import io.jsonwebtoken.Claims;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.io.IOException;


@Component
public class AdminInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 从Cookie或Header中获取token
        String token = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("Admin-Token".equals(cookie.getName())) {
                    token = cookie.getValue();
                    break;
                }
            }
        }
        if (token == null) {
            token = request.getHeader("Authorization");
            if (token != null && token.startsWith("Bearer ")) {
                token = token.substring(7);
            }
        }

        if (token == null) {
            sendRedirect(response, request);
            return false;
        }

        try {
            Claims claims = AdminJwtUtils.parseToken(token);
            // 验证角色是否为管理员
            if (!"sys_admin".equals(claims.get("role"))) {
                sendRedirect(response, request);
                return false;
            }
            // 将用户信息存入请求
            request.setAttribute("adminId", claims.get("userId"));
            return true;
        } catch (Exception e) {
            sendRedirect(response, request);
            return false;
        }
    }

    private void sendRedirect(HttpServletResponse response, HttpServletRequest request) throws IOException {
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.sendError(HttpStatus.UNAUTHORIZED.value());
        } else {
            response.sendRedirect("/admin/login");
        }
    }
}