<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 从 session 中获取商家用户名
    String merchantUsername = (String) session.getAttribute("merchantUsername");
    String username = (String) session.getAttribute("username");

    // 连接数据库获取商品列表
    List<String> productList = new ArrayList<>();
    Map<String, Double> products = new HashMap<>();
    Map<String, String> productImages = new HashMap<>(); // 用于存储商品图片
    Map<String, String> productTypes = new HashMap<>(); // 用于存储商品类型

    String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    Connection connection = null;

    // 获取搜索关键字和商家名称
    String searchKeyword = request.getParameter("search"); // 从请求中获取搜索关键词
    String searchType = request.getParameter("type"); // 从请求中获取商品类型
    String merchantName = request.getParameter("merchant"); // 从请求中获取商家名称
    String searchMode = request.getParameter("searchMode"); // 获取搜索模式

    // 数据分页相关参数
    int pageSize = 15; // 每页显示的商品数量
    int pageIndex = 1; // 当前页码
    String pageIndexParam = request.getParameter("pageIndex");
    if (pageIndexParam != null) {
        try {
            pageIndex = Integer.parseInt(pageIndexParam);
        } catch (NumberFormatException e) {
            pageIndex = 1;
        }
    }

    int totalPages = 0;
    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        // 查询所有商品或根据搜索关键词查询商品
        StringBuilder sql = new StringBuilder("SELECT name, type, price, image FROM products WHERE 1=1");

        // 动态添加查询条件
        if ("productName".equals(searchMode) && searchKeyword != null && !searchKeyword.isEmpty()) {
            sql.append(" AND name LIKE ?");
        } else if ("merchantName".equals(searchMode) && merchantName != null && !merchantName.isEmpty()) {
            sql.append(" AND merchant_name LIKE ?"); // 确保表中有 merchantName 字段
        }

        // 添加商品类型的查询条件
        if (searchType != null && !searchType.isEmpty()) {
            sql.append(" AND type = ?");
        }

        // 添加随机排序与分页
        sql.append(" ORDER BY RAND() LIMIT ? OFFSET ?");

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

        preparedStatement.setInt(paramIndex++, pageSize); // 设置每页数量
        preparedStatement.setInt(paramIndex++, (pageIndex - 1) * pageSize); // 设置偏移量


        ResultSet resultSet = preparedStatement.executeQuery();

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            String productImage = resultSet.getString("image"); // 获取图片文件名
            String productType = resultSet.getString("type"); // 获取商品类型
            productList.add(productName);
            products.put(productName, productPrice);
            productImages.put(productName, productImage); // 存储每个商品的图片
            productTypes.put(productName, productType); // 存储每个商品的类型
        }

        // 获取总商品数量以计算总页数
        String countSql = "SELECT COUNT(*) FROM products WHERE 1=1";
        PreparedStatement countStatement = connection.prepareStatement(countSql);

        // 添加之前的查询条件
        int countParamIndex = 1;
        if ("productName".equals(searchMode) && searchKeyword != null && !searchKeyword.isEmpty()) {
            countStatement.setString(countParamIndex++, "%" + searchKeyword + "%");
        } else if ("merchantName".equals(searchMode) && merchantName != null && !merchantName.isEmpty()) {
            countStatement.setString(countParamIndex++, "%" + merchantName + "%");
        }

        if (searchType != null && !searchType.isEmpty()) {
            countStatement.setString(countParamIndex++, searchType);
        }

        ResultSet countResultSet = countStatement.executeQuery();
        int totalProducts = 0;
        if (countResultSet.next()) {
            totalProducts = countResultSet.getInt(1);
        }
        totalPages = (int) Math.ceil((double) totalProducts / pageSize);

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
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>购物网站 - 商品列表</title>
    <style>
        body {
            position: relative; /* 设置相对定位以便使用伪元素 */
            margin: 0;
            color: white; /* 默认文字颜色设置为白色 */
            min-height: 100vh; /* 最小高度为100%视口高度 */
            display: flex; /* 使用 flex 布局 */
            flex-direction: column; /* 垂直排列 */
            overflow-y: hidden;
        }

        body::before {
            content: ""; /* 伪元素内容为空 */
            position: absolute; /* 绝对定位 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('upload/img/product_bg.jpg'); /* 替换为你的背景图片路径 */
            background-size: cover; /* 背景图片覆盖 */
            background-position: center; /* 背景图片居中 */
            filter: blur(8px); /* 设置背景虚化效果 */
            z-index: -1; /* 设置较低层级 */
            background-color: rgba(0, 0, 0, 0.5); /* 添加黑色覆盖层 */
        }

        .content { /* 包裹内容的容器 */
            position: relative; /* 设置内容层相对定位 */
            z-index: 1; /* 确保内容层在背景之上 */
            max-height: 80vh; /* 设置最大高度为 80% 视口高度 */
            overflow-y: auto; /* 内容溢出时显示垂直滚动条 */
            padding: 20px; /* 添加内边距 */
        }

        /* 修改了商品排版 */
        .product {
            border: 1px solid #ddd;
            padding: 10px;
            margin: 10px;
            display: inline-block;
            text-align: center;
            width: 200px; /* 设置固定宽度 */
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
        .add-to-cart-button.disabled {
            background-color: gray; /* 禁用状态的背景颜色 */
            cursor: not-allowed; /* 鼠标样式 */
            pointer-events: none; /* 禁止点击 */
            text-decoration: line-through; /* 删除线效果 */
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

        /* 分页样式 */
        .pagination {
            margin: 20px 0;
            text-align: center;
        }

        .pagination a {
            margin: 0 5px;
            text-decoration: none;
            padding: 5px 10px;
            border: 1px solid #ddd;
        }

        .pagination a.active {
            background-color: green;
            color: white;
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
        <% } %>
    </script>
</head>
<body>
<div class="content"> <!-- 添加内容层 -->
    <h1>欢迎来到购物网站</h1>
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
                       value="<%=searchKeyword != null ? searchKeyword : ""%>" style="width: 300px; height: 40px; font-size: 16px;">
                <select name="type" style="height: 30px; overflow: auto;">
                    <!-- 商品类型选项 -->
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
                    <optgroup label="家居生活">
                        <option value="家具">家具</option>
                        <option value="家纺">家纺</option>
                        <option value="家装建材">家装建材</option>
                        <option value="厨房用具">厨房用具</option>
                        <option value="清洁用品">清洁用品</option>
                        <option value="宠物用品">宠物用品</option>
                        <option value="美妆个护">美妆个护</option>
                    </optgroup>
                    <optgroup label="食品饮料">
                        <option value="休闲零食">休闲零食</option>
                        <option value="粮油调味">粮油调味</option>
                        <option value="饮料冲调">饮料冲调</option>
                        <option value="乳品烘焙">乳品烘焙</option>
                        <option value="酒类">酒类</option>
                        <option value="保健食品">保健食品</option>
                        <option value="母婴用品">母婴用品</option>
                    </optgroup>
                    <optgroup label="图书音像">
                        <option value="图书">图书</option>
                        <option value="电子书">电子书</option>
                        <option value="音像制品">音像制品</option>
                        <option value="教育软件">教育软件</option>
                    </optgroup>
                    <optgroup label="运动户外">
                        <option value="运动服饰">运动服饰</option>
                        <option value="运动装备">运动装备</option>
                        <option value="健身器材">健身器材</option>
                        <option value="户外装备">户外装备</option>
                        <option value="自行车与骑行">自行车与骑行</option>
                        <option value="垂钓用品">垂钓用品</option>
                        <option value="汽车用品">汽车用品</option>
                    </optgroup>
                    <optgroup label="汽车服务">
                        <option value="汽车装饰">汽车装饰</option>
                        <option value="车载电器">车载电器</option>
                        <option value="维修保养">维修保养</option>
                        <option value="汽车配件">汽车配件</option>
                        <option value="汽车服务">汽车服务</option>
                    </optgroup>
                    <optgroup label="珠宝配饰">
                        <option value="珠宝首饰">珠宝首饰</option>
                        <option value="手表">手表</option>
                        <option value="眼镜">眼镜</option>
                        <option value="帽子围巾">帽子围巾</option>
                        <option value="腰带">腰带</option>
                    </optgroup>
                    <optgroup label="玩具乐器">
                        <option value="儿童玩具">儿童玩具</option>
                        <option value="模型玩具">模型玩具</option>
                        <option value="乐器">乐器</option>
                    </optgroup>
                    <optgroup label="医疗保健">
                        <option value="医疗器械">医疗器械</option>
                        <option value="中西药品">中西药品</option>
                        <option value="保健滋补品">保健滋补品</option>
                    </optgroup>
                    <optgroup label="旅行度假">
                        <option value="旅行装备">旅行装备</option>
                        <option value="酒店预订">酒店预订</option>
                        <option value="景点门票">景点门票</option>
                        <option value="旅游服务">旅游服务</option>
                    </optgroup>
                    <optgroup label="其他">
                        <option value="其他">其他</option>
                    </optgroup>
                </select>
                <input type="submit" value="搜索" style="height: 40px; font-size: 16px;">
            </form>
        </div>

        <!-- 商家名称搜索 -->
        <div id="merchantSearch" class="search-container">
            <form action="products.jsp" method="get">
                <input type="hidden" name="searchMode" value="merchantName">
                <input type="text" name="merchant" placeholder="请输入商家名称"
                       value="<%=merchantName != null ? merchantName : ""%>" style="width: 300px; height: 40px; font-size: 16px;">
                <input type="submit" value="搜索" style="height: 40px; font-size: 16px;">
            </form>
        </div>
    </div>

    <div id="joke">
        <%
            connection = null;
            String jokeText = ""; // 用于存储笑话文本

            try {
                // 加载 JDBC 驱动程序
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 建立连接
                connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

                // 创建一个 Statement 对象来执行 SQL 查询
                Statement statement = connection.createStatement();
                ResultSet resultSet = statement.executeQuery("SELECT * FROM jokes ORDER BY RAND() LIMIT 1");

                if (resultSet.next()) {
                    jokeText = resultSet.getString("content"); // 假设笑话文本存储在名为 content 的列
                }

            } catch (SQLException e) {
                e.printStackTrace();
                out.println("SQL错误: " + e.getMessage());
            } catch (ClassNotFoundException e) {
                out.println("驱动程序未找到: " + e.getMessage());
            } finally {
                // 关闭资源
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) {
                    }
                }
            }
            out.println("<p>" + jokeText + "</p>");
        %>
    </div>

    <!-- 右上角下拉菜单 -->
