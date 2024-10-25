<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    List<String> productList = new ArrayList<>();
    Map<String, Double> products = new HashMap<>();
    Map<String, String> productImages = new HashMap<>(); // 用于存储商品图片
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
        String sql = "SELECT name, price,image FROM products";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            String productImage = resultSet.getString("image"); // 获取图片文件名
            productList.add(productName);
            products.put(productName, productPrice);
            productImages.put(productName, productImage); // 存储每个商品的图片
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
        /* 修改了商品排版 */
        .product {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            display: inline-block;
            text-align: center;
            width: 200px; /* 设置固定宽度 */
            height: 150px; /* 设置固定高度 */
            overflow: hidden; /* 隐藏多余的文字 */
            text-overflow: ellipsis; /* 使用省略号表示隐藏的文本 */
            white-space: nowrap; /* 不允许文本换行 */
        }
        .button {
            padding: 5px 10px;
            background-color: green;
            color: white;
            text-decoration: none;
        }
        .add-to-cart-button{
            padding: 5px 10px;
            background-color: green;
            color: white;
            text-decoration: none;
        }
        .delete-button {
            display: none; /* 默认不显示删除按钮 */
            padding: 5px 10px;
            background-color: red; /* 删除按钮颜色 */
            color: white;
            border: none;
            cursor: pointer;
        }
        .editing .delete-button {
            display: inline-block; /* 在编辑模式下显示删除按钮 */
        }
        .editing .add-to-cart-button {
            display: none; /* 在编辑模式下隐藏添加到购物车按钮 */
        }
        .button:hover,
        .add-to-cart-button:hover {
            background-color: darkgreen; /* 鼠标悬停时的背景颜色 */
            opacity: 0.7; /* 悬停时的透明度（可选） */
        }
        .delete-button:hover{
            background-color: darkred; /* 鼠标悬停时的背景颜色 */
            opacity: 0.7; /* 悬停时的透明度（可选） */
        }
        .product img {
            width: 40%; /* 设置图片宽度为父元素的 100% */
            height: 50px; /* 固定高度 */
            object-fit: cover; /* 涵盖内容，裁剪多余部分 */
        }
    </style>
    <script>
        function toggleEditMode() {
            const productsDiv = document.getElementById('products');
            productsDiv.classList.toggle('editing'); // 切换编辑模式
        }
    </script>
    <script>
        // 弹出添加成功提示
        <% if ("true".equals(added)) { %>
        <p className="success-message">商品成功添加到购物车！</p>
        <% } %>
    </script>
</head>
<body>
<h1>欢迎来到购物网站</h1>
<div id="products">
    <h2>商品列表</h2>

    <%
        for (String product : productList) {
            double price = products.get(product);
            String image = productImages.get(product); // 获取对应的图片文件名
    %>
    <div class="product">
        <% if (image != null && !image.isEmpty()) { %>
        <img src="<%= request.getContextPath() + "/upload/img/" + image %>" alt="<%= product %>图片" style="max-width: 100%; max-height: 100px;">
        <% } else { %>
        <img src="<%= request.getContextPath() + "/upload/img/no-image.png" %>" alt="无图片" style="max-width: 100%; max-height: 100px;"> <!-- 默认无图片 -->
        <% } %>
        <p><%= product %> - ￥<%= price %></p>
        <a href="addToCart.jsp?product=<%= product %>" class="add-to-cart-button">添加到购物车</a>
        <!-- 在编辑模式下，每个商品获得删除按钮 -->
        <form action="deleteProduct" method="post" class="delete-button">
            <input type="hidden" name="productNameToDelete" value="<%= product %>">
            <button type="submit" class="delete-button" >删除</button>
        </form>
    </div>
    <%
        }
    %>
</div>

<h2>
    <a href="cart.jsp" class="button">查看购物车</a>
    <a href="addProduct.jsp" class="button">添加/删除商品</a>
    <a href="userCenter.jsp" class="button">返回个人中心</a>
    <button onclick="toggleEditMode()" class="button">编辑</button> <!-- 添加编辑按钮 -->
</h2>
</body>
</html>
