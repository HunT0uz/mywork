<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.net.URLEncoder" %>
<html>
<head>
    <title>修改商品</title>
    <style>
        body {
            position: relative;
            margin: 0;
            color: black;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow: hidden;
            transform: scale(0.85); /* 缩放页面为80% */
            transform-origin: top left; /* 从左上角进行缩放 */
            width: 125%; /* 为了补偿缩放后造成的宽度损失 */
        }

        body::before {
            background-image: url('upload/img/updateProduct_bg.jpg');
            content: "";
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-size: contain;
            background-position: top;
            filter: blur(2px);
            z-index: -1;
            background-color: rgba(0, 0, 0, 0.5);
            overflow: hidden;
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
            background-color: rgba(108, 117, 125, 0.7);
            color: white;
        }

        tr:hover {
            background-color: #f1f1f1;
        }

        .form-inline {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px; /* 添加底部间距 */
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

        .form-inline input[type="text"] {
            width: 200px;
        }

        table img {
            max-width: 100px;
            height: auto;
        }

        .button {
            display: inline-block;
            padding: 10px 15px;
            margin-right: 10px;
            text-decoration: none;
            background-color: #007bff;
            color: white;
            border-radius: 4px;
        }

        .button:hover {
            background-color: #0056b3;
        }

         textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            resize: none; /* 禁止用户调整文本框大小 */
            overflow: auto; /* 添加滚动条 */
            font-size: 16px;
            line-height: 1.5;
            box-sizing: border-box;
            max-height: 100px; /* 设置最大高度，以保持原本固定的大小 */
        }

        /* 模态框样式 */
        #editProductModal, #deleteProductModal, #updateImageModal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }

        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
            max-height: 460px;
            overflow-y: hidden;
        }

        .modal-header {
            margin-bottom: 15px;
        }

        .modal-header h4 {
            margin: 0;
            color: #343a40;
        }

        label {
            font-weight: bold;
        }

        input[type="text"], select {
            width: calc(100% - 20px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            box-sizing: border-box;
        }


        input[type="button"], input[type="submit"] {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 4px;
            cursor: pointer;
            margin-right: 10px;
            transition: background 0.3s;
        }

        input[type="button"]:hover, input[type="submit"]:hover {
            background-color: #0056b3;
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
        }

    </style>

    <script>
        function previewImage(input) {
            const preview = document.getElementById('imagePreview');
            const file = input.files[0];
            const reader = new FileReader();

            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = "block"; // 显示图片
            }

            if (file) {
                reader.readAsDataURL(file); // 读取文件为 Data URL
            } else {
                preview.src = "";
                preview.style.display = "none"; // 隐藏图片
            }
        }

        function openEditModal(productId, productName, productPrice, productType) {
            document.getElementById('modalProductId').value = productId;
            document.getElementById('modalProductName').value = productName;
            document.getElementById('modalProductPrice').value = productPrice;
            document.getElementById('modalProductType').value = productType;
            document.getElementById('editProductModal').style.display = 'flex';
        }

        function closeEditModal() {
            document.getElementById('editProductModal').style.display = 'none';
        }

        function submitEditForm() {
            document.getElementById('editProductForm').submit();
        }

        function openDeleteModal(productId) {
            document.getElementById('confirmDeleteButton').onclick = function() {
                document.location.href = '?action=delete&productId=' + productId + '&merchantUsername=' + document.getElementById('merchantUsername').value;
            };
            document.getElementById('deleteProductModal').style.display = 'flex';
        }

        function closeDeleteModal() {
            document.getElementById('deleteProductModal').style.display = 'none';
        }

        function openUpdateImageModal(productId, productName) {
            document.getElementById('modalUpdateImageProductId').value = productId;
            document.getElementById('imagePreview').style.display = 'none'; // 隐藏预览
            document.getElementById('updateImageModal').style.display = 'flex';
        }

        function closeUpdateImageModal() {
            document.getElementById('updateImageModal').style.display = 'none';
        }

        function submitUpdateImageForm() {
            document.getElementById('updateImageForm').submit();
        }

        function performSearch() {
            var searchTerm = document.getElementById('search').value;
            if (searchTerm.trim() === "") {
                // 如果搜索框为空，跳转到商品列表页面，不带搜索参数
                window.location.href = "updateProduct.jsp";
            } else {
                // 跳转到当前页面并传递搜索参数
                window.location.href = "updateProduct.jsp?search=" + encodeURIComponent(searchTerm);
            }
        }


        function openDeleteModal(productId) {
            document.getElementById('modalDeleteProductId').value = productId; // 设置商品ID到隐藏输入
            document.getElementById('deleteProductModal').style.display = 'flex'; // 显示模态框
        }

    </script>

</head>
<body>
<h3>现有商品</h3>

<div class="form-inline">
    <input type="text" id="search" placeholder="搜索商品" />
    <input type="button" value="搜索" onclick="performSearch()" />
