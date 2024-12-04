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
        String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
        String rootname = "root"; // 数据库用户
        String rootpassword = "1234"; // 数据库密码

        String username = request.getParameter("username");
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
                    response.getWriter().println("window.location.href='products.jsp';"); // 登录成功后跳转
                    response.getWriter().println("</script>");
                } else {
                    response.getWriter().println("<script type='text/javascript'>");
                    response.getWriter().println("alert('登录失败！用户名或密码错误！');");
                    response.getWriter().println("window.location.href='login.jsp';"); // 登录失败返回登录界面
                    response.getWriter().println("</script>");
                }
            }

        } catch (SQLException e) {
            response.getWriter().println("<p>数据库连接错误：" + e.getMessage() + "</p>");
        } catch (ClassNotFoundException e) {
            response.getWriter().println("<p>数据库驱动未找到：" + e.getMessage() + "</p>");
        } catch (Exception e) {
            response.getWriter().println("<p>意外错误：" + e.getMessage() + "</p>");
        }
    }
}
