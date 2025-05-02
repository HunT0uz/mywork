package com.project.platform.controller;

import com.project.platform.entity.User;
import com.project.platform.service.UserService;
import com.project.platform.utils.CurrentUserThreadLocal;
import com.project.platform.vo.PageVO;
import com.project.platform.vo.ResponseVO;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.annotation.Resource;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * 用户控制器
 */
@Tag(name = "用户管理", description = "用户相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/user")
public class UserController {
    @Resource
    private UserService userService;

    /**
     * 获取用户列表
     * @return 用户列表
     */
    @Operation(summary = "获取用户列表", description = "获取所有用户的列表")
    @GetMapping("list")
    public ResponseVO<List<User>> list(){
        return ResponseVO.ok(userService.list());
    }

    /**
     * 根据ID查询用户
     * @param id 用户ID
     * @return 用户信息
     */
    @Operation(summary = "根据ID查询用户", description = "根据用户ID查询用户详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<User> selectById(
            @Parameter(description = "用户ID") @PathVariable("id") Integer id){
        User user = userService.selectById(id);
        return ResponseVO.ok(user);
    }

    /**
     * 用户充值
     * @param amount 充值金额
     * @return 充值结果
     */
    @Operation(summary = "用户充值", description = "为当前登录用户充值指定金额")
    @PostMapping("/topUp/{amount}")
    public ResponseVO topUp(
            @Parameter(description = "充值金额") @PathVariable Float amount) {
        Integer userId = CurrentUserThreadLocal.getCurrentUser().getId();
        userService.topUp(userId, amount);
        return ResponseVO.ok();
    }

    /**
     * 新增用户
     * @param entity 用户信息
     * @return 添加结果
     */
    @Operation(summary = "新增用户", description = "添加新用户")
    @PostMapping("add")
    public ResponseVO add(@RequestBody User entity) {
        userService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新用户
     * @param entity 用户信息
     * @return 更新结果
     */
    @Operation(summary = "更新用户", description = "更新用户信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody User entity) {
        userService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除用户
     * @param ids 用户ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除用户", description = "批量删除指定ID的用户")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        userService.removeByIds(ids);
        return ResponseVO.ok();
    }

    /**
     * 分页查询用户
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询用户", description = "根据条件分页查询用户")
    @GetMapping("page")
    public ResponseVO<PageVO<User>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query,
            @Parameter(description = "页码") @RequestParam Integer pageNum,
            @Parameter(description = "每页大小") @RequestParam Integer pageSize) {
        return ResponseVO.ok(userService.page(query, pageNum, pageSize));
    }
}
