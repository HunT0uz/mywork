package com.project.platform.controller;

import com.project.platform.entity.ProductType;
import com.project.platform.service.ProductTypeService;
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
 * 商品分类控制器
 */
@Tag(name = "商品分类管理", description = "商品分类相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/productType")
public class ProductTypeController {
    @Resource
    private ProductTypeService productTypeService;

    /**
     * 分页查询商品分类
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询商品分类", description = "根据条件分页查询商品分类信息")
    @GetMapping("page")
    public ResponseVO<PageVO<ProductType>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(productTypeService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询商品分类
     *
     * @param id 分类ID
     * @return 分类信息
     */
    @Operation(summary = "根据ID查询商品分类", description = "根据分类ID查询分类详细信息")
    @GetMapping("selectById/{id}")
    public ResponseVO<ProductType> selectById(
            @Parameter(description = "分类ID") @PathVariable("id") Integer id) {
        return ResponseVO.ok(productTypeService.selectById(id));
    }

    /**
     * 获取商品分类列表
     *
     * @return 分类列表
     */
    @Operation(summary = "获取商品分类列表", description = "获取所有商品分类的列表")
    @GetMapping("list")
    public ResponseVO<List<ProductType>> list() {
        return ResponseVO.ok(productTypeService.list());
    }

    /**
     * 新增商品分类
     *
     * @param entity 分类信息
     * @return 添加结果
     */
    @Operation(summary = "新增商品分类", description = "添加新商品分类")
    @PostMapping("add")
    public ResponseVO add(@RequestBody ProductType entity) {
        productTypeService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新商品分类
     *
     * @param entity 分类信息
     * @return 更新结果
     */
    @Operation(summary = "更新商品分类", description = "更新商品分类信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody ProductType entity) {
        productTypeService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除商品分类
     *
     * @param ids 分类ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除商品分类", description = "批量删除指定ID的商品分类")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        productTypeService.removeByIds(ids);
        return ResponseVO.ok();
    }
}

