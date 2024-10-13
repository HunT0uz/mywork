<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/10
  Time: 下午8:30
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*" %>
<html>
<head>
    <title>数据库连接示例</title>
</head>
<body>
<%
    String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
    String username = "root"; // 数据库用户
    String password = "1234"; // 数据库密码

    Connection connection = null;

    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, username, password);

        // 创建一个 Statement 对象来执行 SQL 查询
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT * FROM stest");

        // 处理结果集
        while (resultSet.next()) {
            out.println("<p>" + resultSet.getString("your_column_name") + "</p>");
        }

    } catch (SQLException e) {
        e.printStackTrace(outcatch (SQLException e) {
    out.println("SQL错误: " + e.getMessage());
}
);
    } catch (ClassNotFoundException e) {
        out.println("驱动程序未找到: " + e.getMessage());
    } finally {
        // 关闭资源
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
                e.printStackTrace(out);
            }
        }
    }
%>
</body>
</html>
