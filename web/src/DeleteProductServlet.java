import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.RequestDispatcher;
import java.sql.*;

@WebServlet("/deleteProduct")
public class DeleteProductServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String message = ""; // 用于存储反馈信息
        String productNameToDelete = request.getParameter("productNameToDelete");

        String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
        String username = "root"; // 数据库用户
        String password = "1234"; // 数据库密码

        try (Connection connection = DriverManager.getConnection(jdbcUrl, username, password)) {
            // 加载 JDBC 驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 删除商品信息
            String sql = "DELETE FROM products WHERE name = ? LIMIT 1";
            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, productNameToDelete);
                int rowsAffected = preparedStatement.executeUpdate();

                if (rowsAffected > 0) {
                    message = "商品删除成功！";
                } else {
                    message = "没有找到该商品！";
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            message = "错误: " + e.getMessage();
        }catch (Exception e) {
            e.printStackTrace();
            message = "发生错误: " + e.getMessage();
        }
        String redirectUrl =request.getContextPath() + "/products.jsp";
        System.out.println(redirectUrl);
        // 重定向回表单页面，并携带消息
        response.sendRedirect(redirectUrl);
        // 重定向回表单页面，并携带消息
        //response.sendRedirect("addProduct.jsp?message=" + message);
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果直接访问，会重定向回添加商品页面
        String message = "请通过表单提交来删除商品。";
        ServletContext sc = getServletContext();
        RequestDispatcher rd = sc.getRequestDispatcher("/products.jsp"); //定向的页面
        rd.forward(request, response);
        response.sendRedirect(request.getContextPath() + "/products.jsp?message=" + message);
    }
}
