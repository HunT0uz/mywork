<%@ page import="com.example.OrderManagementServlet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .order-details {
            display: none; /* 默认隐藏 */
            border-top: 1px solid #ddd;
            padding: 10px 0;
        }
        .order-row {
            cursor: pointer; /* 指示可以点击 */
        }
        .error {
            color: red;
            font-weight: bold;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
    <script>
        function toggleOrderDetails(orderId) {
            var details = document.getElementById("details-" + orderId);
            if (details.style.display === "none") {
                details.style.display = "block"; // 显示
            } else {
                details.style.display = "none"; // 隐藏
            }
        }
    </script>
</head>
<body>
    <h1>订单管理</h1>

    <%
        // 获取错误信息和订单列表
        String errorMessage = (String) request.getAttribute("errorMessage");
        List<OrderManagementServlet.Order> orderList = (List<OrderManagementServlet.Order>) request.getAttribute("orderList");

        // 合并订单
        Map<String, List<OrderManagementServlet.Order>> mergedOrders = new HashMap<>();

        if (orderList != null) {
            for (OrderManagementServlet.Order order : orderList) {
                String orderNumber = order.getOrderNumber();
                mergedOrders.computeIfAbsent(orderNumber, k -> new ArrayList<>()).add(order);
            }
        }

        // 显示错误消息
        if (errorMessage != null) {
    %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

    <!-- 显示订单列表 -->
    <% if (!mergedOrders.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>订单编号</th>
                    <th>用户名</th>
                    <th>创建时间</th>
                </tr>
            </thead>
            <tbody>
                <%
                for (Map.Entry<String, List<OrderManagementServlet.Order>> entry : mergedOrders.entrySet()) {
                    String orderNumber = entry.getKey();
                    List<OrderManagementServlet.Order> orders = entry.getValue();
                    OrderManagementServlet.Order firstOrder = orders.get(0); // 获取第一个订单的信息

                %>
                    <tr class="order-row" onclick="toggleOrderDetails('<%= orderNumber %>')">
                        <td><%= orderNumber %></td>
                        <td><%= firstOrder.getUsername() %></td>
                        <td><%= firstOrder.getCreatedAt() %></td>
                    </tr>
                    <tr class="order-details" id="details-<%= orderNumber %>">
                        <td colspan="3">
                            <table>
                                <thead>
                                    <tr>
                                        <th>产品ID</th>
                                        <th>数量</th>
                                        <th>单价</th>
                                        <th>产品名称</th>
                                        <th>商品图片</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OrderManagementServlet.Order order : orders) { %>
                                        <tr>
                                            <td><%= order.getProductId() %></td>
                                            <td><%= order.getQuantity() %></td>
                                            <td><%= order.getUnitPrice() %></td>
                                            <td><%= order.getProductName() %></td>
                                            <td><img src="<%= request.getContextPath() + "/upload/img/" + order.getProductImage() %>" alt="商品图片" style="width:100px;height:100px;">
                                        </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                <%
                }
                %>
            </tbody>
        </table>
    <% } else { %>
        <p>暂无订单记录。</p>
        <p>您可以<a href="products.jsp">继续购物</a>，或<a href="userCenter.jsp">返回首页</a>。</p>
    <% } %>

</body>
</html>
