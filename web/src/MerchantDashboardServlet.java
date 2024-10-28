import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet("/merchantDashboard")
@MultipartConfig // 允许上传文件
public class MerchantDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response); // 处理 POST 请求
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
        String rootname = "root"; // 数据库用户
        String rootpassword = "1234"; // 数据库密码

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("merchantUsername");

        if (username == null) {
            response.sendRedirect("merchantLogin.jsp"); // 如果未登录，重定向到登录页面
            return;
        }

        String action = request.getParameter("action");
        try (Connection conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword)) {
            if ("view".equals(action)) {
                // 查询商家的商品
                String sql = "SELECT * FROM products WHERE merchant_name = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, username);
                    ResultSet rs = pstmt.executeQuery();
                    request.setAttribute("products", rs);
                    request.getRequestDispatcher("merchantDashboard.jsp").forward(request, response); // 转发到仪表板页面
                }
            } else if ("add".equals(action)) {
                // 添加商品
                String productName = request.getParameter("productName");
                String productPrice = request.getParameter("productPrice");

                Part filePart = request.getPart("productImage"); // 获取文件部分
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString(); // 获取文件名

                // 确定文件存储路径
                String uploadPath = getServletContext().getRealPath("") + File.separator + "upload/img/"; // 保存路径
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // 如果目录不存在，则创建
                }

                // 保存文件
                File file = new File(uploadDir, fileName);
                try (InputStream fileContent = filePart.getInputStream()) {
                    Files.copy(fileContent, file.toPath(), java.nio.file.StandardCopyOption.REPLACE_EXISTING);
                }

                String insertSql = "INSERT INTO products (name, price, image, merchant_name) VALUES (?, ?, ?, ?)";
                try (PreparedStatement pstmt = conn.prepareStatement(insertSql)) {
                    pstmt.setString(1, productName);
                    pstmt.setDouble(2, Double.parseDouble(productPrice));
                    pstmt.setString(3,   fileName); // 存储图片路径
                    pstmt.setString(4, username);
                    pstmt.executeUpdate();
                }
                response.sendRedirect("merchantDashboard?action=view"); // 添加成功后重定向
            } else if ("delete".equals(action)) {
                // 删除商品
                int productId = Integer.parseInt(request.getParameter("productId"));
                String deleteSql = "DELETE FROM products WHERE id = ? AND merchant_name = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(deleteSql)) {
                    pstmt.setInt(1, productId);
                    pstmt.setString(2, username);
                    pstmt.executeUpdate();
                }
                response.sendRedirect("merchantDashboard?action=view"); // 删除成功重定向
            } else if ("update".equals(action)) {
                // 更新商品
                int productId = Integer.parseInt(request.getParameter("productId"));
                String productName = request.getParameter("productName");
                String productPrice = request.getParameter("productPrice");

                String updateSql = "UPDATE products SET name = ?, price = ? WHERE id = ? AND merchant_name = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(updateSql)) {
                    pstmt.setString(1, productName);
                    pstmt.setDouble(2, Double.parseDouble(productPrice));
                    pstmt.setInt(3, productId);
                    pstmt.setString(4, username);
                    pstmt.executeUpdate();
                }
                response.sendRedirect("merchantDashboard?action=view"); // 更新成功重定向
            } else {
                // 默认行为，展示商品
                String sql = "SELECT * FROM products WHERE merchant_name = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
                    pstmt.setString(1, username);
                    ResultSet rs = pstmt.executeQuery();
                    request.setAttribute("products", rs);
                    request.getRequestDispatcher("merchantDashboard.jsp").forward(request, response); // 转发到仪表板页面
                }
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}
