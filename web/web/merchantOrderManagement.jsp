<%@ page import="com.example.MerchantOrderManagementServlet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Comparator" %>
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
            details.style.display = (details.style.display === "none") ? "block" : "none"; // 切换显示状态
        }
    </script>
</head>
<body>
    <h1>订单管理</h1>

    <%
        // 获取错误信息和订单列表
        String errorMessage = (String) request.getAttribute("errorMessage");
        List<MerchantOrderManagementServlet.Order> orderList = (List<MerchantOrderManagementServlet.Order>) request.getAttribute("orderList");

        // 合并订单
        Map<String, List<MerchantOrderManagementServlet.Order>> mergedOrders = new HashMap<>();

        if (orderList != null) {
            // 将订单合并
            for (MerchantOrderManagementServlet.Order order : orderList) {
                String orderNumber = order.getOrderNumber();
                mergedOrders.computeIfAbsent(orderNumber, k -> new ArrayList<>()).add(order);
            }
        }

        // 将合并后的订单按照时间由新到旧排序
        List<Map.Entry<String, List<MerchantOrderManagementServlet.Order>>> sortedOrders = new ArrayList<>(mergedOrders.entrySet());
        sortedOrders.sort(new Comparator<Map.Entry<String, List<MerchantOrderManagementServlet.Order>>>() {
            @Override
            public int compare(Map.Entry<String, List<MerchantOrderManagementServlet.Order>> entry1, Map.Entry<String, List<MerchantOrderManagementServlet.Order>> entry2) {
                // 获取第一个订单的创建时间进行比较，按时间降序排列（新到旧）
                MerchantOrderManagementServlet.Order firstOrder1 = entry1.getValue().get(0);
                MerchantOrderManagementServlet.Order firstOrder2 = entry2.getValue().get(0);
                return firstOrder2.getCreatedAt().compareTo(firstOrder1.getCreatedAt()); // 反转比较顺序
            }
        });

        // 显示错误消息
        if (errorMessage != null) {
    %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

    <!-- 显示订单列表 -->
    <% if (!sortedOrders.isEmpty()) { %>
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
                for (Map.Entry<String, List<MerchantOrderManagementServlet.Order>> entry : sortedOrders) {
                    String orderNumber = entry.getKey();
                    List<MerchantOrderManagementServlet.Order> orders = entry.getValue();
                    MerchantOrderManagementServlet.Order firstOrder = orders.get(0); // 获取第一个订单的信息
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
                                    <% for (MerchantOrderManagementServlet.Order order : orders) { %>
                                        <tr>
                                            <td><%= order.getProductId() %></td>
                                            <td><%= order.getQuantity() %></td>
                                            <td><%= order.getUnitPrice() %></td>
                                            <td><%= order.getProductName() %></td>
                                            <td><img src="<%= request.getContextPath() + "/upload/img/" + order.getProductImage() %>" alt="商品图片" style="width:100px;height:100px;"></td>
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
        <p>您可以<a href="products.jsp">查看商品</a>，或<a href="index.jsp">返回首页</a>。</p>
    <% } %>

</body>
</html>
