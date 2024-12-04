<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/11/25
  Time: 下午2:54
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<html>
<head>
    <title>修改商品</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        h3 {
            color: #343a40;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        th, td {
            padding: 12px;
            text-align: left;
            border: 1px solid #dee2e6;
        }
        th {
            background-color: #6c757d;
            color: white;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .form-inline {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .preview {
            max-width: 200px;
            height: auto;
            margin-top: 10px;
        }
        .scrollable-table {
            max-height: 600px;
            overflow-y: auto;
            display: block;
        }
        /* 模态框样式 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.8);
            padding-top: 60px;
        }
        .modal-content {
            background-color: #ffffff;
            margin: 5% auto;
            padding: 20px;
            border-radius: 8px; /* 圆角 */
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2); /* 阴影效果 */
            width: 80%;
            max-width: 500px; /* 最大宽度 */
        }
        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }
        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        label {
            display: block;
            margin-top: 10px; /* 标签上间距 */
        }
        input[type="text"], input[type="file"], select {
            width: calc(100% - 20px); /* 计算输入框宽度 */
            padding: 10px; /* 输入框内边距 */
            border: 1px solid #ccc;
            border-radius: 4px; /* 圆角边框 */
        }
        input[type="submit"] {
            background-color: #28a745; /* 提交按钮颜色 */
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 10px;
        }
        input[type="submit"]:hover {
            background-color: #218838; /* 提交按钮悬停颜色 */
        }
    </style>
    <script>
        function openModal(productId, name, price, type, image, description) {
            document.getElementById("modal").style.display = "block";
            document.getElementById("modalProductId").value = productId;
            document.getElementById("modalProductName").value = name;
            document.getElementById("modalProductPrice").value = price;
            document.getElementById("modalProductType").value = type;
            document.getElementById("modalProductDescription").value = description; // 设置简介
            document.getElementById("modalImagePreview").src = image ? '/upload/img/' + image : '/upload/img/no-image.png';
        }

        function closeModal() {
            document.getElementById("modal").style.display = "none";
        }

        window.onclick = function(event) {
            var modal = document.getElementById("modal");
            if (event.target == modal) {
                closeModal();
            }
        }

        function previewImage(input) {
            const preview = document.getElementById("modalImagePreview");
            const file = input.files[0];
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
            }

            if (file) {
                reader.readAsDataURL(file);
            } else {
                preview.src = "";
            }
        }
    </script>
</head>
<body>
<h3>现有商品</h3>
<div class="scrollable-table">
    <table>
        <tr>
            <th>商品ID</th>
            <th>商品图片</th>
            <th>商品名称</th>
            <th>商品价格</th>
            <th>商品类型</th>
            <th>操作</th>
        </tr>
        <%
            session = request.getSession();
            String merchantUsername = (String) session.getAttribute("merchantUsername");
            if (merchantUsername == null) {
                response.sendRedirect("merchantLogin.jsp");
                return;
            } else {
                Connection conn = null;
                try {
                    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
                    conn = DriverManager.getConnection(jdbcUrl, "root", "1234");

                    int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
                    int limit = 5;
                    int offset = (currentPage - 1) * limit;

                    String countSql = "SELECT COUNT(*) FROM products WHERE merchant_name = ?";
                    PreparedStatement countPstmt = conn.prepareStatement(countSql);
                    countPstmt.setString(1, merchantUsername);
                    ResultSet countRs = countPstmt.executeQuery();
                    int totalCount = 0;
                    if (countRs.next()) {
                        totalCount = countRs.getInt(1);
                    }
                    countRs.close();
                    countPstmt.close();

                    String sql = "SELECT * FROM products WHERE merchant_name = ? LIMIT ? OFFSET ?";
                    PreparedStatement pstmt = conn.prepareStatement(sql);
                    pstmt.setString(1, merchantUsername);
                    pstmt.setInt(2, limit);
                    pstmt.setInt(3, offset);
                    ResultSet rs = pstmt.executeQuery();

                    while (rs.next()) {
                        String name = rs.getString("name");
                        double price = rs.getDouble("price");
                        String type = rs.getString("type");
                        String image = rs.getString("image");
                        String description = rs.getString("description"); // 获取简介
        %>
        <tr>
            <td><%= rs.getInt("id") %></td>
            <td>
                <% if (image != null && !image.isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/upload/img/" + image %>" alt="<%= name %>图片" style="max-width: 200px; height: auto;">
                <% } else { %>
                    <img src="<%= request.getContextPath() + "/upload/img/no-image.png" %>" alt="无图片" style="max-width: 200px; height: auto;">
                <% } %>
            </td>
            <td><%= name %></td>
            <td><%= price %></td>
            <td><%= type %></td>
            <td>
                <button onclick="openModal('<%= rs.getInt("id") %>', '<%= name %>', '<%= price %>', '<%= type %>', '<%= image %>', '<%= description %>')">修改</button>
                <form action="merchantDashboard" method="post" enctype="multipart/form-data" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="productId" value="<%= rs.getInt("id") %>">
                    <input type="submit" value="删除">
                </form>
            </td>
        </tr>
        <%
                    }
                    rs.close();
                    pstmt.close();

                    int totalPages = (int) Math.ceil((double) totalCount / limit);
        %>
    </table>
</div>

<div>
    <%
        if (currentPage > 1) {
    %>
        <a href="?page=<%= currentPage - 1 %>">上一页</a>
    <%
        }
        if (currentPage < totalPages) {
    %>
        <a href="?page=<%= currentPage + 1 %>">下一页</a>
    <%
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }}
    %>
</div>

<!-- 模态框 -->
<div id="modal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <form action="merchantDashboard" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" id="modalProductId" name="productId">
            <label for="modalProductName">新名称:</label>
            <input type="text" id="modalProductName" name="productName" required>
            <label for="modalProductPrice">新价格:</label>
            <input type="text" id="modalProductPrice" name="productPrice" required>
            <label for="modalProductType">新类型:</label>
            <select id="modalProductType" name="productType" required>
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
            <label for="modalProductDescription">简介:</label>
            <input type="text" id="modalProductDescription" name="productDescription" required>
            <label for="modalProductImage">新图片 (可选):</label>
            <input type="file" name="productImage" accept="image/*" onchange="previewImage(this)">
            <img id="modalImagePreview" class="preview" style="display:block; max-width: 200px; margin-top: 10px;" alt="预览图片">
            <input type="submit" value="更新">
        </form>
    </div>
</div>

<h2><a href="addProduct.jsp" class="button">添加新商品</a> | <a href="merchantDashboard.jsp" class="button">返回商品列表</a></h2>
</body>
</html>
