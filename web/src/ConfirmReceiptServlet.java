import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/ConfirmReceiptServlet")
public class ConfirmReceiptServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderNumber = request.getParameter("orderNumber");
        String productId = request.getParameter("productId");

        // 数据库连接相关变量
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            // 加载数据库驱动（依据使用的数据库类型）
            Class.forName("com.mysql.cj.jdbc.Driver"); // 使用MySQL数据库

            // 连接数据库
            String dbURL = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 替换为您的数据库URL
            String dbUser = "root"; // 替换为您的数据库用户名
            String dbPassword = "1234"; // 替换为您的数据库密码
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // 更新订单状态的SQL语句
            String sql = "UPDATE orders SET status = ? WHERE order_number = ? AND product_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "已完成"); // 设置状态为已完成
            pstmt.setString(2, orderNumber);
            pstmt.setString(3, productId);

            // 执行更新
            int rowsAffected = pstmt.executeUpdate();
            boolean updateSuccess = (rowsAffected > 0); // 如果更新成功，返回true

            // 根据实际情况处理成功或失败
            if (updateSuccess) {
                response.sendRedirect("orderManagement");
            } else {
                response.sendRedirect("orderManagement");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("orderManagement");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("orderManagement");
        } finally {
            // 关闭连接，释放资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
