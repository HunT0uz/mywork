import javax.mail.*;
import javax.mail.internet.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;
import java.util.Properties;

import static java.lang.System.out;

@WebServlet("/ShipOrderServlet")
public class ShipOrderServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String orderNumber = request.getParameter("orderNumber");
        String productId = request.getParameter("productId");
        String receiverUsername = request.getParameter("receiverName"); // 收货人的用户名
        String productName = request.getParameter("productName"); // 从请求中获取产品名称

        if (orderNumber == null || productId == null || receiverUsername == null || productName == null) {
            response.sendRedirect("orderManagement?error=missing_parameters");
            return;
        }

        Connection conn = null;
        PreparedStatement pstmt = null;
        String receiverEmail = null;

        try {
            // 加载数据库驱动
            Class.forName("com.mysql.cj.jdbc.Driver");

            // 连接数据库
            String dbURL = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "1234";
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // 根据用户名查询邮箱的 SQL 语句
            String emailSql = "SELECT email FROM user WHERE username = ?";
            pstmt = conn.prepareStatement(emailSql);
            pstmt.setString(1, receiverUsername);

            // 执行查询
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                receiverEmail = rs.getString("email"); // 获取邮箱
            } else {
                response.sendRedirect("orderManagement?error=user_not_found");
                return;
            }

            // 输出调试信息
            out.println("接收到的参数: ");
            out.println("订单号: " + orderNumber);
            out.println("产品ID: " + productId);
            out.println("收货人用户名: " + receiverUsername);
            out.println("产品名称: " + productName);
            out.println("查询到的收货人邮箱: " + receiverEmail);

            // 更新订单状态的 SQL 语句
            String sql = "UPDATE orders SET status = ? WHERE order_number = ? AND product_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "已发货");
            pstmt.setString(2, orderNumber);
            pstmt.setString(3, productId);

            // 执行更新
            int rowsAffected = pstmt.executeUpdate();
            boolean updateSuccess = (rowsAffected > 0);

            // 输出调试信息
            out.println("更新订单状态的 SQL 语句执行结果: " + updateSuccess);
            // 如果更新成功，发送邮件
            if (updateSuccess) {
                String subject = "订单已发货通知"; // 邮件主题
                String body = "尊敬的 " + receiverUsername + "，您的订单 " + orderNumber + " 的产品 " + productName + " （产品ID: " + productId +"）已发货！感谢您的购买！"; // 邮件内容
                sendEmail(receiverEmail, subject, body); // 发送邮件
                response.sendRedirect("orderManagement?success=true");
            } else {
                response.sendRedirect("orderManagement?error=update_failed");
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect("orderManagement?error=class_not_found");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendRedirect("orderManagement?error=sql_exception");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orderManagement?error=unknown_exception");
        } finally {
            // 关闭资源
            try {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    public static void sendEmail(String to, String subject, String body) {
        // 设置邮件服务器的属性
        Properties properties = new Properties();
        properties.setProperty("mail.smtp.host", "smtp.163.com"); // SMTP 服务器地址
        properties.setProperty("mail.smtp.port", "465"); // SMTP 端口
        properties.setProperty("mail.smtp.auth", "true");/// 启用 SMTP 认证
        properties.setProperty("mail.smtp.ssl.trust", "smtp.163.com"); // 信任的 SMTP 服务器地址
        properties.setProperty("mail.smtp.starttls.enable", "true");// 启用 STARTTLS
        properties.setProperty("mail.smtp.ssl.enable", "true"); // 确保启用 SSL
        properties.setProperty("mail.smtp.charset", "utf-8"); // SMTP 服务器地址
        properties.setProperty("mail.transport.protocol", "smtp");// 邮件传输协议

        // 创建会话对象
        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("web_brians_shop@163.com", "KQvEh3845z9sjHWg"); // 发送邮箱和密码
            }
        });

        try {
            // 创建邮件消息
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress("web_brians_shop@163.com")); // 发件人
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to)); // 收件人
            message.setSubject(subject); // 邮件主题
            message.setText(body); // 邮件内容

            // 使用 Transport 对象发送邮件
            Transport transport = session.getTransport("smtp");
            transport.connect(); // 连接
            transport.sendMessage(message, message.getAllRecipients()); // 发送邮件
            transport.close(); // 关闭连接

            System.out.println("邮件发送成功");
        } catch (MessagingException e) {
            System.out.println(e.getMessage());
            e.printStackTrace();
        }
    }
}
