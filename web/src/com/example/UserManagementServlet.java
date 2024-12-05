// UserManagementServlet.java
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

@WebServlet("/UserManagementServlet")
public class UserManagementServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<User> userList = new ArrayList<>();

        String merchantId = (String) request.getSession().getAttribute("merchantUsername"); // 从会话中获取商家 ID

        String sql = "SELECT DISTINCT u.* FROM user u " +
                     "JOIN orders o ON u.username = o.username " + // 假设 users 表通过 username 关联
                     "JOIN products p ON o.product_id = p.id " +
                     "WHERE p.merchant_name = ?"; // 根据商品的商家 ID 进行过滤

        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, merchantId); // 设置商家的 ID
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setUsername(rs.getString("username"));
                user.setEmail(rs.getString("email"));
                userList.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.setAttribute("userList", userList);
        request.getRequestDispatcher("userManagement.jsp").forward(request, response);
    }

    private Connection getConnection() throws SQLException {
        String dbURL = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "1234";
        return DriverManager.getConnection(dbURL, dbUser, dbPassword);
    }

    public static class User {
        private String username;
        private String email;

        // Getter and Setter
        public String getUsername() {
            return username;
        }

        public void setUsername(String username) {
            this.username = username;
        }

        public String getEmail() {
            return email;
        }

        public void setEmail(String email) {
            this.email = email;
        }

    }
}
