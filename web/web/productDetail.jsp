<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    String rootname = "root";
    String rootpassword = "1234";

    String productId = request.getParameter("id"); // 获取商品ID
    Connection connection = null;

    if (productId == null || productId.isEmpty()) {
        out.println("商品ID没有提供！");
        return; // 退出 JSP 处理
    }

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        String sql = "SELECT name, price, type, image, description, merchant_name FROM products WHERE id = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setInt(1, Integer.parseInt(productId)); // 使用ID查询

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            String name = resultSet.getString("name");
            double price = resultSet.getDouble("price");
            String type = resultSet.getString("type");
            String image = resultSet.getString("image");
            String description = resultSet.getString("description");
            String seller = resultSet.getString("merchant_name");

            String recommendSql = "SELECT name, price, image, id " + // 也添加了id
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
            recommendStatement.setString(1, type);
            recommendStatement.setString(2, seller);
            recommendStatement.setString(3, type);
            recommendStatement.setString(4, seller);
            recommendStatement.setString(5, "%" + name + "%");
            recommendStatement.setString(6, type);
            recommendStatement.setString(7, seller);

            ResultSet recommendResultSet = recommendStatement.executeQuery();
%>
<html>
<head>
    <title><%= name %> - 商品详情</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            background: url('<%= request.getContextPath() + "/upload/img/productDetail_bg.jpg" %>') no-repeat center center fixed;
            background-size: cover;
            height: 20vh;
        }
        .product-detail {
            display: flex;
            justify-content: center;
            width: 80%;
            margin-bottom: 40px;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        .product-info {
            margin-left: 20px;
            max-width: 400px;
        }
        img.product-img {
            width: 300px;
            height: 300px;
            object-fit: cover;
            border-radius: 5px;
        }
        img.recommendation-img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 5px;
        }
        .add-to-cart {
            margin-top: 20px;
        }
        .description {
            margin-top: 10px;
            font-size: 16px;
            color: #555;
        }
        .recommendation {
            margin-top: 40px;
            width: 80%;
        }
        .recommendation h2 {
            margin-bottom: 20px;
            font-size: 22px;
            color: #333;
        }
        .recommendation-items {
            display: flex;
            flex-wrap: wrap;
            gap: 15px;
        }
        .recommendation-item {
            width: 150px;
            text-align: center;
            background: white;
            border-radius: 5px;
            padding: 10px;
            box-shadow: 0 1px 5px rgba(0, 0, 0, 0.1);
        }
        .recommendation-item p {
            font-size: 14px;
            margin: 5px 0;
            color: black;
        }
        .description-content {
            max-height: 150px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        a {
            text-decoration: none;
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
            <p>商家: <%= seller %></p>
            <div class="description">
                <strong>产品介绍:</strong>
                <div class="description-content"><%= description %></div>
            </div>

        <% if (session.getAttribute("merchantUsername") == null) { %>
            <form action="addToCart.jsp" method="post" class="add-to-cart">
                <input type="hidden" name="productName" value="<%= name %>">
                <input type="hidden" name="productPrice" value="<%= price %>">
                <button type="submit">添加到购物车</button>
            </form>
        <% } %>

        <a href="products.jsp">返回商品列表</a>
    </div>
</div>

<div class="recommendation">
    <h2 style="color: white;">推荐商品</h2>
    <div class="recommendation-items">
        <%
            while (recommendResultSet.next()) {
                String recommendName = recommendResultSet.getString("name");
                double recommendPrice = recommendResultSet.getDouble("price");
                String recommendImage = recommendResultSet.getString("image");
                int recommendId = recommendResultSet.getInt("id"); // 获取推荐商品ID

                String recommendLink = "productDetail.jsp?id=" + recommendId; // 使用推荐商品ID
        %>
            <div class="recommendation-item">
                <a href="<%= recommendLink %>">
                    <img class="recommendation-img" src="<%= request.getContextPath() + "/upload/img/" + recommendImage %>" alt="<%= recommendName %>">
                    <p><strong><%= recommendName %></strong></p>
                    <p>价格: ￥<%= recommendPrice %></p>
                </a>
                <form action="addToCart.jsp" method="post">
                    <input type="hidden" name="productName" value="<%= recommendName %>">
                    <input type="hidden" name="productPrice" value="<%= recommendPrice %>">
                    <button type="submit">添加到购物车</button>
                </form>
            </div>
        <%
            }
        %>
    </div>
</div>

</body>
</html>
<%
        } else {
            out.println("商品未找到！");
        }
    } catch (SQLException e) {
        out.println("数据库错误: " + e.getMessage());
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        out.println("驱动程序未找到: " + e.getMessage());
        e.printStackTrace();
    } finally {
        if (connection != null) {
            try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
