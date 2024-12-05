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

        if ("updateImage".equals(action)) {
            updateImage(request, response);
        } else if ("delete".equals(action)) {
            deleteProduct(request, response);
        } else if ("update".equals(action)) {
            updateProduct(request, response);
        }

        // 在所有操作后重定向回updateProduct.jsp，同时保持请求参数
        String searchParam = request.getParameter("search") != null ? "&search=" + request.getParameter("search") : "";
        String pageParam = request.getParameter("page") != null ? "&page=" + request.getParameter("page") : "";
        response.sendRedirect("updateProduct.jsp?merchantUsername=" + request.getParameter("merchantUsername") + searchParam + pageParam);
    }

    private void updateImage(HttpServletRequest request, HttpServletResponse response) {
        if (ServletFileUpload.isMultipartContent(request)) {
            try {
                Connection conn = getConnection();
                for (Part part : request.getParts()) {
                    if ("productImage".equals(part.getName())) {
                        String fileName = part.getSubmittedFileName();
                        if (fileName != null && !fileName.isEmpty()) {
                            File uploads = new File("upload/img");
                            if (!uploads.exists()) uploads.mkdirs();
                            part.write(uploads.getAbsolutePath() + File.separator + fileName);

                            int productId = Integer.parseInt(request.getParameter("productId"));
                            String sql = "UPDATE products SET image = ? WHERE id = ?";
                            PreparedStatement pstmt = conn.prepareStatement(sql);
                            pstmt.setString(1, fileName);
                            pstmt.setInt(2, productId);
                            pstmt.executeUpdate();
                            pstmt.close();
                        }
                    }
                }
                conn.close();
                request.setAttribute("message", "图片上传成功");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "文件上传失败: " + e.getMessage());
            }
        } else {
            request.setAttribute("error", "表单必须是 multipart/form-data 格式");
        }
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) {
        try {
            Connection conn = getConnection();
            int productId = Integer.parseInt(request.getParameter("productId"));
            String sql = "DELETE FROM products WHERE id = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, productId);
            pstmt.executeUpdate();
            pstmt.close();
            conn.close();
            request.setAttribute("message", "商品删除成功");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "删除商品失败: " + e.getMessage());
        }
    }

    private void updateProduct(HttpServletRequest request, HttpServletResponse response) {
    try {
        Connection conn = getConnection();
        int productId = Integer.parseInt(request.getParameter("productId"));
        String newName = request.getParameter("productName");
        double newPrice = Double.parseDouble(request.getParameter("productPrice"));
        String newType = request.getParameter("productType");
        String newDescription = request.getParameter("productDescription"); // 获取描述

        String sql = "UPDATE products SET name = ?, price = ?, type = ?, description = ? WHERE id = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, newName);
        pstmt.setDouble(2, newPrice);
        pstmt.setString(3, newType);
        pstmt.setString(4, newDescription); // 设置描述
        pstmt.setInt(5, productId);
        pstmt.executeUpdate();
        pstmt.close();
        conn.close();
        request.setAttribute("message", "商品更新成功");
    } catch (Exception e) {
        e.printStackTrace();
        request.setAttribute("error", "更新商品失败: " + e.getMessage());
    }
}


    private Connection getConnection() throws Exception {
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        return DriverManager.getConnection(jdbcUrl, "root", "1234");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            Connection conn = getConnection();
            String sql = "SELECT * FROM products";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            ResultSet rs = pstmt.executeQuery();

            request.setAttribute("productList", rs); // 将查询结果存放到请求属性中
            request.getRequestDispatcher("updateProduct.jsp").forward(request, response); // 转发到显示页面
            rs.close();
            pstmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "获取商品列表失败: " + e.getMessage());
            request.getRequestDispatcher("updateProduct.jsp").forward(request, response);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
