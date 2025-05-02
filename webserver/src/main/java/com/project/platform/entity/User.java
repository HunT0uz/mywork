package com.project.platform.entity;

import lombok.Getter;

import java.time.LocalDateTime;
public class User {
    //id
    @Getter
    private Integer id;
    //uername
    @Getter
    private String username;
    //password
    @Getter
    private String password;
    //nickname
    @Getter
    private String nickname;
    //头像
    @Getter
    private String avatarUrl;
    //电话
    @Getter
    private String tel;
    //邮箱
    @Getter
    private String email;
    //状态
    @Getter
    private String status;
    //余额
    @Getter
    private Float balance;
    //创建时间
    @Getter
    private LocalDateTime createTime;

    public void setId(Integer id) {
        this.id = id;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public void setTel(String tel) {
        this.tel = tel;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setBalance(Float balance) {
        this.balance = balance;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }
}
