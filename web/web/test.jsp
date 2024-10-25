<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<html>
<head>
    <meta charset="UTF-8">
    <title>数据库连接示例</title>
</head>
<body>
<%
    String serverIP = (String)session.getAttribute("serverIP");
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    Connection connection = null;

    try {
        // 加载 JDBC 驱动程序
        Class.forName("com.mysql.cj.jdbc.Driver");

        // 建立连接
        connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

        // 创建一个 Statement 对象来执行 SQL 查询
        Statement statement = connection.createStatement();
        ResultSet resultSet = statement.executeQuery("SELECT * FROM user");

        // 获取元数据以获取列信息
        ResultSetMetaData metaData = resultSet.getMetaData();
        int columnCount = metaData.getColumnCount();

        // 创建表格
        out.println("<table border='1'>");
        out.println("<tr>");
        // 输出表头
        for (int i = 1; i <= columnCount; i++) {
            out.println("<th>" + metaData.getColumnName(i) + "</th>");
        }
        out.println("</tr>");

        // 输出数据行
        while (resultSet.next()) {
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<td>" + resultSet.getString(i) + "</td>");
            }
            out.println("</tr>");
        }
        out.println("</table>");

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("SQL错误: " + e.getMessage());

    } catch (ClassNotFoundException e) {
        out.println("驱动程序未找到: " + e.getMessage());
    } finally {
        // 关闭资源
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException e) {
            }
        }
    }
%>
</body>
</html>
