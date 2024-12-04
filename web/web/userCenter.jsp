<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户中心</title>
    <style>
        body {
            margin: 0;
            padding: 20px;
            color: black; /* 将文字颜色改为黑色 */
            background-image: url('upload/img/background.jpg'); /* 设置唯一的背景图片 */
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain; /* 保持图片完整显示 */
            background-attachment: fixed; /* 固定背景 */
            min-height: 100vh; /* 确保容器最小高度为视口高度 */
            min-width: 100vw; /* 确保容器最小宽度为视口宽度 */
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 内容靠左对齐 */
            justify-content: flex-start; /* 内容顶部对齐 */
            overflow: hidden;
        }
        h1 {
            text-align: left; /* 标题靠左对齐 */
        }
        p {
            text-align: left; /* 段落文本靠左对齐 */
        }
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: white; /* 按钮文字为白色 */
            background-color: rgba(0, 128, 0, 0.7); /* 按钮背景颜色为半透明绿色 */
            text-decoration: none;
            border-radius: 5px;
            margin: 5px 0; /* 添加上下间距 */
        }
    </style>
</head>

<body>
<h1>用户中心</h1>
<%
    String username = (String) session.getAttribute("username");
    String merchant = (String) session.getAttribute("merchantUsername");
%>
<%if (username != null) {
%>
    <p>欢迎！<%= username %>，您好！</p>
<%
    }
%>
<!-- 判断用户是否为商家，如果是商家，则显示商家中心按钮 -->
<%
    if (merchant != null) { // 判定如果 merchant 不为 null，表示是商家
%>
<p><a href="${pageContext.request.contextPath}/merchantDashboard.jsp" class="button">商家中心</a></p>
<%
    }
%>
<p><a href="${pageContext.request.contextPath}/logout.jsp" class="button">退出登录</a></p>

<p><a href="${pageContext.request.contextPath}/game.jsp" class="button">游戏</a></p>

<!-- 判断用户是否为商家，如果不是商家，则显示购物车和订单按钮 -->
<%
    if (merchant == null) { // 判定如果 merchant 为 null，表示不是商家
%>
    <p><a href="${pageContext.request.contextPath}/orderManagement" class="button">我的订单</a></p>
    <p><a href="cart.jsp" class="button">查看购物车</a></p>
<%
    }
%>
<p><a href="${pageContext.request.contextPath}/products.jsp" class="button">查看商品</a></p>
<p><a href="${pageContext.request.contextPath}/index.jsp" class="button">返回首页</a></p>
</body>
</html>

