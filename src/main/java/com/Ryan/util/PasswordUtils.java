package com.Ryan.util;

import cn.hutool.core.util.StrUtil;
import cn.hutool.crypto.SecureUtil;
import java.util.Date;

/**
 * 密码加密验证工具类
 */
public class PasswordUtils {

    /**
     * 密码加密
     * @param userCreatedTime 用户创建时间
     * @param rawPassword 原始密码
     * @return 加密后的密码
     * @throws IllegalArgumentException 参数无效时抛出
     */
    public static String encrypt(Date userCreatedTime, String rawPassword) {
        if (userCreatedTime == null) {
            throw new IllegalArgumentException("User creation time cannot be null");
        }
        if (StrUtil.isBlank(rawPassword)) {
            throw new IllegalArgumentException("Password cannot be empty");
        }
        
        return SecureUtil.md5(userCreatedTime + rawPassword);
    }

    /**
     * 密码验证
     * @param inputPassword 用户输入的密码
     * @param userCreatedTime 用户创建时间
     * @param storedHash 存储的加密密码
     * @return 验证结果
     */
    public static boolean verify(String inputPassword, Date userCreatedTime, String storedHash) {
        if (StrUtil.hasBlank(inputPassword, storedHash) || userCreatedTime == null) {
            return false;
        }
        
        String computedHash = encrypt(userCreatedTime, inputPassword);
        return computedHash.equalsIgnoreCase(storedHash);
    }

    /**
     * @param storedHash 存储的密码hash
     * @return 是否需要重新加密
     */
    public static boolean needUpgrade(String storedHash) {
        // 当前版本使用MD5，后续可扩展其他算法判断
        return storedHash != null && storedHash.length() == 32;
    }
}