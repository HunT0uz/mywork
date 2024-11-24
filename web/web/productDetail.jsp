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

        String sql = "SELECT name, price, type, image FROM products WHERE name = ?";
        PreparedStatement preparedStatement = connection.prepareStatement(sql);
        preparedStatement.setString(1, productName);

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            String name = resultSet.getString("name");
            double price = resultSet.getDouble("price");
            String type = resultSet.getString("type");
            String image = resultSet.getString("image");
%>
<html>
<head>
    <title><%= name %> - 商品详情</title>
</head>
<body>
<h1><%= name %></h1>
<p>价格: ￥<%= price %></p>
<p>类型: <%= type %></p>
<% if (image != null && !image.isEmpty()) { %>
<img src="<%= request.getContextPath() + "/upload/img/" + image %>" alt="<%= name %>图片">
<% } else { %>
<img src="<%= request.getContextPath() + "/upload/img/no-image.png" %>" alt="无图片">
<% } %>
<a href="products.jsp">返回商品列表</a>
</body>
</html>
<%
        } else {
            out.println("商品未找到！");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        if (connection != null) {
            try { connection.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>
