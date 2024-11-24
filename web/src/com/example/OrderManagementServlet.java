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

@WebServlet("/orderManagement")
public class OrderManagementServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username;

        // 检测用户登录状态
        if (session != null && session.getAttribute("username") != null) {
            username = (String) session.getAttribute("username");
        } else if (request.getUserPrincipal() != null) {
            username = request.getUserPrincipal().getName();
        } else {
            // 用户未登录，重定向到登录页面
            response.sendRedirect("login.jsp"); // 请根据实际登录页面路径进行修改
            return;
        }

        // 获取用户的订单列表
        List<Order> orderList = getUserOrders(username, request);

        // 将订单列表放入请求范围
        request.setAttribute("orderList", orderList);

        // 转发请求到 JSP 页面
        request.getRequestDispatcher("/orderManagement.jsp").forward(request, response);
    }

    // 获取用户的订单列表
    private List<Order> getUserOrders(String username, HttpServletRequest request) {
        List<Order> orders = new ArrayList<>();
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 请替换为您的数据库 URL
        String dbUser = "root"; // 数据库用户名
        String dbPassword = "1234"; // 数据库密码

        String sql = "SELECT * FROM orders WHERE username = ?"; // 根据用户名查询订单

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setString(1, username);
            System.out.println("执行查询: " + preparedStatement.toString()); // 调试输出 SQL 语句
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                // 从结果集中获取订单信息
                String orderId = resultSet.getString("order_id");
                String productId = resultSet.getString("product_id");
                int quantity = resultSet.getInt("quantity");
                double unitPrice = resultSet.getDouble("unit_price");
                String productName = resultSet.getString("product_name");
                String orderNumber = resultSet.getString("order_number");
                String createdAt = resultSet.getString("created_at");

                // 将订单信息添加到列表中
                orders.add(new Order(orderId, username, productId, quantity, unitPrice, productName, orderNumber, createdAt));
            }

            System.out.println("获取到的订单数量: " + orders.size()); // 调试输出
            if (orders.isEmpty()) {
                System.out.println("没有找到与用户相关的订单。"); // 如果没有订单，输出信息
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

        public Order(String orderId, String username, String productId, int quantity, double unitPrice, String productName, String orderNumber, String createdAt) {
            this.orderId = orderId;
            this.username = username;
            this.productId = productId;
            this.quantity = quantity;
            this.unitPrice = unitPrice;
            this.productName = productName;
            this.orderNumber = orderNumber;
            this.createdAt = createdAt;
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

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

       public String getProductImage() {
    String imageUrl = null; // 初始化为 null

    // 连接数据库，查询产品图片
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
    String username = "root";
    String password = "1234";

    // 使用 productId 来查找对应的商品图片
    String sql = "SELECT image FROM products WHERE id = ?"; // 替换为真实的表名和字段
            try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password);
                 PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, productId);
                System.out.println("执行查询: " + preparedStatement.toString()); // 调试输出 SQL 语句
                ResultSet resultSet = preparedStatement.executeQuery();
                while (resultSet.next()) {
                    imageUrl = resultSet.getString("image"); // 获取图片 URL
                }
            } catch (Exception e) {
                e.printStackTrace(); // 打印异常信息
            }
    return imageUrl; // 返回图片 URL
}


    }
}
