<%@ page import="com.example.OrderManagementServlet" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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

        function confirmReceipt(orderNumber, productId) {
            if (confirm("确定要确认收货吗？")) {
                document.getElementById("confirm-form").orderNumber.value = orderNumber;
                document.getElementById("confirm-form").productId.value = productId;
                document.getElementById("confirm-form").submit();
            }
        }

        function filterOrders() {
            var selectedStatus = document.getElementById("orderStatusFilter").value;
            var orderRows = document.getElementsByClassName("order-row");
            for (var i = 0; i < orderRows.length; i++) {
                var detailsRow = orderRows[i].nextElementSibling;
                if (selectedStatus === "all") {
                    orderRows[i].style.display = "";
                    detailsRow.style.display = "";
                } else {
                    var statusCells = detailsRow.getElementsByTagName("td");
                    var statusDisplayed = false;
                    for (var j = 0; j < statusCells.length; j++) {
                        if (statusCells[j].innerText.includes(selectedStatus)) {
                            statusDisplayed = true;
                            break;
                        }
                    }
                    if (statusDisplayed) {
                        orderRows[i].style.display = "";
                        detailsRow.style.display = "";
                    } else {
                        orderRows[i].style.display = "none";
                        detailsRow.style.display = "none";
                    }
                }
            }
        }
    </script>
</head>
<body>
    <h1>订单管理</h1>
    <label for="orderStatusFilter">选择订单状态:</label>
    <select id="orderStatusFilter" onchange="filterOrders()">
        <option value="all">所有</option>
        <option value="待发货">待发货</option>
        <option value="已发货">已发货</option>
        <option value="已完成">已完成</option>
    </select>

    <%
        // 获取错误信息和订单列表
        String errorMessage = (String) request.getAttribute("errorMessage");
        List<OrderManagementServlet.Order> orderList = (List<OrderManagementServlet.Order>) request.getAttribute("orderList");

        // 合并订单
        Map<String, List<OrderManagementServlet.Order>> mergedOrders = new HashMap<>();

        if (orderList != null) {
            // 将订单合并
            for (OrderManagementServlet.Order order : orderList) {
                String orderNumber = order.getOrderNumber();
                mergedOrders.computeIfAbsent(orderNumber, k -> new ArrayList<>()).add(order);
            }
        }

        // 将合并后的订单按照时间由新到旧排序
        List<Map.Entry<String, List<OrderManagementServlet.Order>>> sortedOrders = new ArrayList<>(mergedOrders.entrySet());
        sortedOrders.sort(new Comparator<Map.Entry<String, List<OrderManagementServlet.Order>>>() {
            @Override
            public int compare(Map.Entry<String, List<OrderManagementServlet.Order>> entry1, Map.Entry<String, List<OrderManagementServlet.Order>> entry2) {
                OrderManagementServlet.Order firstOrder1 = entry1.getValue().get(0);
                OrderManagementServlet.Order firstOrder2 = entry2.getValue().get(0);
                return firstOrder2.getCreatedAt().compareTo(firstOrder1.getCreatedAt()); // 反转比较顺序
            }
        });

        // 显示错误消息
        if (errorMessage != null) {
    %>
        <div class="error"><%= errorMessage %></div>
    <% } %>

    <!-- 确认收货的隐藏表单 -->
    <form id="confirm-form" method="post" action="ConfirmReceiptServlet" style="display: none;">
        <input type="hidden" name="orderNumber" value="">
        <input type="hidden" name="productId" value="">
    </form>

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
                for (Map.Entry<String, List<OrderManagementServlet.Order>> entry : sortedOrders) {
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
                        <td colspan="4"> <!-- 更新合并的列数 -->
                            <table>
                                <thead>
                                    <tr>
                                        <th>产品ID</th>
                                        <th>数量</th>
                                        <th>单价</th>
                                        <th>产品名称</th>
                                        <th>商品图片</th>
                                        <th>订单状态</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% for (OrderManagementServlet.Order order : orders) { %>
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
                                                <% if (order.getStatus().equals("已发货")) { %>
                                                    <button class="botton" onclick="confirmReceipt('<%= orderNumber %>', '<%= order.getProductId() %>')">确认收货</button>
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
        <p>您可以<a href="products.jsp">继续购物</a>，或<a href="userCenter.jsp">返回首页</a>。</p>
    <% } %>

    <p><a href="userCenter.jsp">返回用户中心</a></p>
    <p><a href="products.jsp">继续购物</a></p>
</body>
</html>