<div style="float: left; position: relative; margin: 10px;">
    <div class="dropdown">
        <button class="dropbtn">个人中心</button>
        <div class="dropdown-content">
            <% if (merchantUsername == null && username == null) { %>
                <a href="login.jsp">登录</a> <!-- 添加登录按钮 -->
            <% } else { %>
                <% if (merchantUsername == null) { %> <!-- 只有普通用户才能看到购物车和订单 -->
                    <a href="cart.jsp">查看购物车</a>
                    <a href="orderManagement">查看订单</a>
                <% } %>
                <a href="userCenter.jsp">个人中心</a>
                <a href="logout.jsp">退出登录</a>
                <% if ("adminis".equals(merchantUsername)) { %>
                    <a href="addProduct.jsp">添加/删除商品</a>
                <% } %>
                <% if (merchantUsername != null) { %>
                    <a href="merchantDashboard.jsp">返回商家中心</a>
                <% } %>
            <% } %>
        </div>
    </div>
</div>


    <div id="products">
        <h2>商品列表</h2>
        <%
            for (String product : productList) {
                double price = products.get(product);
                String image = productImages.get(product); // 获取对应的图片文件名
                String type = productTypes.get(product); // 获取商品类型
        %>
        <div class="product">
            <% if (image != null && !image.isEmpty()) { %>
            <img src="<%=request.getContextPath() + "/upload/img/" + image%>" alt="<%=product%>图片">
            <% } else { %>
            <img src="<%=request.getContextPath() + "/upload/img/no-image.png"%>" alt="无图片"> <!-- 默认无图片 -->
            <% } %>
            <p><strong><%=product%></strong></p> <!-- 显示商品名称 -->
            <p>类型: <%=type%></p> <!-- 显示商品类型 -->
            <p>价格: ￥<%=price%></p> <!-- 显示商品价格 -->
            <a href="productDetail.jsp?product=<%=product%>" class="button">查看详情</a>
            <% if (merchantUsername == null) { %>
            <a href="addToCart.jsp?product=<%=product%>" class="add-to-cart-button">添加到购物车</a>
            <% } else { %>
            <span class="add-to-cart-button disabled">无法添加到购物车</span>
            <% } %>
        </div>
        <%
            }
        %>
    </div>

    <div class="pagination">
        <% for (int i = 1; i <= totalPages; i++) { %>
            <a href="products.jsp?pageIndex=<%=i%>&search=<%=searchKeyword != null ? searchKeyword : ""%>&type=<%=searchType != null ? searchType : ""%>&merchant=<%=merchantName != null ? merchantName : ""%>"
               class="<%=(i == pageIndex) ? "active" : ""%>"><%=i%></a>
        <% } %>
    </div>

    <script>
        switchSearchMode('productName');
    </script>
</div> <!-- 结束内容层 -->
</body>
</html>
