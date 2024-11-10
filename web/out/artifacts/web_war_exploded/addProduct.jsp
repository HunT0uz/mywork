<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>

<%
    String message = request.getParameter("message"); // 获取重定向消息
%>

<html>
<head>
    <title>添加/删除商品</title>
</head>
<body>
<h1>添加/删除商品</h1>
<p><%= message != null ? message : "" %></p>

<!-- 添加商品表单 -->
<form action="addProduct" method="post" enctype="multipart/form-data">
    <label for="productName">商品名称:</label>
    <input type="text" id="productName" name="productName" required><br>
    <label for="productPrice">商品价格:</label>
    <input type="number" id="productPrice" name="productPrice" step="0.01" required><br>
    <label for="productImage">商品图片:</label>
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

<%--<form action="upload" method="post" enctype="multipart/form-data">--%>
<%--    <label for="productImg">商品图片:</label>--%>
<%--    <input type="file" id="productImg" name="productImg" onchange="showFileName(this)" required><br>--%>
<%--    <img id="showimg" src="" alt="上传的图片"><br>--%>
<%--    <button type="submit">上传图片</button>--%>

<%--</form>--%>


<!-- 删除商品表单 -->
<form action="deleteProduct" method="post">
    <label for="productNameToDelete">删除商品名称:</label>
    <input type="text" id="productNameToDelete" name="productNameToDelete" required><br>
    <button type="submit">删除商品</button>
</form>

<h3>
    <a href="products.jsp" class="button">查看商品</a>
</h3>
</body>
</html>
