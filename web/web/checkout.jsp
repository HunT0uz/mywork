<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%
    // 商品价格映射
    HashMap<String, Double> products = new HashMap<>();
    HashMap<String, Integer> productIds = new HashMap<>(); // 用于映射商品名和商品ID

    // 数据库连接
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    String username = "root";
    String password = "1234";

    Connection connection = null;
    Statement statement = null;
    ResultSet resultSet = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // 查询产品 ID、名称和价格
        String sql = "SELECT id, name, price FROM products";
        statement = connection.createStatement();
        resultSet = statement.executeQuery(sql);

        while (resultSet.next()) {
            String productName = resultSet.getString("name");
            double productPrice = resultSet.getDouble("price");
            int productId = resultSet.getInt("id");  // 获取商品ID
            products.put(productName, productPrice);
            productIds.put(productName, productId);  // 记录商品名称与ID的映射
        }
    } catch (SQLException | ClassNotFoundException e) {
        e.printStackTrace();
    } finally {
        if (resultSet != null) {
            try {
                resultSet.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        if (statement != null) {
            try {
                statement.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    // 获取购物车商品
    List<String> cart = (List<String>) session.getAttribute("cart");
    String usernameFromSession = (String) session.getAttribute("username");

    if (cart == null) {
        cart = new ArrayList<>();
    }

    double totalAmount = 0;
    for (String item : cart) {
        totalAmount += products.getOrDefault(item, 0.0);
    }

    // 添加订单创建功能
    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("confirm") != null) {
        System.out.println("确认结算请求已接收");

        if (usernameFromSession == null || usernameFromSession.isEmpty()) {
            out.println("<script>alert('用户名不能为空！');</script>");
        } else if (cart.isEmpty()) {
            out.println("<script>alert('购物车为空，无法结算！');</script>");
        } else {
            // 创建唯一订单号
            String orderNumber = UUID.randomUUID().toString();
            // 获取当前时间并调整为东八区时间
            long currentTimeMillis = System.currentTimeMillis() + 8 * 60 * 60 * 1000; // 加8小时的毫秒数
            Timestamp createdAt = new Timestamp(currentTimeMillis);

            String insertOrderSql = "INSERT INTO orders (order_number, username, product_id, quantity, unit_price, product_name, created_at, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement preparedStatement = null;

            try {
                connection = DriverManager.getConnection(jdbcUrl, username, password);
                connection.setAutoCommit(false); // 开始事务
                preparedStatement = connection.prepareStatement(insertOrderSql);

                for (String item : cart) {
                    Double unitPrice = products.get(item);
                    Integer productId = productIds.get(item);  // 获取商品ID

                    System.out.println("处理商品: " + item + "，单价: " + unitPrice + "，ID: " + productId);

                    if (unitPrice != null && productId != null) {
                        // 确保 productId 在 products 表中存在
                        String checkSql = "SELECT COUNT(*) FROM products WHERE id = ?";
                        try (PreparedStatement checkStmt = connection.prepareStatement(checkSql)) {
                            checkStmt.setInt(1, productId);
                            ResultSet checkRs = checkStmt.executeQuery();
                            if (checkRs.next() && checkRs.getInt(1) > 0) {
                                // 设置参数
                                preparedStatement.setString(1, orderNumber); // 订单号
                                preparedStatement.setString(2, usernameFromSession); // 用户名
                                preparedStatement.setInt(3, productId);  // 商品ID
                                preparedStatement.setInt(4, 1); // 假设每种商品数量为1
                                preparedStatement.setDouble(5, unitPrice); // 单价
                                preparedStatement.setString(6, item); // 商品名称
                                preparedStatement.setTimestamp(7, createdAt); // 创建时间
                                preparedStatement.setString(8, "待发货"); // 设置状态为"等待商家发货"

                                preparedStatement.addBatch(); // 将当前插入操作加入批量处理
                            } else {
                                out.println("<script>alert('商品 " + item + " 的 ID (" + productId + ") 不存在于产品表中，无法插入订单。');</script>");
                            }
                        }
                    } else {
                        out.println("<script>alert('商品 " + item + " 信息未找到，无法插入订单！');</script>");
                    }
                }
                // 执行批处理
                int[] rowsAffected = preparedStatement.executeBatch();

                // Output number of affected rows
                System.out.println("插入结果: " + Arrays.toString(rowsAffected) + " 行受影响");

                connection.commit(); // 提交事务
                session.removeAttribute("cart"); // 清空购物车
                out.println("<script>alert('订单创建成功！总金额: ￥" + totalAmount + "');</script>");
                out.println("<script>window.location.href='orderManagement';</script>"); // 跳转到订单管理页面
            } catch (SQLException e) {
                try {
                    if (connection != null) {
                        connection.rollback(); // 回滚事务
                        out.println("<script>alert('订单创建失败，操作已撤销；错误信息：" + e.getMessage() + "');</script>");
                        System.out.println("回滚事务，错误信息: " + e.getMessage());
                    }
                } catch (SQLException rollbackEx) {
                    System.out.println("回滚失败，错误信息: " + rollbackEx.getMessage());
                }
            } finally {
                if (preparedStatement != null) {
                    try {
                        preparedStatement.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                if (connection != null) {
                    try {
                        connection.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    } else {
        System.out.println("未接收到确认结算请求");
    }
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>结算页面</title>
    <style>
        body {
            background-image: url("<%= request.getContextPath() + "/upload/img/cart_bg.jpg" %>");
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
            overflow: hidden;
        }
    </style>
</head>
<body>

<h1>订单确认</h1>
<%
    if (cart.isEmpty()) {
%>
<p>购物车为空，无法结算。</p>
<%
} else {
%>
<ul>
    <%
        for (String item : cart) {
    %>
    <li><%= item %> - ￥<%= products.getOrDefault(item, 0.0) %></li>
    <%
        }
    %>
</ul>
<h3>总金额: ￥<%= totalAmount %></h3>

<form id="checkoutForm" method="post">
    <input type="hidden" name="confirm" value="true"/>
    <button type="submit">确认结算</button>
</form>
<%
    }
%>
<h2>
    <a href="cart.jsp" class="button">返回购物车</a>
    <a href="products.jsp" class="button">返回商品列表</a>
</h2>
</body>
</html>
