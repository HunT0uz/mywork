<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/12
  Time: 上午10:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>注册页面</title>
    <style>
        body{
            font-family: "Microsoft YaHei", sans-serif;
            background-color: #f5f5f5;
            text-align: center;
            margin: 0;
            padding: 500px;
        }
        form{
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
        h2{
            font-size: 24px;
            margin-top: 0;
            margin-bottom: 20px;
        }
        label{
            display: block;
            margin-bottom: 5px;
        }
        input[type="text"], input[type="password"], input[type="email"] {  /* 修改此行以支持邮箱 */
            width: 100%;
            padding: 10px;
            margin: 5px 0 10px;
            border-radius: 4px; /* 修正拼写错误 boarder-radius -> border-radius */
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<form action="processRegister" method="post">
    <h2>注册</h2>
    <label for="username">用户名:</label>
    <input type="text" id="username" name="username" required>
    <label for="password">密码:</label>
    <input type="password" id="password" name="password" required>
    <label for="confirmPassword">确认密码:</label>
    <input type="password" id="confirmPassword" name="confirmPassword" required>
    <label for="email">邮箱:</label> <!-- 添加邮箱标签 -->
    <input type="email" id="email" name="email" required> <!-- 添加邮箱输入框 -->

    <input type="submit" value="注册">
</form>
<p>已有账号？<a href="login.jsp">登录</a></p>

</body>
</html>
