<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>商家仪表板</title>
    <style>
        body {
            position: relative;
            margin: 0;
            color: white;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            overflow-y: hidden;
        }

        body::before {
            background-image: url('upload/img/merchant_bg.jpg');
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: cover;
            background-position: center;
            filter: blur(8px);
            z-index: -1;
            background-color: rgba(0, 0, 0, 0.5);
            overflow: hidden;
        }

        .content {
            position: relative;
            z-index: 1;
            max-height: 80vh;
            overflow-y: auto;
            padding: 20px;
            width: 100%;
            display: flex;
            justify-content: center;
        }

        .sidebar {
            width: 250px;
            margin-right: 20px;
            border: 1px solid #ccc;
            padding: 10px;
            float: left;
            color: black;
        }

        .sidebar h3 {
            margin-top: 0;
            color: black;
        }

        .sidebar a {
            display: block;
            padding: 8px;
            margin: 4px 0;
            text-decoration: none;
            color: black;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 4px;
        }

        .sidebar a:hover {
            background-color: #f1f1f1;
        }

        .button {
            color: black;
        }

        .product-list {
            height: 600px;
            overflow-y: auto;
            border: 1px solid #ccc;
            padding: 10px;
            width: 800px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        img {
            max-width: 100px;
            max-height: 100px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            padding: 10px;
            text-align: center;
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
        <a href="UserManagementServlet">用户管理</a>
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
                <td>
                    <a href="productDetail.jsp?id=<%= rs.getInt("id") %>">
                        <img src="<%= request.getContextPath() %>/upload/img/<%= rs.getString("image") %>" alt="商品图片">
                    </a>
                </td>
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
