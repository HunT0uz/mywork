package com.project.platform.controller;

import com.project.platform.entity.Product;
import com.project.platform.entity.ProductCollect;
import com.project.platform.mapper.ProductCollectMapper;
import com.project.platform.mapper.ProductMapper;
import com.project.platform.service.ProductService;
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
 * 商品信息控制器
 */
@Tag(name = "商品管理", description = "商品相关的接口，包括查询、添加、修改、删除等操作")
@RestController
@RequestMapping("/product")
public class ProductController {
    @Resource
    private ProductService productService;

    @Resource
    private ProductCollectMapper productCollectMapper;

    /**
     * 分页查询商品
     *
     * @param query 查询条件
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @return 分页结果
     */
    @Operation(summary = "分页查询商品", description = "根据条件分页查询商品信息")
    @GetMapping("page")
    public ResponseVO<PageVO<Product>> page(
            @Parameter(description = "查询条件") @RequestParam Map<String, Object> query, 
            @Parameter(description = "页码") @RequestParam(defaultValue = "1") Integer pageNum, 
            @Parameter(description = "每页大小") @RequestParam(defaultValue = "10") Integer pageSize) {
        return ResponseVO.ok(productService.page(query, pageNum, pageSize));
    }

    /**
     * 根据ID查询商品
     *
     * @param id 商品ID
     * @return 商品信息
     */
    @Operation(summary = "根据ID查询商品", description = "根据商品ID查询商品详细信息，如果当前用户是普通用户，还会返回收藏状态")
    @GetMapping("selectById/{id}")
    public ResponseVO<Product> selectById(
            @Parameter(description = "商品ID") @PathVariable("id") Integer id) {
        Product entity = productService.selectById(id);
        if (CurrentUserThreadLocal.getCurrentUser().getType().equals("USER")) {
            ProductCollect productCollect = productCollectMapper.selectByProductIdAndUserId(id, CurrentUserThreadLocal.getCurrentUser().getId());
            if (productCollect != null) {
                entity.setProductCollectId(productCollect.getId());
            }
        }
        return ResponseVO.ok(entity);
    }

    /**
     * 获取商品列表
     *
     * @return 商品列表
     */
    @Operation(summary = "获取商品列表", description = "获取所有商品的列表")
    @GetMapping("list")
    public ResponseVO<List<Product>> list() {
        return ResponseVO.ok(productService.list());
    }

    /**
     * 新增商品
     *
     * @param entity 商品信息
     * @return 添加结果
     */
    @Operation(summary = "新增商品", description = "添加新商品")
    @PostMapping("add")
    public ResponseVO add(@RequestBody Product entity) {
        productService.insert(entity);
        return ResponseVO.ok();
    }

    /**
     * 更新商品
     *
     * @param entity 商品信息
     * @return 更新结果
     */
    @Operation(summary = "更新商品", description = "更新商品信息")
    @PutMapping("update")
    public ResponseVO update(@RequestBody Product entity) {
        productService.updateById(entity);
        return ResponseVO.ok();
    }

    /**
     * 批量删除商品
     *
     * @param ids 商品ID列表
     * @return 删除结果
     */
    @Operation(summary = "批量删除商品", description = "批量删除指定ID的商品")
    @DeleteMapping("delBatch")
    public ResponseVO delBatch(@RequestBody List<Integer> ids) {
        productService.removeByIds(ids);
        return ResponseVO.ok();
    }

    /**
     * 获取销量最高的商品
     *
     * @param size 获取数量
     * @return 商品列表
     */
    @Operation(summary = "获取销量最高的商品", description = "获取指定数量的销量最高的商品")
    @GetMapping("salesVolumeTop/{size}")
    public ResponseVO<List<Product>> salesVolumeTop(
            @Parameter(description = "获取数量") @PathVariable int size) {
        return ResponseVO.ok(productService.salesVolumeTop(size));
    }

    /**
     * 获取推荐商品
     *
     * @param size 获取数量
     * @return 商品列表
     */
    @Operation(summary = "获取推荐商品", description = "获取指定数量的推荐商品")
    @GetMapping("recommend/{size}")
    public ResponseVO<List<Product>> recommend(
            @Parameter(description = "获取数量") @PathVariable int size) {
        return ResponseVO.ok(productService.recommended(size));
    }
}

