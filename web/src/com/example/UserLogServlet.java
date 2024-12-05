package com.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import static java.lang.System.out;

@WebServlet("/UserLogServlet")
public class UserLogServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String merchant = (String) request.getSession().getAttribute("merchantUsername");
        List<PurchaseLog> logList = new ArrayList<>();
        double totalAmount = 0.0;

        out.println("username: " + username);
        out.println("merchant: " + merchant);

        // 查询该商家的所有商品ID
        List<String> productIds = new ArrayList<>();
        try (Connection conn = getConnection();
             PreparedStatement productPstmt = conn.prepareStatement(
                     "SELECT id FROM products WHERE merchant_name = ?")) {
            productPstmt.setString(1, merchant);
            ResultSet productRs = productPstmt.executeQuery();

            while (productRs.next()) {
                productIds.add(productRs.getString("id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // 如果没有找到对应商品，返回提示
        if (productIds.isEmpty()) {
            response.getWriter().write("该商家没有商品。");
            return;
        }

        // 使用商品ID和用户名查询购买记录
        try (Connection conn = getConnection();
             PreparedStatement logPstmt = conn.prepareStatement(
                     "SELECT o.product_id, p.name, p.image, o.quantity, o.unit_price " +
                     "FROM orders o " +
                     "JOIN products p ON o.product_id = p.id " +
                     "WHERE o.username = ? AND o.product_id IN (" +
                     String.join(",", productIds.stream().map(id -> "?").toArray(String[]::new)) +
                     ") " +
                     "ORDER BY o.created_at DESC")) {
            logPstmt.setString(1, username);

            // 为每个商品ID设置参数
            for (int i = 0; i < productIds.size(); i++) {
                logPstmt.setString(i + 2, productIds.get(i)); // 从索引2开始
            }

            ResultSet rs = logPstmt.executeQuery();

            while (rs.next()) {
                PurchaseLog log = new PurchaseLog();
                log.setProductId(rs.getString("product_id"));
                log.setProductName(rs.getString("name"));
                log.setProductImage(rs.getString("image"));
                log.setQuantity(rs.getInt("quantity"));
                log.setUnitPrice(rs.getDouble("unit_price"));
                logList.add(log);
                totalAmount += log.getQuantity() * log.getUnitPrice();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("logList", logList);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("purchaseLogs.jsp").forward(request, response);
    }



    private Connection getConnection() throws SQLException {
        String dbURL = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "1234";
        return DriverManager.getConnection(dbURL, dbUser, dbPassword);
    }

    public static class PurchaseLog {
        private String productId;
        private String productName; // 产品名称
        private String productImage; // 产品图片
        private int quantity;
        private double unitPrice;

        // Getters and Setters
        public String getProductId() {
            return productId;
        }

        public void setProductId(String productId) {
            this.productId = productId;
        }

        public String getProductName() {
            return productName;
        }

        public void setProductName(String productName) {
            this.productName = productName;
        }

        public String getProductImage() {
            return productImage;
        }

        public void setProductImage(String productImage) {
            this.productImage = productImage;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }

        public double getUnitPrice() {
            return unitPrice;
        }

        public void setUnitPrice(double unitPrice) {
            this.unitPrice = unitPrice;
        }
    }
}
