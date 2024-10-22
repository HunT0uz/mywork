<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String message = ""; // 用于存储反馈信息
    if (request.getMethod().equalsIgnoreCase("POST")) {

        // 添加商品逻辑
        if (request.getParameter("action").equals("addProduct")) {
            String productName = request.getParameter("productName");
            double productPrice = Double.parseDouble(request.getParameter("productPrice"));

            String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
            String username = "root"; // 数据库用户
            String password = "1234"; // 数据库密码

            Connection connection = null;

            try {
                // 加载 JDBC 驱动程序
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 建立连接
                connection = DriverManager.getConnection(jdbcUrl, username, password);

                // 插入商品信息
                String sql = "INSERT INTO products (name, price) VALUES (?, ?)";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, productName);
                preparedStatement.setDouble(2, productPrice);
                int rowsAffected = preparedStatement.executeUpdate();

                if (rowsAffected > 0) {
                    message = "商品添加成功！";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "错误: " + e.getMessage();
            } catch (ClassNotFoundException e) {
                message = "驱动程序未找到: " + e.getMessage();
            } finally {
                // 关闭资源
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) {
                    }
                }
            }
        }

        // 删除商品逻辑
        else if (request.getParameter("action").equals("deleteProduct")) {
            String productNameToDelete = request.getParameter("productNameToDelete");

            String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
            String username = "root"; // 数据库用户
            String password = "1234"; // 数据库密码

            Connection connection = null;

            try {
                // 加载 JDBC 驱动程序
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 建立连接
                connection = DriverManager.getConnection(jdbcUrl, username, password);

                // 删除商品信息
                String sql = "DELETE FROM products WHERE name = ?";
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, productNameToDelete);
                int rowsAffected = preparedStatement.executeUpdate();

                if (rowsAffected > 0) {
                    message = "商品删除成功！";
                } else {
                    message = "没有找到该商品！";
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "错误: " + e.getMessage();
            } catch (ClassNotFoundException e) {
                message = "驱动程序未找到: " + e.getMessage();
            } finally {
                // 关闭资源
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) {
                    }
                }
            }
        }
    }
%>
<html>
<head>
    <title>添加/删除商品</title>
</head>
<body>
<h1>添加/删除商品</h1>
<p><%= message %></p>

<!-- 添加商品表单 -->
<form action="addProduct.jsp" method="post">
    <input type="hidden" name="action" value="addProduct">
    <label for="productName">商品名称:</label>
    <input type="text" id="productName" name="productName" required><br>
    <label for="productPrice">商品价格:</label>
    <input type="number" id="productPrice" name="productPrice" step="0.01" required><br>
    <button type="submit">添加商品</button>
</form>

<!-- 删除商品表单 -->
<form action="addProduct.jsp" method="post">
    <input type="hidden" name="action" value="deleteProduct">
    <label for="productNameToDelete">删除商品名称:</label>
    <input type="text" id="productNameToDelete" name="productNameToDelete" required><br>
    <button type="submit">删除商品</button>
</form>
<h3>
<a href="products.jsp" class="button">查看商品</a>
</h3>
</body>
</html>
