package com.project.platform.controller;

import com.project.platform.entity.ShippingAddress;
import com.project.platform.service.ShippingAddressService;
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
 * 收货地址控制器
 */
@Tag(name = "收货地址管理", description = "收货地址相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/shippingAddress")
public class ShippingAddressController {
    @Resource
    private ShippingAddressService shippingAddressService;

    /**
     * 分页查询收货地址
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询收货地址", description = "根据条件分页查询收货地址信息")
    @GetMapping("page")
    public ResponseVO<PageVO<ShippingAddress>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(shippingAddressService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询收货地址
     *
     * @param id 地址ID
     * @return 地址信息
     */
    @Operation(summary = "根据ID查询收货地址", description = "根据地址ID查询收货地址详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<ShippingAddress> selectById(
            @Parameter(description = "地址ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(shippingAddressService.selectById(id));
    }

    /**
     * 获取收货地址列表
     *
     * @return 地址列表
     */
    @Operation(summary = "获取收货地址列表", description = "获取所有收货地址的列表")
    @GetMapping("list")
    public ResponseVO<List<ShippingAddress>> list() {
        return ResponseVO.ok(shippingAddressService.list());
    }

    /**
     * 新增收货地址
     *
     * @param entity 地址信息
     * @return 添加结果
     */
    @Operation(summary = "新增收货地址", description = "添加新收货地址")
    @PostMapping("add")
    public ResponseVO add(@RequestBody ShippingAddress entity) {
        shippingAddressService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新收货地址
     *
     * @param entity 地址信息
     * @return 更新结果
     */
    @Operation(summary = "更新收货地址", description = "更新收货地址信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody ShippingAddress entity) {
        shippingAddressService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除收货地址
     *
     * @param ids 地址ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除收货地址", description = "批量删除指定ID的收货地址")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        shippingAddressService.removeByIds(ids);
        return ResponseVO.ok();
    }
}

