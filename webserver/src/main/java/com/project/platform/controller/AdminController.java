package com.project.platform.controller;

import com.project.platform.entity.Admin;
import com.project.platform.service.AdminService;
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
 * 管理员控制器
 */
@Tag(name = "管理员管理", description = "管理员相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/admin")
public class AdminController {
    @Resource
    private AdminService adminService;

    /**
     * 分页查询管理员
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询管理员", description = "根据条件分页查询管理员信息")
    @GetMapping("page")
    public ResponseVO<PageVO<Admin>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(adminService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询管理员
     *
     * @param id 管理员ID
     * @return 管理员信息
     */
    @Operation(summary = "根据ID查询管理员", description = "根据管理员ID查询管理员详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<Admin> selectById(
            @Parameter(description = "管理员ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(adminService.selectById(id));
    }

    /**
     * 获取管理员列表
     *
     * @return 管理员列表
     */
    @Operation(summary = "获取管理员列表", description = "获取所有管理员的列表")
    @GetMapping("list")
    public ResponseVO<List<Admin>> list() {
        return ResponseVO.ok(adminService.list());
    }

    /**
     * 新增管理员
     *
     * @param entity 管理员信息
     * @return 添加结果
     */
    @Operation(summary = "新增管理员", description = "添加新管理员")
    @PostMapping("add")
    public ResponseVO add(@RequestBody Admin entity) {
        adminService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新管理员
     *
     * @param entity 管理员信息
     * @return 更新结果
     */
    @Operation(summary = "更新管理员", description = "更新管理员信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody Admin entity) {
        adminService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除管理员
     *
     * @param ids 管理员ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除管理员", description = "批量删除指定ID的管理员")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        adminService.removeByIds(ids);
        return ResponseVO.ok();
    }
}
