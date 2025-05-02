package com.project.platform.service;

import com.project.platform.entity.User;
import com.project.platform.vo.PageVO;

import java.util.List;
import java.util.Map;

/**
 * 前台
 */
public interface UserService extends CommonService{

    /**
     * 将数据进行列表返回
     * @return
     */
    List<User> list();

    /**
     * 通过id查询
     * @param id
     * @return
     */
    User selectById(Integer id);

    /**
     * 新增
     * @param entity
     */
    void insert(User entity);

    /**
     * 更新
     * @param entity
     */
    void updateById(User entity);

    /**
     * 删除
     * @param id
     */
    void removeByIds(List<Integer> id);

    /**
     * 消费
     * @param userId 用户ID
     * @param money 消费金额
     */
    void consumption(Integer userId, Float money);

    /**
     * 充值
     * @param userId 用户ID
     * @param money 充值金额
     */
    void topUp(Integer userId, Float money);

    /**
     * 分页模糊查询
     * @param query
     * @param pageNum
     * @param pageSize
     * @return
     */
    PageVO<User> page(Map<String, Object> query, Integer pageNum, Integer pageSize);


}
