<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/12
  Time: 上午11:07
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession"%>
<%
    String serverAddress = "10.195.113.85";
%>
<html>
<head>
    <title>登录结果</title>
</head>
<body>

<%

    String jdbcUrl = "jdbc:mysql://"+serverAddress+":3306/test" ;
    String user = "root" ;
    String password = "1234" ;

    String username = request.getParameter("username");
    String password1 = request.getParameter("password");

    Connection conn = null;

    try {
        // 修复类名错误
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL Connector/J 8.x 版本的驱动类名
        conn = DriverManager.getConnection(jdbcUrl, user, password);

        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";
        PreparedStatement pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, username);
        pstmt.setString(2, password1);

        ResultSet rs = pstmt.executeQuery();

        if (rs.next()) {
            out.println("<script type='text/javascript'>");
            out.println("alert('登录成功！欢迎您，" + username + "!');");
            out.println("window.location.href='index.jsp';"); // 在 alert 确认后跳转
            out.println("</script>");
            session.setAttribute("username", username); // 将用户名存入 session

        } else {
            out.println("<script type='text/javascript'>");
            out.println("alert('登录失败！用户名或密码错误！');");
            out.println("window.location.href='login.jsp';"); // 在 alert 确认后跳转
            out.println("</script>");
        }

        rs.close(); // 关闭结果集
        pstmt.close(); // 关闭 PreparedStatement
        conn.close(); // 关闭连接

    } catch (SQLException e) {
        out.println("<p>数据库连接错误：" + e.getMessage() + "</p>");
    } catch (ClassNotFoundException e) {
        out.println("<p>数据库驱动未找到：" + e.getMessage() + "</p>");
    } finally {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close(); // 确保在异常发生时也能关闭连接
            }
        } catch (SQLException e) {
            out.println("<p>关闭连接时出错：" + e.getMessage() + "</p>");
        }
    }

%>
</body>
</html>