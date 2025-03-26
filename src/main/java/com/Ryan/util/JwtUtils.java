package com.Ryan.util;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtUtils {

    // 安全密钥
    private static final String SECRET_KEY = "Ryan,Admin==";
    // 令牌有效期（12小时）
    private static final long EXPIRATION_TIME = 12 * 3600 * 1000;

    /**
     * 生成JWT令牌
     *
     * @param claims 自定义声明内容
     * @return JWT令牌字符串
     */
    public static String generateToken(Map<String, Object> claims) {
        return Jwts.builder()
                .setClaims(new HashMap<>(claims)) // 复制传入的claims防止修改
                .setIssuedAt(new Date()) // 签发时间
                .setExpiration(new Date(System.currentTimeMillis() + EXPIRATION_TIME)) // 过期时间
                .signWith(SignatureAlgorithm.HS512, SECRET_KEY) // 签名算法
                .compact();
    }

    /**
     * 解析验证JWT令牌
     *
     * @param token JWT令牌字符串
     * @return 包含所有声明的Claims对象
     */
    public static Claims parseToken(String token) throws Exception {
        return Jwts.parser()
                .setSigningKey(SECRET_KEY)
                .parseClaimsJws(token)
                .getBody();
    }
}