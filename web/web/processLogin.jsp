<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.net.*" %>
<%@ page import="javax.servlet.http.HttpSession"%>

<html>
<head>
    <title>登录结果</title>
</head>
<body>

<%
    String serverIP = (String)session.getAttribute("serverIP");
    String jdbcUrl = "jdbc:mysql://"+serverIP+":3306/test"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    String username = request.getParameter("username");
    String password1 = request.getParameter("password");

    Connection conn = null;

    try {
        // 修复类名错误
        Class.forName("com.mysql.cj.jdbc.Driver"); // MySQL Connector/J 8.x 版本的驱动类名
        conn = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        String sql = "SELECT * FROM test.user WHERE username = ? AND password = ?";
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
