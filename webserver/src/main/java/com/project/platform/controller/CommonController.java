package com.project.platform.controller;

import com.alibaba.fastjson2.JSONObject;
import com.project.platform.dto.CurrentUserDTO;
import com.project.platform.dto.LoginDTO;
import com.project.platform.dto.RetrievePasswordDTO;
import com.project.platform.dto.UpdatePasswordDTO;
import com.project.platform.exception.CustomException;
import com.project.platform.service.AdminService;
import com.project.platform.service.CommonService;
import com.project.platform.service.ShopService;
import com.project.platform.service.UserService;
import com.project.platform.utils.CurrentUserThreadLocal;
import com.project.platform.utils.JwtUtils;
import com.project.platform.vo.ResponseVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

/**
 * 通用控制器
 */
@Tag(name = "通用接口", description = "包含登录、注册、找回密码等通用功能")
@RestController
@RequestMapping("/common")
public class CommonController {

    @Resource
    private AdminService adminService;

    @Resource
    private UserService userService;

    @Resource
    private ShopService shopService;
    
    /**
     * 登录
     *
     * @param loginDTO 登录参数
     * @return token
     */
    @Operation(summary = "用户登录", description = "根据用户名、密码和用户类型进行登录，返回JWT token")
    @PostMapping("login")
    public ResponseVO<String> login(@RequestBody LoginDTO loginDTO) {
        CommonService commonService = getCommonService(loginDTO.getType());
        CurrentUserDTO currentUserDTO = commonService.login(loginDTO.getUsername(), loginDTO.getPassword());
        currentUserDTO.setType(loginDTO.getType());
        String token = JwtUtils.generateToken(currentUserDTO);
        return ResponseVO.ok(token);
    }

    /**
     * 注册
     *
     * @param data 注册参数
     * @return 注册结果
     */
    @Operation(summary = "用户注册", description = "根据用户类型进行注册，支持管理员、普通用户和店铺注册")
    @PutMapping("register")
    public ResponseVO register(@RequestBody JSONObject data) {
        String type = data.getString("type");
        CommonService commonService = getCommonService(type);
        commonService.register(data);
        return ResponseVO.ok();
    }

    /**
     * 修改当前用户信息
     *
     * @param currentUserDTO 用户信息
     * @return 修改结果
     */
    @Operation(summary = "修改当前用户信息", description = "修改当前登录用户的基本信息")
    @PostMapping("updateCurrentUser")
    public ResponseVO updateCurrentUser(@RequestBody CurrentUserDTO currentUserDTO) {
        CommonService commonService = getCommonService(CurrentUserThreadLocal.getCurrentUser().getType());
        commonService.updateCurrentUserInfo(currentUserDTO);
        return ResponseVO.ok();
    }

    /**
     * 修改密码
     *
     * @param updatePassword 密码修改参数
     * @return 修改结果
     */
    @Operation(summary = "修改密码", description = "修改当前登录用户的密码")
    @PostMapping("updatePassword")
    public ResponseVO updatePassword(@RequestBody UpdatePasswordDTO updatePassword) {
        CommonService commonService = getCommonService(CurrentUserThreadLocal.getCurrentUser().getType());
        commonService.updateCurrentUserPassword(updatePassword);
        return ResponseVO.ok();
    }

    /**
     * 忘记密码
     * @param retrievePasswordDTO 找回密码参数
     * @return 找回结果
     */
    @Operation(summary = "找回密码", description = "通过手机验证码找回密码")
    @PostMapping("retrievePassword")
    public ResponseVO retrievePassword(@RequestBody RetrievePasswordDTO retrievePasswordDTO) {
        CommonService commonService = getCommonService(retrievePasswordDTO.getType());
        commonService.retrievePassword(retrievePasswordDTO);
        return ResponseVO.ok();
    }

    /**
     * 重置密码
     *
     * @param type 用户类型
     * @param id 用户ID
     * @return 重置结果
     */
    @Operation(summary = "重置密码", description = "管理员重置指定用户的密码")
    @PostMapping("resetPassword")
    public ResponseVO resetPassword(
            @Parameter(description = "用户类型：ADMIN/USER/SHOP") @RequestParam String type, 
            @Parameter(description = "用户ID") @RequestParam Integer id) {
        CommonService commonService = getCommonService(type);
        commonService.resetPassword(id);
        return ResponseVO.ok();
    }


    /**
     * 获取当前用户
     *
     * @return 当前用户信息
     */
    @Operation(summary = "获取当前用户", description = "获取当前登录用户的详细信息")
    @GetMapping("currentUser")
    public ResponseVO<CurrentUserDTO> getCurrentUser() {
        Integer userId = CurrentUserThreadLocal.getCurrentUser().getId();
        CommonService commonService = getCommonService(CurrentUserThreadLocal.getCurrentUser().getType());
        CurrentUserDTO currentUserDTO = new CurrentUserDTO();
        BeanUtils.copyProperties(commonService.selectById(userId), currentUserDTO);
        currentUserDTO.setType(CurrentUserThreadLocal.getCurrentUser().getType());
        return ResponseVO.ok(currentUserDTO);
    }

    /**
     * 根据类型获取对应service
     *
     * @param type 用户类型
     * @return 对应的Service
     */
    private CommonService getCommonService(String type) {
        switch (type) {
            case "ADMIN":
                return adminService;
            case "USER":
                return userService;
            case "SHOP":
                return shopService;
            default:
                throw new CustomException("用户类型错误");
        }
    }
}
