<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
    // 数据库连接参数
    String jdbcURL = "jdbc:mysql://localhost:3306/test"; // 数据库URL
    String dbUser = "root"; // 数据库用户名
    String dbPass = "1234"; // 数据库密码

    session = request.getSession();
    String currentUsername = (String) session.getAttribute("username"); // 从session获取当前用户名

    // 判断用户是否已登录
    if (currentUsername == null) {
        response.sendRedirect("login.jsp"); // 若未登录，重定向至登录页面
        return;
    }

    // 处理表单提交
    String message = null;
    boolean isUpdated = false;

    if (request.getMethod().equalsIgnoreCase("POST")) {
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String newPassword = request.getParameter("newPassword"); // 新密码
        String confirmPassword = request.getParameter("confirmPassword"); // 确认密码

        try {
            // 更新用户信息
            Class.forName("com.mysql.cj.jdbc.Driver"); // 加载JDBC驱动
            Connection conn = DriverManager.getConnection(jdbcURL, dbUser, dbPass);

            // 更新用户信息的SQL语句，不再更新用户名
            String updateUserSQL = "UPDATE user SET email = ? WHERE username = ?";
            PreparedStatement preparedStatement = conn.prepareStatement(updateUserSQL);
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, currentUsername);

            isUpdated = preparedStatement.executeUpdate() > 0;

            // 如果需要更新密码且密码确认一致
            if (!newPassword.isEmpty() && newPassword.equals(confirmPassword)) {
                String updatePasswordSQL = "UPDATE user SET password = ? WHERE username = ?";
                PreparedStatement passwordStatement = conn.prepareStatement(updatePasswordSQL);
                passwordStatement.setString(1, newPassword); // 存储未加密的密码示例，请记得在实际中使用哈希存储密码
                passwordStatement.setString(2, currentUsername); // 这里仍使用 currentUsername
                passwordStatement.executeUpdate();
                passwordStatement.close();
            }

            if (isUpdated) {
                message = "信息更新成功！";
            } else {
                message = "信息更新失败，请重试。";
            }

            preparedStatement.close();
            conn.close();
        } catch (Exception e) {
            message = "数据库操作失败：" + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>修改个人信息</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            color: black;
            background-image: url('upload/img/updateuser_bg.jpg');
            background-repeat: no-repeat;
            background-position: top;
            background-size: contain;
            min-height: 100vh;
            position: relative;
            overflow: hidden;
        }
        .blurred-background {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(255, 255, 255, 0.2); /* 添加白色虚化效果 */
            z-index: -1;
            filter: blur(8px);
        }
        .modal {
            display: flex;
            flex-direction: column;
            align-items: stretch;
            padding: 40px;
            background-color: rgba(255, 255, 255, 0.9);
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 50%;
            margin: 50px auto;
        }
        h1 {
            text-align: center;
            margin: 0 0 20px;
            color: black;
        }
        .message, .error {
            text-align: center;
            width: 100%;
            margin-bottom: 15px;
        }
        .message {
            color: green;
        }
        .error {
            color: red;
        }
        label {
            margin-bottom: 5px;
        }
        input[type="text"], input[type="email"], input[type="tel"], input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 5px 0 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .button-container {
            display: flex; /* 使用 Flexbox 进行水平排列 */
            justify-content: center; /* 中心对齐 */
            gap: 10px; /* 按钮间距 */
        }
        input[type="submit"], .back-button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            width: 25%; /* 将按钮宽度设置为25% */
            font-size: 16px;
        }
        .back-button {
            background-color: #f44336;
        }
        input[type="submit"]:hover, .back-button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

    <div class="blurred-background"></div> <!-- 背景虚化区域 -->

    <div class="modal">
        <h1>修改个人信息</h1>

        <% if (message != null) { %>
            <div class="<%= isUpdated ? "message" : "error" %>"><%= message %></div>
        <% } %>

        <form method="post" action="updateUser.jsp">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" value="<%= currentUsername %>" disabled required>

            <label for="email">邮箱:</label>
            <input type="email" id="email" name="email" required>

            <label for="newPassword">新密码:</label>
            <input type="password" id="newPassword" name="newPassword">

            <label for="confirmPassword">确认新密码:</label>
            <input type="password" id="confirmPassword" name="confirmPassword">

            <div class="button-container"> <!-- 按钮容器 -->
                <input type="submit" value="提交">
                <a class="back-button" href="userCenter.jsp">返回个人中心</a> <!-- 返回个人中心按钮 -->
            </div>
        </form>
    </div>

</body>
</html>
