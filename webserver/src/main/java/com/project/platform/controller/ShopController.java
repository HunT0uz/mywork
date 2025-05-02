package com.project.platform.controller;

import com.project.platform.entity.Shop;
import com.project.platform.service.ShopService;
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
 * 店铺控制器
 */
@Tag(name = "店铺管理", description = "店铺相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/shop")
public class ShopController {
    @Resource
    private ShopService shopService;

    /**
     * 分页查询店铺
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询店铺", description = "根据条件分页查询店铺信息")
    @GetMapping("page")
    public ResponseVO<PageVO<Shop>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(shopService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询店铺
     *
     * @param id 店铺ID
     * @return 店铺信息
     */
    @Operation(summary = "根据ID查询店铺", description = "根据店铺ID查询店铺详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<Shop> selectById(
            @Parameter(description = "店铺ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(shopService.selectById(id));
    }

    /**
     * 获取店铺列表
     *
     * @return 店铺列表
     */
    @Operation(summary = "获取店铺列表", description = "获取所有店铺的列表")
    @GetMapping("list")
    public ResponseVO<List<Shop>> list() {
        return ResponseVO.ok(shopService.list());
    }

    /**
     * 新增店铺
     *
     * @param entity 店铺信息
     * @return 添加结果
     */
    @Operation(summary = "新增店铺", description = "添加新店铺")
    @PostMapping("add")
    public ResponseVO add(@RequestBody Shop entity) {
        shopService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新店铺
     *
     * @param entity 店铺信息
     * @return 更新结果
     */
    @Operation(summary = "更新店铺", description = "更新店铺信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody Shop entity) {
        shopService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除店铺
     *
     * @param ids 店铺ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除店铺", description = "批量删除指定ID的店铺")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        shopService.removeByIds(ids);
        return ResponseVO.ok();
    }
}

