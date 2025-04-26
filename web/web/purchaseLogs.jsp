<%@ page import="java.util.List" %>
<%@ page import="com.example.UserLogServlet.PurchaseLog" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>购买日志</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
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
        .total-amount {
            margin-top: 20px;
            font-size: 20px;
            color: #28a745;
        }
        .no-records {
            margin-top: 20px;
            color: #6c757d;
        }
        .button {
            display: block;
            margin: 10px 0;
            width: 90px; /* 设置具体宽度 */
            padding: 10px 20px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 5px;
            text-decoration: none;
            text-align: center;
        }
        img {
            width: 75px;
            height: 75px;
            object-fit: cover;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <h1>购买日志</h1>
    <a href="UserManagementServlet" class="button">用户管理</a>
    <%
        List<PurchaseLog> logList = (List<PurchaseLog>) request.getAttribute("logList");
        Double totalAmount = (Double) request.getAttribute("totalAmount");
    %>

    <% if (logList != null && !logList.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>产品图片</th>
                    <th>产品名称</th>
                    <th>产品ID</th>
                    <th>数量</th>
                    <th>单价</th>
                    <th>总金额</th>
                </tr>
            </thead>
            <tbody>
                <%
                    // 使用 Map 对产品进行分组
                    Map<String, List<PurchaseLog>> groupedLogs = new HashMap<>();
                    for (PurchaseLog log : logList) {
                        if (!groupedLogs.containsKey(log.getProductId())) {
                            groupedLogs.put(log.getProductId(), new ArrayList<>());
                        }
                        groupedLogs.get(log.getProductId()).add(log);
                    }

                    for (Map.Entry<String, List<PurchaseLog>> entry : groupedLogs.entrySet()) {
                        String productId = entry.getKey();
                        List<PurchaseLog> logs = entry.getValue();

                        int totalQuantity = 0;
                        double totalUnitPrice = 0;

                        // 聚合数量与单价（取第一个作为示例）
                        for (PurchaseLog log : logs) {
                            totalQuantity += log.getQuantity();
                            totalUnitPrice = log.getUnitPrice(); // 假设单价相同
                        }
                        double totalPrice = totalQuantity * totalUnitPrice;

                        String productName = logs.get(0).getProductName();
                        String productImage = logs.get(0).getProductImage();
                %>
                    <tr>
                        <td><img src="<%= request.getContextPath() +"/upload/img/" +  productImage %>" alt="<%= productName %>"></td>
                        <td><%= productName %></td>
                        <td><%= productId %></td>
                        <td><%= totalQuantity %></td>
                        <td><%= totalUnitPrice %></td>
                        <td><%= totalPrice %></td>
                    </tr>
                <% } %>
            </tbody>
        </table>
        <h3 class="total-amount">总金额: <%= totalAmount %></h3>
    <% } else { %>
        <p class="no-records">暂无购买记录。</p>
    <% } %>
</body>
</html>
