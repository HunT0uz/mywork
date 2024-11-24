import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/processLogin")
public class ProcessLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
<<<<<<< Updated upstream
        // 从数据库中查询用户名和密码是否匹配
=======
>>>>>>> Stashed changes
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
        String rootname = "root"; // 数据库用户
        String rootpassword = "1234"; // 数据库密码

        String username = request.getParameter("username");
<<<<<<< Updated upstream
        String password1 = request.getParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Connection conn = null;

        try {
            // 加载 JDBC 驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL Connector/J 8.x 版本的驱动类名
            conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

            String sql = "SELECT * FROM test.user WHERE username = ? AND password = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password1);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("username", username); // 将用户名存入 session
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('登录成功！欢迎您，" + username + "!');");
                response.getWriter().println("window.location.href='index.jsp';"); // 在 alert 确认后跳转
                response.getWriter().println("</script>");
            } else {
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('登录失败！用户名或密码错误！');");
                response.getWriter().println("window.location.href='login.jsp';"); // 在 alert 确认后跳转
                response.getWriter().println("</script>");
            }

            rs.close(); // 关闭结果集
            pstmt.close(); // 关闭 PreparedStatement

=======
        String password = request.getParameter("password");

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();

        try (Connection conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);
             PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM test.user WHERE username = ? AND password = ?")) {

            Class.forName("com.mysql.cj.jdbc.Driver"); // 加载 JDBC 驱动程序

            pstmt.setString(1, username);
            pstmt.setString(2, password); // 在实际应用中建议使用加密过的密码进行比对

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    session.setAttribute("username", username); // 将用户名存入 session
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('登录成功！欢迎您，" + username + "!');");
                    response.getWriter().println("window.location.href='index.jsp';"); // 登录成功后跳转
                    response.getWriter().println("</script>");
                } else {
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('登录失败！用户名或密码错误！');");
                    response.getWriter().println("window.location.href='login.jsp';"); // 登录失败返回登录界面
                    response.getWriter().println("</script>");
                }
            }

>>>>>>> Stashed changes
        } catch (SQLException e) {
            response.getWriter().println("<p>数据库连接错误：" + e.getMessage() + "</p>");
        } catch (ClassNotFoundException e) {
            response.getWriter().println("<p>数据库驱动未找到：" + e.getMessage() + "</p>");
        } catch (Exception e) {
<<<<<<< Updated upstream
            throw new RuntimeException(e);
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close(); // 确保在异常发生时也能关闭连接
                }
            } catch (SQLException e) {
                response.getWriter().println("<p>关闭连接时出错：" + e.getMessage() + "</p>");
            }
=======
            response.getWriter().println("<p>意外错误：" + e.getMessage() + "</p>");
>>>>>>> Stashed changes
        }
    }
}
