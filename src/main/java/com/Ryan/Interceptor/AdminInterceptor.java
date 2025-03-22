package com.Ryan.Interceptor;

import com.Ryan.util.AdminJwtUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AdminInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = request.getHeader("token");

        // Token 不存在直接返回 401
        if (token == null || token.isEmpty()) {
            response.setStatus(401);
            response.getWriter().write("{\"code\":401, \"message\":\"未授权，请登录\"}");
            return false;
        }

        // Token 校验失败返回 401
        try {
            AdminJwtUtils.parseToken(token);
        } catch (Exception e) {
            response.setStatus(401);
            response.getWriter().write("{\"code\":401, \"message\":\"令牌无效\"}");
            return false;
        }

        return true;
    }
}