package com.project.platform.controller;

import com.project.platform.entity.ProductCollect;
import com.project.platform.mapper.ProductCollectMapper;
import com.project.platform.service.ProductCollectService;
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
 * 商品收藏控制器
 */
@Tag(name = "商品收藏管理", description = "商品收藏相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/productCollect")
public class ProductCollectController {
    @Resource
    private ProductCollectService productCollectService;

    /**
     * 分页查询商品收藏
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询商品收藏", description = "根据条件分页查询商品收藏信息")
    @GetMapping("page")
    public ResponseVO<PageVO<ProductCollect>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(productCollectService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询商品收藏
     *
     * @param id 收藏ID
     * @return 收藏信息
     */
    @Operation(summary = "根据ID查询商品收藏", description = "根据收藏ID查询收藏详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<ProductCollect> selectById(
            @Parameter(description = "收藏ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(productCollectService.selectById(id));
    }

    /**
     * 获取商品收藏列表
     *
     * @return 收藏列表
     */
    @Operation(summary = "获取商品收藏列表", description = "获取所有商品收藏的列表")
    @GetMapping("list")
    public ResponseVO<List<ProductCollect>> list() {
        return ResponseVO.ok(productCollectService.list());
    }

    /**
     * 新增商品收藏
     *
     * @param entity 收藏信息
     * @return 添加结果
     */
    @Operation(summary = "新增商品收藏", description = "添加新商品收藏")
    @PostMapping("add")
    public ResponseVO<ProductCollect> add(@RequestBody ProductCollect entity) {
        productCollectService.insert(entity);
        return ResponseVO.ok(entity);
    }

    /**
     * 更新商品收藏
     *
     * @param entity 收藏信息
     * @return 更新结果
     */
    @Operation(summary = "更新商品收藏", description = "更新商品收藏信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody ProductCollect entity) {
        productCollectService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除商品收藏
     *
     * @param ids 收藏ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除商品收藏", description = "批量删除指定ID的商品收藏")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        productCollectService.removeByIds(ids);
        return ResponseVO.ok();
    }
}

