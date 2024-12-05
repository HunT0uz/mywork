<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/12/5
  Time: 下午3:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.util.List" %>
<%@ page import="com.example.UserManagementServlet" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            margin: 0;
            padding: 20px;
            color: black; /* 将文字颜色改为黑色 */
            background-image: url('upload/img/usermanagement_bg.jpg'); /* 设置唯一的背景图片 */
            background-repeat: no-repeat;
            background-position: top;
            background-size: contain; /* 保持图片完整显示 */
            background-attachment: fixed; /* 固定背景 */
            min-height: 100vh; /* 确保容器最小高度为视口高度 */
            min-width: 100vw; /* 确保容器最小宽度为视口宽度 */
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 内容靠左对齐 */
            justify-content: flex-start; /* 内容顶部对齐 */
        }

        body::before {
            content: ""; /* 伪元素内容为空 */
            position: absolute; /* 绝对定位 */
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('upload/img/usermanagement_bg.jpg') ;/* 替换为你的背景图片路径 */
            background-size: cover; /* 背景图片覆盖 */
            background-position: center; /* 背景图片居中 */
            filter: blur(8px); /* 设置背景虚化效果 */
            z-index: -1; /* 设置较低层级 */
            background-color: rgba(255, 255, 255, 0.1); /* 添加白色覆盖层 */
        }

        h1 {
            color: #343a40;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #dee2e6;
        }
        th {
            background-color: #007bff;
            color: #ffffff;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        button {
            padding: 5px 10px;
            background-color: #28a745;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #218838;
        }
        .no-records {
            margin-top: 20px;
            color: #6c757d;
        }
    </style>
</head>
<body>
    <h1>用户管理</h1>

    <%
        List<UserManagementServlet.User> userList = (List<UserManagementServlet.User>) request.getAttribute("userList");
    %>

    <% if (userList != null && !userList.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>用户名</th>
                    <th>邮箱</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <% for (UserManagementServlet.User user : userList) { %>
                    <tr>
                        <td><%= user.getUsername() %></td>
                        <td><%= user.getEmail() %></td>
                        <td>
                            <button onclick="viewLogs('<%= user.getUsername() %>')">查看日志</button>
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    <% } else { %>
        <p class="no-records">暂无用户记录。</p>
    <% } %>

    <script>
        function viewLogs(username) {
            var xhr = new XMLHttpRequest();
            xhr.open("GET", "UserLogServlet?username=" + encodeURIComponent(username), true);
            xhr.onreadystatechange = function() {
                if (xhr.readyState === 4) {
                    if (xhr.status === 200) {
                        var newWindow = window.open();
                        newWindow.document.write(xhr.responseText);
                        newWindow.document.close();
                    } else {
                        console.error("Error: " + xhr.status);
                        alert("请求失败，请稍后重试。");
                    }
                }
            };
            xhr.send();
        }
    </script>
<a href="merchantDashboard.jsp">返回商户主页</a>
</body>
</html>
