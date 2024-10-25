<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    List<String> productList = new ArrayList<>();
    Map<String, Double> products = new HashMap<>();

    String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    Connection connection = null;

    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        // 查询所有商品
        String sql = "SELECT name, price FROM products";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            productList.add(productName);
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
            }
        }
    }
    // 检查是否添加商品的提示
    String added = request.getParameter("added");
    String addedProduct = request.getParameter("product"); // 获取添加的商品名称
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>购物网站 - 商品列表</title>
    <style>
        .product {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            display: inline-block;
            text-align: center;
        }
        .button {
            padding: 5px 10px;
            background-color: green;
            color: white;
            text-decoration: none;
        }
    </style>
    <script>
        // 弹出添加成功提示
        <% if ("true".equals(added)) { %>
        alert("商品成功添加到购物车！");
        <% } %>
    </script>
</head>
<body>
<h1>欢迎来到购物网站</h1>
<div>
    <h2>商品列表</h2>
    <%
        for (String product : productList) {
            double price = products.get(product);
    %>
    <div class="product">
        <p><%= product %> - ￥<%= price %></p>
        <a href="addToCart.jsp?product=<%= product %>" class="button">添加到购物车</a>
    </div>
    <%
        }
    %>
</div>

<h2>
    <a href="cart.jsp" class="button">查看购物车</a>
    <a href="addProduct.jsp" class="button">添加/删除商品</a>
    <a href="userCenter.jsp" class="button">返回个人中心</a>
</h2>
</body>
</html>