</div>

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
            String searchKeyword = request.getParameter("search") != null ? request.getParameter("search") : "";
            int currentPage = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            //把currentPage存入session
            session.setAttribute("currentPage", currentPage);

            if (merchantUsername == null) {
                response.sendRedirect("merchantLogin.jsp");
                return;
            }

            int limit = 6; // 每页显示6个商品
            int offset = (currentPage - 1) * limit;

            Connection conn = null;
            try {
                String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
                conn = DriverManager.getConnection(jdbcUrl, "root", "1234");

                // 查询总记录数，包括搜索条件
                String countSql = "SELECT COUNT(*) FROM products WHERE merchant_name = ? AND name LIKE ?";
                PreparedStatement countPstmt = conn.prepareStatement(countSql);
                countPstmt.setString(1, merchantUsername);
                countPstmt.setString(2, "%" + searchKeyword + "%");
                ResultSet countRs = countPstmt.executeQuery();
                int totalCount = 0;
                if (countRs.next()) {
                    totalCount = countRs.getInt(1);
                }
                countRs.close();
                countPstmt.close();

                // 查询当前页商品，包括搜索条件
                String sql = "SELECT * FROM products WHERE merchant_name = ? AND name LIKE ? LIMIT ? OFFSET ?";
                PreparedStatement pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, merchantUsername);
                pstmt.setString(2, "%" + searchKeyword + "%");
                pstmt.setInt(3, limit);
                pstmt.setInt(4, offset);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    String name = rs.getString("name");
                    double price = rs.getDouble("price");
                    String type = rs.getString("type");
                    String image = rs.getString("image");
            %>
            <tr>
                <td><%=rs.getInt("id")%></td>
                <td>
                    <% if (image != null && !image.isEmpty()) { %>
                    <img src="<%=request.getContextPath() + "/upload/img/" + image%>" alt="<%=name%>图片" style="max-width: 150px; height: auto;">
                    <% } else { %>
                    <img src="<%=request.getContextPath() + "/upload/img/no-image.png"%>" alt="无图片" style="max-width: 150px; height: auto;">
                    <% } %>
                </td>
                <td><%=name%></td>
                <td><%=price%></td>
                <td><%=type%></td>
                <td>
                    <input type="button" value="删除" onclick="openDeleteModal(<%=rs.getInt("id")%>)">
                    <input type="button" value="修改" onclick="openEditModal(<%=rs.getInt("id")%>, '<%=name%>', <%=price%>, '<%=type%>')">
                    <input type="button" value="修改图片" onclick="openUpdateImageModal(<%=rs.getInt("id")%>, '<%=name%>')">
                </td>
            </tr>
            <%
                }
                rs.close();
                pstmt.close();

                // 计算总页数
                int totalPages = (int) Math.ceil((double) totalCount / limit);
            %>
    </table>
</div>

<div>
    <%
        if (currentPage > 1) {
    %>
    <a href="updateProduct.jsp?page=<%=currentPage - 1%>&merchantUsername=<%=merchantUsername%>&search=<%=searchKeyword%>">上一页</a>
    <%
        }
        if (currentPage < totalPages) {
    %>
    <a href="updateProduct.jsp?page=<%=currentPage + 1%>&merchantUsername=<%=merchantUsername%>&search=<%=searchKeyword%>">下一页</a>
    <%
        }
            } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    %>
    <h4>当前页: <%=currentPage%></h4>  <!-- 显示当前页数 -->
</div>

<!-- 修改商品模态框 -->
<div id="editProductModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4>修改商品信息</h4>
        </div>
        <form id="editProductForm" action="merchantDashboard" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="productId" id="modalProductId" value="">

            <label for="modalProductName">新名称:</label>
            <input type="text" name="productName" id="modalProductName" required>

            <label for="modalProductPrice">新价格:</label>
            <input type="text" name="productPrice" id="modalProductPrice" required>

            <label for="modalProductType">新类型:</label>
            <select name="productType" id="modalProductType" required>
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

            <!-- 添加商品描述 -->
            <label for="modalProductDescription">新描述:</label>
            <textarea name="productDescription" id="modalProductDescription" rows="4" required></textarea>

            <div class="modal-footer">
                <input type="button" value="提交" onclick="submitEditForm()">
                <input type="button" value="取消" onclick="closeEditModal()">
            </div>
        </form>
    </div>
</div>


<!-- 删除商品的模态框 -->
<div id="deleteProductModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4>确认删除商品</h4>
        </div>
        <p>您确定要删除这件商品吗？</p>
        <div class="modal-footer">
            <form action="merchantDashboard" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="delete"> <!-- 删除操作标识 -->
                <input type="hidden" name="productId" id="modalDeleteProductId" value=""> <!-- 商品ID，待填充 -->
                <input type="submit" value="确认删除" style="padding: 12px 20px; height: 40px; margin-right: 10px; background-color: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; transition: background 0.3s;">
            </form>
            <input type="button" value="取消" onclick="closeDeleteModal()" style="padding: 12px 20px; height: 40px; background-color: #6c757d; color: white; border: none; border-radius: 4px; cursor: pointer; transition: background 0.3s;">
        </div>
    </div>
</div>


<!-- 修改商品图片的模态框 -->
<div id="updateImageModal">
    <div class="modal-content">
        <div class="modal-header">
            <h4>修改商品图片</h4>
        </div>
        <form id="updateImageForm" action="merchantDashboard" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="updateImage">
            <input type="hidden" name="productId" id="modalUpdateImageProductId" value="">
            <label for="productImage">新图片:</label>
            <input type="file" name="productImage" accept="image/*" required onchange="previewImage(this)">
            <img id="imagePreview" class="preview" style="display:none; max-width: 200px; height: auto;" alt="预览图片" />
            <div class="modal-footer">
                <input type="button" value="提交" onclick="submitUpdateImageForm()">
                <input type="button" value="取消" onclick="closeUpdateImageModal()">
            </div>
        </form>
    </div>
</div>
<h4>
    <a href="addProduct.jsp" class="button">添加新商品</a>
    <a href="merchantDashboard.jsp" class="button">返回商品列表</a>
</h4>
</body>
</html>
