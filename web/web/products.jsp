<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 从 session 中获取商家用户名
<<<<<<< Updated upstream

=======
>>>>>>> Stashed changes
    String merchantUsername = (String) session.getAttribute("merchantUsername");
    List<String> productList = new ArrayList<>();
    Map<String, Double> products = new HashMap<>();
    Map<String, String> productImages = new HashMap<>(); // 用于存储商品图片
<<<<<<< Updated upstream
=======
    Map<String, String> productTypes = new HashMap<>(); // 用于存储商品类型
>>>>>>> Stashed changes
    String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    Connection connection = null;

<<<<<<< Updated upstream
=======
    // 获取搜索关键字和商家名称
    String searchKeyword = request.getParameter("search"); // 从请求中获取搜索关键词
    String searchType = request.getParameter("type"); // 从请求中获取商品类型
    String merchantName = request.getParameter("merchant"); // 从请求中获取商家名称
    String searchMode = request.getParameter("searchMode"); // 获取搜索模式

>>>>>>> Stashed changes
    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

<<<<<<< Updated upstream
        // 查询所有商品
        String sql = "SELECT name, price,image FROM products";
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
=======
        // 查询所有商品或根据搜索关键词查询商品
        StringBuilder sql = new StringBuilder("SELECT name, type, price, image FROM products WHERE 1=1");

        // 动态添加查询条件
        if ("productName".equals(searchMode) && searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        } else if ("merchantName".equals(searchMode) && merchantName != null && !merchantName.isEmpty()) {
            sql.append(" AND merchant_name LIKE ?"); // 确保表中有merchantName字段
        }

        if (searchType != null && !searchType.isEmpty()) {
            sql.append(" AND type = ?");
        }

        PreparedStatement preparedStatement = connection.prepareStatement(sql.toString());

        int paramIndex = 1;
        if ("productName".equals(searchMode) && searchKeyword != null && !searchKeyword.isEmpty()) {
            preparedStatement.setString(paramIndex++, "%" + searchKeyword + "%"); // 设置商品名称模糊匹配
        } else if ("merchantName".equals(searchMode) && merchantName != null && !merchantName.isEmpty()) {
            preparedStatement.setString(paramIndex++, "%" + merchantName + "%"); // 设置商家名称模糊匹配
        }

        if (searchType != null && !searchType.isEmpty()) {
            preparedStatement.setString(paramIndex++, searchType); // 设置商品类型精确匹配
        }

        ResultSet resultSet = preparedStatement.executeQuery();
>>>>>>> Stashed changes

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            String productImage = resultSet.getString("image"); // 获取图片文件名
<<<<<<< Updated upstream
            productList.add(productName);
            products.put(productName, productPrice);
            productImages.put(productName, productImage); // 存储每个商品的图片
=======
            String productType = resultSet.getString("type"); // 获取商品类型
            productList.add(productName);
            products.put(productName, productPrice);
            productImages.put(productName, productImage); // 存储每个商品的图片
            productTypes.put(productName, productType); // 存储每个商品的类型
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
    // 检查是否添加商品的提示
    String added = request.getParameter("added");
    String addedProduct = request.getParameter("product"); // 获取添加的商品名称

%>
=======

    // 检查是否添加商品的提示
    String added = request.getParameter("added");
%>

>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
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
=======
            height: auto; /* 自适应高度 */
            overflow: hidden; /* 隐藏多余的文字 */
        }

        .button, .add-to-cart-button {
            display: block; /* 使按钮成为块级元素 */
            padding: 5px 10px;
            margin: 5px 0; /* 在按钮间添加上下间距 */
            background-color: green;
            color: white;
            text-decoration: none;
            text-align: center; /* 水平居中 */
            border: none; /* 移除边框 */
            cursor: pointer; /* 鼠标指针 */
        }

        .button:hover,
        .add-to-cart-button:hover {
            background-color: darkgreen; /* 鼠标悬停效果 */
            opacity: 0.8; /* 悬停时的透明度 */
        }

        .product img {
            max-width: 100%; /* 自适应宽度 */
            height: auto; /* 自适应高度 */
            max-height: 150px; /* 最大高度 */
            object-fit: cover; /* 保持比例覆盖 */
        }

        .search-container {
            display: none; /* 默认隐藏搜索容器 */
        }

        /* 下拉菜单样式 */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f9f9f9;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
            z-index: 1;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown-content a:hover {
            background-color: #f1f1f1;
        }

        .dropdown:hover .dropdown-content {
            display: block; /* 鼠标悬停时显示 */
        }
    </style>
    <script>
        function switchSearchMode(mode) {
            document.getElementById("productSearch").style.display = mode === 'productName' ? 'block' : 'none';
            document.getElementById("merchantSearch").style.display = mode === 'merchantName' ? 'block' : 'none';
        }

        // 弹出添加成功提示
        <% if ("true".equals(added)) { %>
        alert("商品成功添加到购物车！");
>>>>>>> Stashed changes
        <% } %>
    </script>
