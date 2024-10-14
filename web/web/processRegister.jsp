<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/12
  Time: 下午1:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, javax.naming.*, javax.sql.*" %>
<html>
<head>
    <title>注册结果</title>
</head>
<body>

<%
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String confirmPassword = request.getParameter("confirmPassword");

    // 简单的表单验证
    if (username == null || username.isEmpty() || password == null || password.isEmpty() || confirmPassword == null || confirmPassword.isEmpty()) {
        out.println("<script type='text/javascript'>");
        out.println("alert('用户名、密码、确认密码不能为空！');");
        out.println("location.href='register.jsp';");
        out.println("</script>");
    } else if (!password.equals(confirmPassword)) {
        out.println("<script type='text/javascript'>");
        out.println("alert('密码和确认密码不一致！');");
        out.println("location.href='register.jsp';");
        out.println("</script>");
    } else {

        String serverIP = (String)session.getAttribute("serverIP");
        String jdbcUrl = "jdbc:mysql://"+serverIP+":3306/test"; // 数据库 URL
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
                out.println("<script type='text/javascript'>");
                out.println("alert('用户名已存在！');");
                out.println("location.href='register.jsp';");
                out.println("</script>");
            } else {
                // 插入新用户
                String insertSql = "insert into `user` (username,password)values(?,?)";
                stmt = conn.prepareStatement(insertSql);
                stmt.setString(1, username);
                stmt.setString(2, password);
                stmt.executeUpdate();

                out.println("<script type='text/javascript'>");
                out.println("alert('注册成功！"+username+"');");
                out.println("location.href='login.jsp';");
                out.println("</script>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

<p><a href="register.jsp">返回注册</a></p>
<p><a href="login.jsp">登录</a></p>

</body>
</html>
