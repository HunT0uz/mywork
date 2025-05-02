package com.project.platform.interceptor;

import com.project.platform.dto.CurrentUserDTO;
import com.project.platform.utils.CurrentUserThreadLocal;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

@Component
public class AuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) {
        // 从请求头中获取token
        String token = request.getHeader("Authorization");
        if (token != null && token.startsWith("Bearer ")) {
            token = token.substring(7);
            // TODO: 这里应该添加token验证逻辑
            // 为了演示，这里简单地从session中获取用户信息
            CurrentUserDTO currentUser = (CurrentUserDTO) request.getSession().getAttribute("currentUser");
            if (currentUser != null) {
                CurrentUserThreadLocal.set(currentUser);
                return true;
            }
        }
        response.setStatus(401);
        return false;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) {
        CurrentUserThreadLocal.clear();
    }
} 