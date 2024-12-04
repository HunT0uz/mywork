<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    String rootname = "root";
    String rootpassword = "1234";

    String productName = request.getParameter("product"); // 获取商品名称
    Connection connection = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        String sql = "SELECT name, price, type, image, description, merchant_name FROM products WHERE name = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, productName);

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            String name = resultSet.getString("name");
            double price = resultSet.getDouble("price");
            String type = resultSet.getString("type");
            String image = resultSet.getString("image");
            String description = resultSet.getString("description"); // 获取产品介绍
            String seller = resultSet.getString("merchant_name"); // 获取商家名称

            String recommendSql = "SELECT name, price, image " +
                    "FROM products " +
                    "WHERE (type = ? AND merchant_name = ?) " +
                    "OR (type = ?) " +
                    "OR (merchant_name = ?) " +
                    "OR (name LIKE ?) " +
                    "ORDER BY " +
                    "  CASE " +
                    "    WHEN type = ? THEN 1 " +
                    "    WHEN merchant_name = ? THEN 2 " +
                    "    ELSE 3 " +
                    "  END, " +
                    "  merchant_name " +
                    "LIMIT 6;";

            PreparedStatement recommendStatement = connection.prepareStatement(recommendSql);
            recommendStatement.setString(1, type); // 设置type参数
            recommendStatement.setString(2, seller); // 设置merchant_name参数
            recommendStatement.setString(3, type); // 再次设置type参数，用于OR条件
            recommendStatement.setString(4, seller); // 再次设置merchant_name参数，用于OR条件
            recommendStatement.setString(5, "%" + name + "%"); // 设置模糊匹配参数
            recommendStatement.setString(6, type); // 设置CASE语句中的type参数
            recommendStatement.setString(7, seller); // 设置CASE语句中的merchant_name参数

            ResultSet recommendResultSet = recommendStatement.executeQuery();
%>
<html>
<head>
    <title><%= name %> - 商品详情</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            background-color: #f9f9f9; /* 背景色 */
        }
        .product-detail {
            display: flex;
            justify-content: center;
            width: 80%; /* 限制产品详情的宽度 */
            margin-bottom: 40px;
            background: white; /* 白色背景 */
            padding: 20px; /* 内边距 */
            border-radius: 8px; /* 圆角 */
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1); /* 阴影 */
        }
        .product-info {
            margin-left: 20px;
            max-width: 400px; /* 限制文本区域的最大宽度 */
        }
        img.product-img {
            width: 300px; /* 增大产品详情图宽度 */
            height: 300px; /* 增大产品详情高度 */
            object-fit: cover; /* 保持图片比例，裁剪多余部分 */
            border-radius: 5px; /* 圆角 */
        }
        img.recommendation-img {
            width: 120px; /* 缩小推荐商品图宽度 */
            height: 120px; /* 缩小推荐商品高度 */
            object-fit: cover; /* 保持图片比例，裁剪多余部分 */
            border-radius: 5px; /* 圆角 */
        }
        .add-to-cart {
            margin-top: 20px;
        }
        .description {
            margin-top: 10px;
            font-size: 16px; /* 增大文字尺寸 */
            color: #555;
        }
        .recommendation {
            margin-top: 40px;
            width: 80%; /* 推荐商品区域的宽度 */
        }
        .recommendation h2 {
            margin-bottom: 20px;
            font-size: 22px; /* 增大推荐商品标题字体 */
            color: #333;
        }
        .recommendation-items {
            display: flex;
            flex-wrap: wrap;
            gap: 15px; /* 商品间距 */
        }
        .recommendation-item {
            width: 150px; /* 推荐商品容器宽度 */
            text-align: center;
            background: white; /* 白色背景 */
            border-radius: 5px; /* 圆角 */
            padding: 10px; /* 内边距 */
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1); /* 阴影 */
        }
        .recommendation-item p {
            font-size: 14px; /* 增大商品信息字体 */
            margin: 5px 0; /* 上下外边距 */
        }
    </style>
</head>
<body>
<div class="product-detail">
    <% if (image != null && !image.isEmpty()) { %>
        <img class="product-img" src="<%= request.getContextPath() + "/upload/img/" + image %>" alt="<%= name %>图片">
    <% } else { %>
        <img class="product-img" src="<%= request.getContextPath() + "/upload/img/no-image.png" %>" alt="无图片">
    <% } %>
    <div class="product-info">
        <h1><%= name %></h1>
        <p style="font-size: 20px;">价格: ￥<%= price %></p>
        <p>类型: <%= type %></p>
        <div class="description"><strong>产品介绍:</strong> <%= description %></div>
        <form action="addToCart.jsp" method="post" class="add-to-cart">
            <input type="hidden" name="productName" value="<%= name %>">
            <input type="hidden" name="productPrice" value="<%= price %>">
            <button type="submit">添加到购物车</button>
        </form>
        <a href="products.jsp">返回商品列表</a>
    </div>
</div>

<div class="recommendation">
    <h2>推荐商品</h2>
    <div class="recommendation-items">
        <%
            while (recommendResultSet.next()) {
                String recommendName = recommendResultSet.getString("name");
                double recommendPrice = recommendResultSet.getDouble("price");
                String recommendImage = recommendResultSet.getString("image");
        %>
            <div class="recommendation-item">
                <img class="recommendation-img" src="<%= request.getContextPath() + "/upload/img/" + recommendImage %>" alt="<%= recommendName %>">
                <p><strong><%= recommendName %></strong></p>
                <p>价格: ￥<%= recommendPrice %></p>
                <form action="addToCart.jsp" method="post">
                    <input type="hidden" name="productName" value="<%= recommendName %>">
                    <input type="hidden" name="productPrice" value="<%= recommendPrice %>">
                    <button type="submit">添加到购物车</button>
                </form>
            </div>
        <% } %>
    </div>
</div>

</body>
</html>
<%
        } else {
            out.println("商品未找到！");
        }
    } catch (SQLException e) {
        out.println("数据库错误: " + e.getMessage()); // 显示数据库错误信息
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        out.println("驱动程序未找到: " + e.getMessage()); // 显示驱动错误
        e.printStackTrace();
    } finally {
        if (connection != null) {
            try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
