<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>登录页面</title>
    <style>
        body {
            font-family: "Microsoft YaHei", sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            margin: 0;
            padding: 500px;
        }
        form {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px #ccc;
            position: fixed; /* 固定定位 */
            top: 20px; /* 距离页面顶部0像素 */
            left: 50%; /* 距离页面左边50%，用于水平居中 */
            transform: translateX(-50%); /* 向左移动自身宽度的50%，实现水平居中 */
            width: 400px; /* 设置表单的宽度 */
            margin: 0; /* 移除外边距 */
        }
        h2 {
            font-size: 24px;
            margin-top: 0;
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0 10px;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%; /* 设置宽度为100%以保持一致 */
            margin-top: 10px; /* 添加上边距以分隔按钮 */
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        .register-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%; /* 设置宽度为100% */
            margin-top: 1000px; /* 与登录按钮之间留出间隔 */
        }
        .register-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<form action="processLogin.jsp" method="post">
    <h2>登录</h2>
    <label for="username">用户名:</label>
    <input type="text" id="username" name="username" required>

    <label for="password">密码:</label>
    <input type="password" id="password" name="password" required>

    <input type="submit" value="登录">
</form>

<!-- 注册按钮 -->
<form action="register.jsp" method="get" style="margin-top: 280px;">
    <input type="submit" value="注册" class="register-button">
</form>

<!-- 返回首页按钮 -->
<form action="index.jsp" method="get" style="margin-top: 350px;">
    <input type="submit" value="返回首页">
</form>
</body>
</html>


