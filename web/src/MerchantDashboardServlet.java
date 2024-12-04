import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/merchantDashboard")
@MultipartConfig // 标注该Servlet支持文件上传
public class MerchantDashboardServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "updateImage":
                    updateImage(request, response); // 更新商品图片
                    break;
                case "delete":
                    deleteProduct(request, response); // 删除商品
                    break;
                case "update":
                    updateProduct(request, response); // 更新商品信息
                    break;
                case "updateDescription":
                    updateDescription(request, response); // 更新商品简介
                    break;
                default:
                    throw new ServletException("未知的操作: " + action);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "操作失败: " + e.getMessage());
        }

        request.getRequestDispatcher("updateProduct.jsp").forward(request, response); // 重定向或转发到更新页面
    }

    private void updateDescription(HttpServletRequest request, HttpServletResponse response) throws SQLException {
        try (Connection conn = getConnection()) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String newDescription = request.getParameter("productDescription"); // 获取新简介

            String sql = "UPDATE products SET description = ? WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setString(1, newDescription);
                pstmt.setInt(2, productId);
                pstmt.executeUpdate();
            }

            request.setAttribute("message", "商品简介更新成功");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void updateImage(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        if (ServletFileUpload.isMultipartContent(request)) {
            try (Connection conn = getConnection()) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String currentImage = getCurrentImage(conn, productId);

                for (Part part : request.getParts()) {
                    if ("productImage".equals(part.getName()) && part.getSize() > 0) {
                        String fileName = part.getSubmittedFileName();
                        File uploads = new File("upload/img");
                        if (!uploads.exists()) uploads.mkdirs();
                        part.write(new File(uploads, fileName).getAbsolutePath());

                        String sql = "UPDATE products SET image = ? WHERE id = ?";
                        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                            pstmt.setString(1, fileName);
                            pstmt.setInt(2, productId);
                            pstmt.executeUpdate();
                        }
                        request.setAttribute("message", "图片上传成功");
                    } else {
                        // 如果没有选择新图片，保留当前图片
                        request.setAttribute("message", "没有选择新图片，保留当前图片。");
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "文件上传失败: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "表单必须是 multipart/form-data 格式");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws Exception {
        try (Connection conn = getConnection()) {
            int productId = Integer.parseInt(request.getParameter("productId"));
            String sql = "DELETE FROM products WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                pstmt.setInt(1, productId);
                pstmt.executeUpdate();
            }

            request.setAttribute("message", "商品删除成功");
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) throws Exception {
    Connection conn = getConnection();
    try {
        int productId = Integer.parseInt(request.getParameter("productId"));
        String newName = request.getParameter("productName");
        double newPrice = Double.parseDouble(request.getParameter("productPrice"));
        String newType = request.getParameter("productType");
        String newDescription = request.getParameter("productDescription");

        // 检查接收到的参数
        if (newName == null || newPrice <= 0 || newType == null) {
            request.setAttribute("error", "商品信息不完整，请检查名称、价格和类型");
            return;
        }

        String sql = "UPDATE products SET name = ?, price = ?, type = ?, description = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newName);
            pstmt.setDouble(2, newPrice);
            pstmt.setString(3, newType);
            pstmt.setString(4, newDescription);
            pstmt.setInt(5, productId);

            int rowsAffected = pstmt.executeUpdate();
            if (rowsAffected > 0) {
                request.setAttribute("message", "商品更新成功");
            } else {
                request.setAttribute("error", "更新商品失败，未找到商品");
            }
        }
    } catch (SQLException e) {
        e.printStackTrace();
        request.setAttribute("error", "更新商品失败: " + e.getMessage());
    } finally {
        conn.close();
    }
}


    private String getCurrentImage(Connection conn, int productId) throws SQLException {
        String sql = "SELECT image FROM products WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, productId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("image");
                }
            }
        }
        return null;
    }

    private Connection getConnection() throws Exception {
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        return DriverManager.getConnection(jdbcUrl, "root", "1234");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try (Connection conn = getConnection()) {
            String sql = "SELECT * FROM products";
            try (PreparedStatement pstmt = conn.prepareStatement(sql);
                 ResultSet rs = pstmt.executeQuery()) {
                request.setAttribute("productList", rs); // 将查询结果存放到请求属性中
                request.getRequestDispatcher("products.jsp").forward(request, response); // 转发到显示页面
            }
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取商品列表失败: " + e.getMessage());
            request.getRequestDispatcher("products.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
