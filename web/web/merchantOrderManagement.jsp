<%@ page import="com.example.MerchantOrderManagementServlet" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Collection" %>
<%@ page import="java.util.Comparator" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>订单管理</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            margin: 0;
            padding: 20px;
            color: black; /* 将文字颜色改为黑色 */
            background-image: url('upload/img/updateorder_bg.jpg'); /* 设置唯一的背景图片 */
            background-repeat: no-repeat;
            background-position: center;
            background-size: contain; /* 保持图片完整显示 */
            background-attachment: fixed; /* 固定背景 */
            min-height: 100vh; /* 确保容器最小高度为视口高度 */
            min-width: 100vw; /* 确保容器最小宽度为视口宽度 */
            display: flex;
            flex-direction: column;
            align-items: flex-start; /* 内容靠左对齐 */
            justify-content: flex-start; /* 内容顶部对齐 */
        }
        .order-details {
            display: block; /* 默认展开 */
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
        .label-pending {
            background-color: yellow; /* 待发货的背景色 */
            color: black; /* 字体颜色 */
            padding: 5px;
            border-radius: 3px;
        }
        .label-shipped {
            background-color: blue; /* 已发货的背景色 */
            color: white; /* 字体颜色 */
            padding: 5px;
            border-radius: 3px;
        }
        .label-completed {
            background-color: green; /* 已完成的背景色 */
            color: white; /* 字体颜色 */
            padding: 5px;
            border-radius: 3px;
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

        function shipOrder(orderId, productId, productName, receiverName) {
            var confirmationMessage = "确认要发货吗？\n\n" +
                "订单号: " + orderId + "\n" +
                "产品ID: " + productId + "\n" +
                "产品名称: " + productName + "\n" +
                "收货人: " + receiverName;

            if (confirm(confirmationMessage)) {
                var xhr = new XMLHttpRequest();
                xhr.open("POST", "ShipOrderServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4) {
                        if (xhr.status === 200) {
                            // 确保处理返回结果
                            location.reload(); // 刷新页面
                        } else {
                            console.error("Error: " + xhr.status);
                            alert("请求失败，请稍后重试。");
                        }
                    }
                };
                xhr.send("orderNumber=" + encodeURIComponent(orderId) +
                 "&productId=" + encodeURIComponent(productId) +
                 "&receiverName=" + encodeURIComponent(receiverName) +
                 "&productName=" + encodeURIComponent(productName));
            }
        }

    </script>
</head>
<body>
    <h1>订单管理</h1>
    <a href="merchantDashboard.jsp" class="button">返回主页</a>
    <%
        // 获取商户名称
        String merchant = (String) session.getAttribute("merchantUsername");
        out.println("欢迎您，" + merchant + "！");
    %>
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
                        <td colspan="5">
                            <table>
                                <thead>
                                    <tr>
                                        <th>产品ID</th>
                                        <th>数量</th>
                                        <th>单价</th>
                                        <th>产品名称</th>
                                        <th>商品图片</th>
                                        <th>状态</th> <!-- 新增状态列 -->
                                        <th>操作</th> <!-- 新增操作列 -->
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
                                            <td>
                                                <%-- 展示订单状态 --%>
                                                <span class="<%= order.getStatus().equals("待发货") ? "label-pending" : (order.getStatus().equals("已发货") ? "label-shipped" : "label-completed") %>">
                                                    <%= order.getStatus() %>
                                                </span>
                                            </td>
                                            <td>
                                                <!-- 显示状态 -->
                                                <% if (order.getStatus().equals("待发货")) { %>
                                                    <button onclick="shipOrder('<%= orderNumber %>', '<%= order.getProductId() %>', '<%= order.getProductName() %>', '<%= firstOrder.getUsername() %>')">发货</button>
                                                <% } %>
                                            </td>
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
