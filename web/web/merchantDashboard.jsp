<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<<<<<<< Updated upstream
=======
<%@ page import="javax.servlet.ServletException" %>
<%@ page import="javax.servlet.annotation.MultipartConfig" %>
<%@ page import="javax.servlet.http.Part" %>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

    <label for="productType">商品类型:</label>
    <select id="productType" name="productType" required>
        <option value="">请选择商品类型</option>
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
    </select><br><br>

    <label for="productImage">上传商品图片:</label>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======

>>>>>>> Stashed changes
<!-- 商品列表 -->
<h3>现有商品</h3>
<table border="1">
    <tr>
        <th>商品ID</th>
        <th>商品名称</th>
        <th>商品价格</th>
<<<<<<< Updated upstream
=======
        <th>商品类型</th>
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
=======
        <td><%= rs.getString("type") %></td>
>>>>>>> Stashed changes
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
