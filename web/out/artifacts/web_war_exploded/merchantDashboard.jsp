<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
    <title>商家仪表板</title>
</head>
<body>

<%
    session = request.getSession();
    String merchantUsername = (String) session.getAttribute("merchantUsername");
    if (merchantUsername == null) {
        // 如果商家用户名为 null，重定向到登录页面
        response.sendRedirect("merchantLogin.jsp");
        return; // 终止后续代码执行
    }
%>

<h2>欢迎，<%= merchantUsername %>!</h2>

<h3>商品管理</h3>

<!-- 添加商品表单 -->
<form action="merchantDashboard" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">
    <label for="productName">商品名称:</label>
    <input type="text" id="productName" name="productName" required>

    <label for="productPrice">商品价格:</label>
    <input type="text" id="productPrice" name="productPrice" required>
    <input type="file" id="productImage" name="productImage" accept="image/*" onchange="showFileName(this)" required><br>
    <img id="showimg" src="" alt="上传的图片"><br>
    <button type="submit">添加商品</button>
</form>

<!-- 上传图片表单 -->
<script>
    function showFileName(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.getElementById('showimg');
                img.src = e.target.result;
                img.style.width = '100px'; // 设置图片预览大小
                img.style.height = '100px';
            };
            reader.readAsDataURL(input.files[0]); // 读取文件并生成预览

            document.getElementById('showimg').src = "";
        }
    }
</script>
<!-- 商品列表 -->
<h3>现有商品</h3>
<table border="1">
    <tr>
        <th>商品ID</th>
        <th>商品名称</th>
        <th>商品价格</th>
        <th>操作</th>
    </tr>
    <%
        Connection conn = null;
        try {
            String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 确保数据库为 marchat
            conn = DriverManager.getConnection(jdbcUrl, "root", "1234");
            String sql = "SELECT * FROM products WHERE merchant_name = ?"; // SQL 查询使用 merchant_username
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, merchantUsername); // 使用 session 中的商家名
            ResultSet rs = pstmt.executeQuery();
            while(rs.next()) {
    %>
    <tr>
        <td><%= rs.getInt("id") %></td>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getDouble("price") %></td>
        <td>
            <form action="merchantDashboard" method="get" style="display:inline;">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                <input type="submit" value="删除">
            </form>
            <form action="merchantDashboard" method="get" style="display:inline;">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                <label for="productName">新名称:</label>
                <input type="text" name="productName" required>
                <label for="productPrice">新价格:</label>
                <input type="text" name="productPrice" required>
                <input type="submit" value="更新">
            </form>
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
<h2><a href="products.jsp" class="button">返回商品列表</a></h2>
</body>
</html>
