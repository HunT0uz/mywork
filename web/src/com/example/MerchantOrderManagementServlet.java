package com.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/merchantOrderManagement")
public class MerchantOrderManagementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username;

        // 检测用户登录状态
        if (session != null && session.getAttribute("merchantUsername") != null) {
            username = (String) session.getAttribute("merchantUsername");
        } else if (request.getUserPrincipal() != null) {
            username = request.getUserPrincipal().getName();
        } else {
            // 用户未登录，重定向到登录页面
            response.sendRedirect("merchantLogin.jsp"); // 请根据实际登录页面路径进行修改
            return;
        }

        // 获取商品ID列表
        List<String> productIds = getProductIdsByMerchantName(username);

        // 如果没有找到对应的产品ID，返回错误信息
        if (productIds.isEmpty()) {
            request.setAttribute("errorMessage", "未找到与商家相关的产品ID。");
            request.getRequestDispatcher("/merchantOrderManagement.jsp").forward(request, response);
            return;
        }

        // 获取与产品ID相关的订单列表
        List<Order> orderList = getOrdersByProductIds(productIds, request);

        // 将订单列表放入请求范围
        request.setAttribute("orderList", orderList);

        // 转发请求到 JSP 页面
        request.getRequestDispatcher("/merchantOrderManagement.jsp").forward(request, response);
    }

    // 根据商家名称获取产品ID列表
    private List<String> getProductIdsByMerchantName(String merchantName) {
        List<String> productIds = new ArrayList<>();
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 请替换为您的数据库 URL
        String dbUser = "root"; // 数据库用户名
        String dbPassword = "1234"; // 数据库密码

        String sql = "SELECT id FROM products WHERE merchant_name = ?"; // 根据商家名称查询产品ID

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, merchantName);
            System.out.println("执行查询: " + preparedStatement.toString()); // 调试输出 SQL 语句
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                // 从结果集中获取产品ID
                productIds.add(resultSet.getString("id"));
            }

            System.out.println("获取到的产品数量: " + productIds.size()); // 调试输出
            if (productIds.isEmpty()) {
                System.out.println("没有找到与商家相关的产品。"); // 如果没有产品ID，输出信息
            }
        } catch (Exception e) {
            e.printStackTrace(); // 打印异常信息
        }

        return productIds;
    }

    // 根据产品ID列表获取订单列表
    private List<Order> getOrdersByProductIds(List<String> productIds, HttpServletRequest request) {
        List<Order> orders = new ArrayList<>();
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 请替换为您的数据库 URL
        String dbUser = "root"; // 数据库用户名
        String dbPassword = "1234"; // 数据库密码

        // SQL 查询，根据产品ID获取相关订单
        String sql = "SELECT o.*, p.image AS product_image " +
                     "FROM orders o " +
                     "JOIN products p ON o.product_id = p.id " +
                     "WHERE o.product_id IN (" + String.join(",", productIds) + ")"; // 根据产品ID列表查询订单

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                // 从结果集中获取订单信息
                String orderId = resultSet.getString("order_id");
                String username = resultSet.getString("username"); // 获取用户名
                String productId = resultSet.getString("product_id");
                int quantity = resultSet.getInt("quantity");
                double unitPrice = resultSet.getDouble("unit_price");
                String productName = resultSet.getString("product_name");
                String orderNumber = resultSet.getString("order_number");
                String createdAt = resultSet.getString("created_at");
                String productImage = resultSet.getString("product_image");
                String status = resultSet.getString("status");

                // 将订单信息添加到列表中
                orders.add(new Order(orderId, username, productId, quantity, unitPrice, productName, orderNumber, createdAt, productImage,status));
            }

            System.out.println("获取到的订单数量: " + orders.size()); // 调试输出
            if (orders.isEmpty()) {
                System.out.println("没有找到与产品ID相关的订单。"); // 如果没有订单，输出信息
            }
        } catch (Exception e) {
            e.printStackTrace(); // 打印异常信息
            request.setAttribute("errorMessage", "获取订单时发生错误: " + e.getMessage());
        }

        return orders;
    }

    // 内部类，表示订单
    public static class Order {
        private String orderId;
        private String username;
        private String productId;
        private int quantity;
        private double unitPrice;
        private String productName;
        private String orderNumber;
        private String createdAt;
        private String productImage; // 用于存储产品图片 URL
        private String status;

        public Order(String orderId, String username, String productId, int quantity, double unitPrice, String productName, String orderNumber, String createdAt, String productImage, String status) {
            this.orderId = orderId;
            this.username = username;
            this.productId = productId;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.productName = productName;
            this.orderNumber = orderNumber;
            this.createdAt = createdAt;
            this.productImage = productImage; // 初始化产品图片
            this.status = status; // 初始化订单状态
        }

        // 省略 getter 方法
        public String getOrderId() {
            return orderId;
        }

        public String getUsername() {
            return username;
        }

        public String getProductId() {
            return productId;
        }

        public int getQuantity() {
            return quantity;
        }

        public double getUnitPrice() {
            return unitPrice;
        }

        public String getProductName() {
            return productName;
        }

        public String getOrderNumber() {
            return orderNumber;
        }

        public String getCreatedAt() {
            return createdAt;
        }

        public String getProductImage() {
            return productImage; // 获取产品图片
        }

        public String getStatus() { return status ;}
    }
}
