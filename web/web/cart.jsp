<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%
    // 数据库连接信息
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
    String username = "root"; // 数据库用户
    String password = "1234"; // 数据库密码

    // 获取 session
    session = request.getSession();
    List<String> cart = (List<String>) session.getAttribute("cart");

    if (cart == null) {
        cart = new ArrayList<>(); // 初始化购物车
    }

    double totalAmount = 0.0; // 总金额
    Connection connection = null;
    HashMap<String, Integer> productCountMap = new HashMap<>(); // 用于记录商品数量
    HashMap<String, Double> productPriceMap = new HashMap<>(); // 用于记录商品价格
    HashMap<String, String> productImageMap = new HashMap<>(); // 用于记录商品图片URL

    // 统计每个商品的数量
    for (String product : cart) {
        productCountMap.put(product, productCountMap.getOrDefault(product, 0) + 1);
    }

    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // 查询购物车中每个商品的价格和图片
        String sql = "SELECT name, price, image FROM products WHERE name IN (";

        // 拼接查询条件
        if (!productCountMap.isEmpty()) {
            for (int i = 0; i < productCountMap.size(); i++) {
                sql += "?";
                if (i < productCountMap.size() - 1) {
                    sql += ",";
                }
            }
            sql += ")";

            PreparedStatement preparedStatement = connection.prepareStatement(sql);

            // 设置查询参数
            int index = 1; // 用于为每个商品设置查询参数
            for (String item : productCountMap.keySet()) {
                preparedStatement.setString(index++, item);
            }

            ResultSet resultSet = preparedStatement.executeQuery();

            // 计算总金额
            boolean found = false;
            while (resultSet.next()) {
                found = true;
                String productName = resultSet.getString("name");
                double productPrice = resultSet.getDouble("price");
                String imageUrl = resultSet.getString("image"); // 获取商品图片URL
                int quantity = productCountMap.get(productName); // 获取该商品的数量

                // 累加总金额
                totalAmount += productPrice * quantity;

                // 保存商品信息
                productImageMap.put(productName, imageUrl);
                productPriceMap.put(productName, productPrice); // 保存商品价格
            }

            // 关闭ResultSet和PreparedStatement
            resultSet.close();
            preparedStatement.close();
        } else {
            out.println("<p style='color: red;'>购物车为空，没有商品需要查询。</p>");
        }
    } catch (SQLException e) {
        out.println("<p style='color: red;'>SQL异常: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        out.println("<p style='color: red;'>找不到JDBC驱动: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        // 关闭资源
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                out.println("<p style='color: red;'>关闭数据库连接失败: " + e.getMessage() + "</p>");
                e.printStackTrace();
            }
        }
    }
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>购物车</title>
    <style>
        .button {
            padding: 10px 15px;
            background-color: green;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .button:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>
<h1>购物车</h1>

<%
    if (cart.isEmpty()) {
%>
<p>购物车为空</p>
<h2>
    <a href="products.jsp" class="button">返回商品列表</a> <!-- 添加返回商品列表的链接 -->
</h2>
<%
    } else {
%>
<ul>
<%
    // 根据商品数量展示商品
    for (String item : productCountMap.keySet()) {
        int quantity = productCountMap.get(item); // 获取商品数量
        String imageUrl = productImageMap.get(item); // 获取商品图片URL
        double itemPrice = productPriceMap.get(item); // 获取商品单价
%>
    <li>
        <% if (imageUrl != null && !imageUrl.isEmpty()) { %>
            <img src="<%= request.getContextPath() + "/upload/img/" + imageUrl %>" alt="<%= item %>图片" style="width:100px;height:100px;"> <!-- 展示商品图片 -->
        <% } %>
        <%= item %> - 数量: <%= quantity %>
        - 单价: ￥<%= itemPrice %> <!-- 单价展示 -->
        - 总价: ￥<%= itemPrice * quantity %> <!-- 总价展示 -->
        <form action="removeFromCart" method="post" style="display:inline;">
            <input type="hidden" name="productNameToRemove" value="<%= item %>">
            <button type="submit" class="button" style="background-color: red;">删除</button> <!-- 删除按钮 -->
        </form>
    </li>
<%
    }
%>
</ul>
<h3>总金额: ￥<%= totalAmount %></h3>
<h2>
    <a href="products.jsp" class="button">返回商品列表</a>
    <a href="userCenter.jsp" class="button">返回个人中心</a>
    <a href="checkout.jsp" class="button">去结算</a> <!-- 跳转到结算页面 -->
</h2>
<form action="clearCart.jsp" method="post">
    <button type="submit" class="button">清空购物车</button> <!-- 清空购物车按钮 -->
</form>
<%
    }
%>
</body>
</html>
