import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/processMerchantLogin")
public class ProcessMerchantLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 从商家数据库中查询用户名和密码是否匹配
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 商家数据库 URL
        String rootname = "root"; // 数据库用户
        String rootpassword = "1234"; // 数据库密码

        String username = request.getParameter("merchantUsername");
        String password = request.getParameter("merchantPassword");

        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        Connection conn = null;

        try {
            // 加载 JDBC 驱动程序
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

            String sql = "SELECT * FROM test.merchant WHERE merchant_name = ? AND merchant_pwd = ?";
            PreparedStatement pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                session.setAttribute("merchantUsername", username); // 将商家用户名存入 session
                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('商家登录成功！欢迎您，" + username + "!');");
                response.getWriter().println("window.location.href='merchantDashboard.jsp';"); // 登录成功后跳转到商家仪表板
                response.getWriter().println("</script>");
            } else {

                response.getWriter().println("<script type='text/javascript'>");
                response.getWriter().println("alert('登录失败！商家用户名或密码错误！');");
                response.getWriter().println("window.location.href='merchantLogin.jsp';"); // 在 alert 确认后跳转
                response.getWriter().println("</script>");
            }

            rs.close(); // 关闭结果集
            pstmt.close(); // 关闭 PreparedStatement

        } catch (SQLException e) {
            response.getWriter().println("<p>数据库连接错误：" + e.getMessage() + "</p>");
        } catch (ClassNotFoundException e) {
            response.getWriter().println("<p>数据库驱动未找到：" + e.getMessage() + "</p>");
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            try {
                if (conn != null && !conn.isClosed()) {
                    conn.close(); // 确保在异常发生时也能关闭连接
                }
            } catch (SQLException e) {
                response.getWriter().println("<p>关闭连接时出错：" + e.getMessage() + "</p>");
            }
        }
    }
}
