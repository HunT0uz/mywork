<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/28
  Time: 下午2:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>商家注册</title>
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
        .register-button, .merchant-login-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 100%; /* 设置宽度为100% */
            margin-top: 10px; /* 与登录按钮之间留出间隔 */
        }
        .register-button:hover, .merchant-login-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<form action="processMerchantRegister" method="post">
    <h2>商家注册</h2>
    <label for="merchantUsername">商家用户名:</label>
    <input type="text" id="merchantUsername" name="merchantUsername" required>

    <label for="merchantPassword">商家密码:</label>
    <input type="password" id="merchantPassword" name="merchantPassword" required>

    <label for="confirmPassword">确认密码:</label>
    <input type="password" id="confirmPassword" name="confirmPassword" required>

    <input type="submit" value="注册">
</form>
</body>
</html>
