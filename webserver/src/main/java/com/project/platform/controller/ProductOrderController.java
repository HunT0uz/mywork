package com.project.platform.controller;

import com.project.platform.entity.ProductOrder;
import com.project.platform.service.ProductOrderService;
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
 * 商品订单控制器
 */
@Tag(name = "商品订单管理", description = "商品订单相关的接口，包括查询、添加、修改、删除、支付、取消、发货、确认收货等操作")
@RestController
@RequestMapping("/productOrder")
public class ProductOrderController {
    @Resource
    private ProductOrderService productOrderService;

    /**
     * 分页查询商品订单
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询商品订单", description = "根据条件分页查询商品订单信息")
    @GetMapping("page")
    public ResponseVO<PageVO<ProductOrder>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(productOrderService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询商品订单
     *
     * @param id 订单ID
     * @return 订单信息
     */
    @Operation(summary = "根据ID查询商品订单", description = "根据订单ID查询订单详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<ProductOrder> selectById(
            @Parameter(description = "订单ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(productOrderService.selectById(id));
    }

    /**
     * 获取商品订单列表
     *
     * @return 订单列表
     */
    @Operation(summary = "获取商品订单列表", description = "获取所有商品订单的列表")
    @GetMapping("list")
    public ResponseVO<List<ProductOrder>> list() {
        return ResponseVO.ok(productOrderService.list());
    }

    /**
     * 新增商品订单
     *
     * @param entity 订单信息
     * @return 添加结果
     */
    @Operation(summary = "新增商品订单", description = "添加新商品订单")
    @PostMapping("add")
    public ResponseVO add(@RequestBody ProductOrder entity) {
        productOrderService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新商品订单
     *
     * @param entity 订单信息
     * @return 更新结果
     */
    @Operation(summary = "更新商品订单", description = "更新商品订单信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody ProductOrder entity) {
        productOrderService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除商品订单
     *
     * @param ids 订单ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除商品订单", description = "批量删除指定ID的商品订单")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        productOrderService.removeByIds(ids);
        return ResponseVO.ok();
    }

    /**
     * 支付订单
     *
     * @param id 订单ID
     * @return 支付结果
     */
    @Operation(summary = "支付订单", description = "对指定订单进行支付操作")
    @PostMapping("pay/{id}")
    public ResponseVO pay(
            @Parameter(description = "订单ID") @PathVariable("id") Integer id) {
        productOrderService.pay(id);
        return ResponseVO.ok();
    }

    /**
     * 取消订单
     *
     * @param id 订单ID
     * @return 取消结果
     */
    @Operation(summary = "取消订单", description = "取消指定订单")
    @PostMapping("cancel/{id}")
    public ResponseVO cancel(
            @Parameter(description = "订单ID") @PathVariable("id") Integer id) {
        productOrderService.cancel(id);
        return ResponseVO.ok();
    }

    /**
     * 发货
     *
     * @param id 订单ID
     * @param trackingNumber 物流单号
     * @return 发货结果
     */
    @Operation(summary = "订单发货", description = "为指定订单进行发货操作，需要提供物流单号")
    @PostMapping("delivery/{id}")
    public ResponseVO delivery(
            @Parameter(description = "订单ID") @PathVariable("id") Integer id,
            @Parameter(description = "物流单号") @RequestParam String trackingNumber) {
        productOrderService.delivery(id, trackingNumber);
        return ResponseVO.ok();
    }

    /**
     * 确认收货
     *
     * @param id 订单ID
     * @return 确认结果
     */
    @Operation(summary = "确认收货", description = "确认收到指定订单的商品")
    @PostMapping("confirm/{id}")
    public ResponseVO confirm(
            @Parameter(description = "订单ID") @PathVariable("id") Integer id) {
        productOrderService.confirm(id);
        return ResponseVO.ok();
    }
}

