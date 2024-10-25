import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.*;
import javax.servlet.ServletContext;
import javax.servlet.RequestDispatcher;
@WebServlet("/addProduct")
@MultipartConfig
public class AddProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = ""; // 用于存储反馈信息
        try {
            String productName = request.getParameter("productName");
            double productPrice = Double.parseDouble(request.getParameter("productPrice"));
            // 处理图片上传
            Part filePart = request.getPart("productImage"); // 获取上传的文件部分
            String fileName = filePart.getSubmittedFileName(); // 获取文件名
            String uploadPath = getServletContext().getRealPath("/upload/img/") + fileName; // 设置文件保存路径
            File uploadDir = new File(getServletContext().getRealPath("/upload/img/"));
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            try (InputStream fileContent = filePart.getInputStream()) {
                // 保存文件到服务器
                Files.copy(fileContent, Paths.get(uploadPath), StandardCopyOption.REPLACE_EXISTING);
            } catch (Exception e) {
                e.printStackTrace();
                message = "图片上传失败: " + e.getMessage();
            }
            // 插入商品
            String jdbcUrl = "jdbc:mysql://localhost:3306/test";
            String username = "root"; // 数据库用户
            String password = "1234"; // 数据库密码

            try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password)) {
                // 加载 JDBC 驱动程序
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 插入商品信息
                String sql = "INSERT INTO products (name, price,image) VALUES (?, ?, ?)";
                try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                    preparedStatement.setString(1, productName);
                    preparedStatement.setDouble(2, productPrice);
                    preparedStatement.setString(3, fileName); // 添加图片的文件名
                    int rowsAffected = preparedStatement.executeUpdate();

                    if (rowsAffected > 0) {
                        message = "商品添加成功！";
                    }else {
                        message = "商品添加失败！";
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
                message = "错误: " + e.getMessage();
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "发生错误: " + e.getMessage();
        }
        String redirectUrl =request.getContextPath() + "/addProduct.jsp";
        System.out.println(redirectUrl);
        // 重定向回表单页面，并携带消息
        response.sendRedirect(redirectUrl);
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果直接访问，会重定向回添加商品页面
        String message = "请通过表单提交来删除商品。";
        ServletContext sc = getServletContext();
        RequestDispatcher rd = sc.getRequestDispatcher("/addProduct.jsp"); //定向的页面
        rd.forward(request, response);
        response.sendRedirect(request.getContextPath() + "/addProduct.jsp?message=" + message);
    }
}
;