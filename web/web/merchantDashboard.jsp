<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>商家仪表板</title>
    <style>
        body {
            position: relative; /* 设置相对定位以便使用伪元素 */
            margin: 0;
            color: white; /* 默认文字颜色设置为白色 */
            min-height: 100vh; /* 最小高度为100%视口高度 */
            display: flex; /* 使用 flex 布局 */
            flex-direction: column; /* 垂直排列 */
            align-items: center; /* 子元素水平居中 */
            overflow-y: hidden;
        }

        body::before {
            content: ""; /* 伪元素内容为空 */
            position: absolute; /* 绝对定位 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('upload/img/merchant_bg.jpg'); /* 替换为你的背景图片路径 */
            background-size: cover; /* 背景图片覆盖 */
            background-position: center; /* 背景图片居中 */
            filter: blur(8px); /* 设置背景虚化效果 */
            z-index: -1; /* 设置较低层级 */
            background-color: rgba(0, 0, 0, 0.5); /* 添加黑色覆盖层 */
            overflow: hidden; /* 隐藏滚动条 */
        }

        .content {
            position: relative; /* 设置内容层相对定位 */
            z-index: 1; /* 确保内容层在背景之上 */
            max-height: 80vh; /* 设置最大高度为 80% 视口高度 */
            overflow-y: auto; /* 内容溢出时显示垂直滚动条 */
            padding: 20px; /* 添加内边距 */
            width: 100%; /* 设定为100%宽度 */
            display: flex; /* 使用 flex 布局 */
            justify-content: center; /* 水平居中 */
        }

        .sidebar {
            width: 250px; /* 增加菜单宽度 */
            margin-right: 20px;
            border: 1px solid #ccc;
            padding: 10px;
            float: left; /* 菜单浮动到左侧 */
            color: black; /* 设置菜单文字颜色为黑色 */
        }

        .sidebar h3 {
            margin-top: 0;
            color: black; /* 设置标题颜色为白色 */
        }

        .sidebar a {
            display: block;
            padding: 8px;
            margin: 4px 0;
            text-decoration: none;
            color: black; /* 设置链接颜色为白色 */
            background-color: #f9f9f9; /* 按钮背景颜色 */
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .sidebar a:hover {
            background-color: #f1f1f1;
        }

        .button {
            color: black; /* 按钮颜色设置为黑色 */
        }

        .product-list {
            height: 600px; /* 固定高度，表示商品展示区域 */
            overflow-y: auto; /* 允许垂直滚动 */
            border: 1px solid #ccc;
            padding: 10px;
            width: 800px; /* 设置商品展示区域宽度 */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 添加阴影效果 */
        }

        img {
            max-width: 100px; /* 设置图片最大宽度 */
            max-height: 100px; /* 设置图片最大高度 */
        }

        table {
            width: 100%; /* 表格宽度占满整个商品展示区域 */
            border-collapse: collapse; /* 合并边框 */
        }

        th, td {
            padding: 10px; /* 增加单元格内边距 */
            text-align: center; /* 使文字居中 */
        }
    </style>
</head>
<body>

<%
    session = request.getSession();
    String merchantUsername = (String) session.getAttribute("merchantUsername");
    if (merchantUsername == null) {
        response.sendRedirect("merchantLogin.jsp");
        return;
    }
%>

<h2>欢迎，<%= merchantUsername %>!</h2>

<div class="content">
    <div class="sidebar">
        <h3>功能菜单</h3>
        <a href="addProduct.jsp">添加商品</a>
        <a href="updateProduct.jsp">编辑商品</a>
        <a href="merchantOrderManagement">商品订单</a>
        <a href="products.jsp" class="button">返回商品列表</a>
    </div>

    <!-- 商品列表 -->
    <div class="product-list">
        <h3>现有商品</h3>
        <table border="1">
            <tr>
                <th>商品ID</th>
                <th>商品名称</th>
                <th>商品价格</th>
                <th>商品类型</th>
                <th>商品图片</th>
            </tr>
            <%
                Connection conn = null;
                try {
                    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
                    conn = DriverManager.getConnection(jdbcUrl, "root", "1234");
                    String sql = "SELECT * FROM products WHERE merchant_name = ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, merchantUsername);
                    ResultSet rs = pstmt.executeQuery();
                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("name") %></td>
                <td><%= rs.getDouble("price") %></td>
                <td><%= rs.getString("type") %></td>
                <td><img src="<%= request.getContextPath() %>/upload/img/<%= rs.getString("image") %>" alt="商品图片"></td>
            </tr>
            <%
                    }
                    rs.close();
                    pstmt.close();
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if(conn != null) {
                        try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                    }
                }
            %>
        </table>
    </div>
</div>

</body>
</html>
