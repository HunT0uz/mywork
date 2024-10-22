<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/12
  Time: 下午5:45
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户中心</title>
</head>

<body>
<style>
    .button {
        display: inline-block;
        padding: 10px 20px;
        font-size: 16px;
        color: white;
        background-color: green;
        text-decoration: none;
        border-radius: 5px;
    }
</style>
    <h1>用户中心</h1>
    <p>欢迎！</p>
    <p><a href="${pageContext.request.contextPath}/logout.jsp" class="button">退出登录</a></p>
    <!--<p><a href="${pageContext.request.contextPath}/updateUser">修改个人信息</a></p>
    <p><a href="${pageContext.request.contextPath}/updatePassword">修改密码</a></p>
    <p><a href="${pageContext.request.contextPath}/order">我的订单</a></p>
    <p><a href="${pageContext.request.contextPath}/address">收货地址</a></p>
    <p><a href="${pageContext.request.contextPath}/collection">我的收藏</a></p>
    <p><a href="${pageContext.request.contextPath}/comment">我的评价</a></p>
    <p><a href="${pageContext.request.contextPath}/cart">购物车</a></p>
    -->
    <p><a href="${pageContext.request.contextPath}/Snake.jsp" class="button">贪吃蛇</a></p>
    <p><a href="${pageContext.request.contextPath}/tetris.jsp" class="button">俄罗斯方块</a></p>
    <p><a href="${pageContext.request.contextPath}/index.jsp" class="button">返回首页</a></p>
    <!-- 新增商品和购物车按钮 -->
    <p><a href="products.jsp" class="button">查看商品</a></p>
    <p><a href="cart.jsp" class="button">查看购物车</a></p>
</body>
</html>
