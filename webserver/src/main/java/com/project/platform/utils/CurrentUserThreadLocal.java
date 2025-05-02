package com.project.platform.utils;

import com.project.platform.dto.CurrentUserDTO;

/**
 * 当前用户线程本地变量
 */
public class CurrentUserThreadLocal {

    /**
     * 线程变量隔离
     */
    private static final ThreadLocal<CurrentUserDTO> threadLocal = new ThreadLocal<>();

    /**
     * 清除用户信息
     */
    public static void clear() {
        threadLocal.remove();
    }

    /**
     * 存储用户信息
     */
    public static void set(CurrentUserDTO currentUser) {
        threadLocal.set(currentUser);
    }

    /**
     * 获取当前用户信息
     */
    public static CurrentUserDTO getCurrentUser() {
        return threadLocal.get();
    }
}
