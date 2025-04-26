
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/processMerchantRegister")
public class ProcessMerchantRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 数据库连接信息
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 商家数据库 URL
        String rootname = "root"; // 数据库用户
        String rootpassword = "1234"; // 数据库密码

        String merchantUsername = request.getParameter("merchantUsername");
        String merchantPassword = request.getParameter("merchantPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        response.setContentType("text/html;charset=UTF-8");
        try (Connection conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword)) {
            // 检查输入有效性
            if (merchantUsername == null || merchantUsername.isEmpty() ||
                    merchantPassword == null || merchantPassword.isEmpty() ||
                    confirmPassword == null || confirmPassword.isEmpty()) {
                response.getWriter().println("<script>alert('所有字段都必须填写！'); window.history.back();</script>");
                return;
            }

            // 确认密码是否一致
            if (!merchantPassword.equals(confirmPassword)) {
                response.getWriter().println("<script>alert('密码和确认密码不一致！'); window.history.back();</script>");
                return;
            }

            // 检查商家用户名是否已存在
            String checkSql = "SELECT COUNT(*) FROM test.merchant WHERE merchant_name = ?";
            try (PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {
                checkStmt.setString(1, merchantUsername);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    response.getWriter().println("<script>alert('商家用户名已存在！'); window.history.back();</script>");
                    return;
                }
            }

            // 插入新商家
            String insertSql = "INSERT INTO merchant (merchant_name, merchant_pwd) VALUES (?, ?)";
            try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                insertStmt.setString(1, merchantUsername);
                insertStmt.setString(2, merchantPassword);
                insertStmt.executeUpdate();
            }

            response.getWriter().println("<script>alert('注册成功！欢迎，" + merchantUsername + "!'); window.location.href='merchantLogin.jsp';</script>");
        } catch (Exception e) {
            response.getWriter().println("<p>数据库连接错误：" + e.getMessage() + "</p>");
        }
    }
}
