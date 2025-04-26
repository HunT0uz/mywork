import java.io.IOException;
import java.sql.*;
import java.util.regex.Pattern;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/processRegister")
public class ProcessRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String email = request.getParameter("email"); // 获取邮箱参数

        // 设置邮箱格式的正则表达式
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        Pattern pattern = Pattern.compile(emailRegex);

        response.setContentType("text/html;charset=UTF-8");
        if (username == null || username.isEmpty() || password == null || password.isEmpty() || confirmPassword == null || confirmPassword.isEmpty() || email == null || email.isEmpty()) {
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('用户名、密码、确认密码和邮箱不能为空！');");
            response.getWriter().println("location.href='register.jsp';");
            response.getWriter().println("</script>");
        } else if (!password.equals(confirmPassword)) {
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('密码和确认密码不一致！');");
            response.getWriter().println("location.href='register.jsp';");
            response.getWriter().println("</script>");
        } else if (!pattern.matcher(email).matches()) { // 校验邮箱格式
            response.getWriter().println("<script type='text/javascript'>");
            response.getWriter().println("alert('邮箱格式不正确！');");
            response.getWriter().println("location.href='register.jsp';");
            response.getWriter().println("</script>");
        } else {
            String rootname = "root"; // 数据库用户
            String rootpassword = "1234"; // 数据库密码

            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                // 加载 JDBC 驱动程序
                Class.forName("com.mysql.cj.jdbc.Driver");

                // 建立连接
                conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

                // 检查用户名是否已存在
                String checkSql = "SELECT COUNT(*) FROM test.user WHERE username = ?";
                stmt = conn.prepareStatement(checkSql);
                stmt.setString(1, username);
                ResultSet rs = stmt.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('用户名已存在！');");
                    response.getWriter().println("location.href='register.jsp';");
                    response.getWriter().println("</script>");
                } else {
                    // 插入新用户
                    String insertSql = "INSERT INTO `user` (username, password, email) VALUES (?, ?, ?)";
                    stmt = conn.prepareStatement(insertSql);
                    stmt.setString(1, username);
                    stmt.setString(2, password);
                    stmt.setString(3, email); // 插入邮箱
                    stmt.executeUpdate();

                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('注册成功！" + username + "');");
                    response.getWriter().println("location.href='login.jsp';");
                    response.getWriter().println("</script>");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
}