</head>
<body>
<h1>欢迎来到购物网站</h1>
<<<<<<< Updated upstream
<div id="products">
    <h2>商品列表</h2>

=======
<div>
    <button onclick="switchSearchMode('productName')">按名称搜索</button>
    <button onclick="switchSearchMode('merchantName')">按商家搜索</button>
</div>

<div id="search">
    <!-- 产品名称搜索 -->
    <div id="productSearch" class="search-container">
        <form action="products.jsp" method="get">
            <input type="hidden" name="searchMode" value="productName">
            <input type="text" name="search" placeholder="请输入商品名称"
                   value="<%= searchKeyword != null ? searchKeyword : "" %>" style="width: 300px; height: 40px; font-size: 16px;">
            <select name="type">
                <option value="">选择商品类型</option>
                <optgroup label="电子产品">
                    <option value="手机与通讯">手机与通讯</option>
                    <option value="电脑与办公">电脑与办公</option>
                    <option value="相机与摄影">相机与摄影</option>
                    <option value="影音娱乐">影音娱乐</option>
                    <option value="智能穿戴">智能穿戴</option>
                    <option value="游戏与电竞">游戏与电竞</option>
                </optgroup>
                <optgroup label="服装鞋帽">
                    <option value="男装">男装</option>
                    <option value="女装">女装</option>
                    <option value="童装">童装</option>
                    <option value="内衣">内衣</option>
                    <option value="鞋靴">鞋靴</option>
                    <option value="箱包">箱包</option>
                </optgroup>
                <!-- 其他商品类型 -->
            </select>
            <input type="submit" value="搜索" style="height: 40px; font-size: 16px;">
        </form>
    </div>

    <!-- 商家名称搜索 -->
    <div id="merchantSearch" class="search-container">
        <form action="products.jsp" method="get">
            <input type="hidden" name="searchMode" value="merchantName">
            <input type="text" name="merchant" placeholder="请输入商家名称"
                   value="<%= merchantName != null ? merchantName : "" %>" style="width: 300px; height: 40px; font-size: 16px;">
            <input type="submit" value="搜索" style="height: 40px; font-size: 16px;">
        </form>
    </div>
</div>

<!-- 右上角下拉菜单 -->
<div style="float: left; position: relative; margin: 10px;">
    <div class="dropdown">
        <button class="dropbtn">个人中心</button>
        <div class="dropdown-content">
            <a href="cart.jsp">查看购物车</a>
            <a href="userCenter.jsp">返回个人中心</a>
            <% if ("adminis".equals(merchantUsername)) { %>
            <a href="addProduct.jsp">添加/删除商品</a>
            <% } %>
            <% if (merchantUsername != null) { %>
            <a href="merchantDashboard.jsp">返回商家中心</a>
            <% } %>
        </div>
    </div>
</div>

<div id="products">
    <h2>商品列表</h2>
>>>>>>> Stashed changes
    <%
        for (String product : productList) {
            double price = products.get(product);
            String image = productImages.get(product); // 获取对应的图片文件名
<<<<<<< Updated upstream
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
=======
            String type = productTypes.get(product); // 获取商品类型
    %>
    <div class="product">
    <% if (image != null && !image.isEmpty()) { %>
    <img src="<%= request.getContextPath() + "/upload/img/" + image %>" alt="<%= product %>图片">
    <% } else { %>
    <img src="<%= request.getContextPath() + "/upload/img/no-image.png" %>" alt="无图片"> <!-- 默认无图片 -->
    <% } %>
    <p><strong><%= product %></strong></p> <!-- 显示商品名称 -->
    <p>类型: <%= type %></p> <!-- 显示商品类型 -->
    <p>价格: ￥<%= price %></p> <!-- 显示商品价格 -->
    <a href="productDetail.jsp?product=<%= product %>" class="button">查看详情</a>
    <a href="addToCart.jsp?product=<%= product %>" class="add-to-cart-button">添加到购物车</a>
</div>

>>>>>>> Stashed changes
    <%
        }
    %>
</div>

<<<<<<< Updated upstream
<h2>
    <a href="cart.jsp" class="button">查看购物车</a>
    <% if (merchantUsername == "adminis") { %>
    <a href="addProduct.jsp" class="button">添加/删除商品</a>
    <button onclick="toggleEditMode()" class="button">编辑</button> <!-- 仅管理者可以看到 -->
    <% } %>
    <% if (merchantUsername != null) { %>
    <a href="merchantDashboard.jsp" class="button">返回商家中心</a>
    <% } %>
    <a href="userCenter.jsp" class="button">返回个人中心</a>

</h2>
=======
<script>
    // 默认显示产品搜索框
    switchSearchMode('productName');
</script>

>>>>>>> Stashed changes
</body>
</html>
