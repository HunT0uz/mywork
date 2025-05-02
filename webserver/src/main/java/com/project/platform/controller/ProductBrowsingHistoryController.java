package com.project.platform.controller;

import com.project.platform.entity.ProductBrowsingHistory;
import com.project.platform.service.ProductBrowsingHistoryService;
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
 * 商品浏览历史控制器
 */
@Tag(name = "商品浏览历史管理", description = "商品浏览历史相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/productBrowsingHistory")
public class ProductBrowsingHistoryController {
    @Resource
    private ProductBrowsingHistoryService productBrowsingHistoryService;

    /**
     * 分页查询商品浏览历史
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询商品浏览历史", description = "根据条件分页查询商品浏览历史信息")
    @GetMapping("page")
    public ResponseVO<PageVO<ProductBrowsingHistory>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(productBrowsingHistoryService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询商品浏览历史
     *
     * @param id 浏览历史ID
     * @return 浏览历史信息
     */
    @Operation(summary = "根据ID查询商品浏览历史", description = "根据浏览历史ID查询浏览历史详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<ProductBrowsingHistory> selectById(
            @Parameter(description = "浏览历史ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(productBrowsingHistoryService.selectById(id));
    }

    /**
     * 获取商品浏览历史列表
     *
     * @return 浏览历史列表
     */
    @Operation(summary = "获取商品浏览历史列表", description = "获取所有商品浏览历史的列表")
    @GetMapping("list")
    public ResponseVO<List<ProductBrowsingHistory>> list() {
        return ResponseVO.ok(productBrowsingHistoryService.list());
    }

    /**
     * 新增商品浏览历史
     *
     * @param entity 浏览历史信息
     * @return 添加结果
     */
    @Operation(summary = "新增商品浏览历史", description = "添加新商品浏览历史")
    @PostMapping("add")
    public ResponseVO add(@RequestBody ProductBrowsingHistory entity) {
        productBrowsingHistoryService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新商品浏览历史
     *
     * @param entity 浏览历史信息
     * @return 更新结果
     */
    @Operation(summary = "更新商品浏览历史", description = "更新商品浏览历史信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody ProductBrowsingHistory entity) {
        productBrowsingHistoryService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除商品浏览历史
     *
     * @param ids 浏览历史ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除商品浏览历史", description = "批量删除指定ID的商品浏览历史")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        productBrowsingHistoryService.removeByIds(ids);
        return ResponseVO.ok();
    }
}

