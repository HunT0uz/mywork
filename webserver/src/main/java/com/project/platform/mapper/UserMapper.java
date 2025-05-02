package com.project.platform.mapper;

import com.project.platform.entity.User;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    /**
     * 查询全部
     * @return
     */
    @Select("SELECT * FROM user")
    List<User> list();

    /**
     * 通过用户名查询
     * @param username
     * @return
     */
    @Select("SELECT * FROM user WHERE username = #{username}")
    User selectByUsername(String username);

    /**
     * 通过id查询
     * @param id
     * @return
     */
    @Select("SELECT * FROM user WHERE id = #{id}")
    User selectById(Integer id);

    /**
     * 通过电话号码查询
     * @param tel
     * @return
     */
    @Select("SELECT * FROM user WHERE tel = #{tel}")
    User selectByTel(String tel);

    /**
     * 新增
     * @param entity
     * @return
     */
    int insert(User entity);

    /**
     * 更新
     * @param entity
     * @return
     */
    int updateById(User entity);

    /**
     * 删除
     * @param ids
     * @return
     */
    boolean removeByIds(List<Integer> ids);

    /**
     * 分页模糊查询
     * @param offset
     * @param pageSize
     * @param query
     * @return
     */
    List<User> queryPage(Integer offset, Integer pageSize, @Param("query") Map<String, Object> query);

    /**
     * 查询总数
     * @param query
     * @return
     */
    int queryCount(@Param("query") Map<String, Object> query);


}

