<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 商品价格映射
    HashMap<String, Double> products = new HashMap<>();

    // 数据库连接
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
    String username = "root"; // 数据库用户
    String password = "1234"; // 数据库密码

    Connection connection = null;

    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // 查询所有商品的价格
        String sql = "SELECT name, price FROM products";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            products.put(productName, productPrice);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        // 关闭资源
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 获取购物车商品
    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }

    double totalAmount = 0; // 总金额
    for (String item : cart) {
        totalAmount += products.getOrDefault(item, 0.0); // 使用默认值处理商品未找到的情况
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>结算页面</title>
</head>
<body>
<h1>订单确认</h1>
<%
    if (cart.isEmpty()) {
%>
<p>购物车为空，无法结算。</p>
<%
} else {
%>
<ul>
    <%
        for (String item : cart) {
    %>
    <li><%= item %> - ￥<%= products.getOrDefault(item, 0.0) %></li>
    <%
        }
    %>
</ul>
<h3>总金额: ￥<%= totalAmount %></h3>
<button onclick="alert('结算功能待开发！')">确认结算</button>
<%
    }
%>
<h2>
    <a href="cart.jsp" class="button">返回购物车</a>
    <a href="products.jsp" class="button">返回商品列表</a>
</h2>
</body>
</html>
