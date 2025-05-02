package com.project.platform.dto;

import lombok.Data;

@Data
public class CurrentUserDTO {
    private Integer id;
    private String type;
    private String username;
    private String nickname;
    private String avatarUrl;
    private String tel;
    private String email;
    private String name;  // 店铺名称
    private String aptitudeImgs;  // 店铺资质图片
    /**
     * 余额
     */
    private Float balance;

}
