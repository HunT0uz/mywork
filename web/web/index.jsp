<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>
<%
  //获取本地direccion IP地址
  String serverIP = "192.168.20.143";
  session.setAttribute("serverIP", serverIP); // 将服务器IP存入 session
%>
<html>
<head>
  <title>我爱鼠哥</title>
  <style>
    .button {
      display: inline-block;
      padding: 10px 20px;
      font-size: 16px;
      color: white;
      background-color: green;
      text-decoration: none;
      border-radius: 5px;
    }
    #joke {
      position: absolute;
      top: 10px;
      right: 10px;
      background-color: #f9f9f9;
      border: 1px solid #ddd;
      padding: 10px;
      border-radius: 5px;
    }
  </style>
</head>
<body>
<h1>我爱鼠哥</h1>
<p>hello, world!<p>
<p><%=serverIP%></p>
<p><a href="https://www.bilibili.com/video/BV1GJ411x7h7/" class="button">哔哩哔哩</a><p>
<p><a href="<%= "http://" + serverIP + ":8080/web_war_exploded/test.jsp" %>" class="button">查询</a></p>
<% if(session.getAttribute("username") == null){ %>
<p><a href="<%= "http://"+ serverIP + ":8080/web_war_exploded/login.jsp" %>" class="button">登录</a></p>
<% } %>
<% if(session.getAttribute("username")!= null){ %>
<p><a href="<%= "http://" + serverIP + ":8080/web_war_exploded/userCenter.jsp" %>" class="button">个人中心</a></p>
<% } %>

<div id="joke">
  <%

    String jdbcUrl = "jdbc:mysql://"+serverIP+":3306/test"; // 数据库 URL
    String rootname = "root"; // 数据库用户
    String rootpassword = "1234"; // 数据库密码

    Connection connection = null;
    String jokeText = ""; // 用于存储笑话文本

    try {
      // 加载 JDBC 驱动程序
      Class.forName("com.mysql.cj.jdbc.Driver");

      // 建立连接
      connection = DriverManager.getConnection(jdbcUrl, rootname, rootpassword);

      // 创建一个 Statement 对象来执行 SQL 查询
      Statement statement = connection.createStatement();
      ResultSet resultSet = statement.executeQuery("SELECT * FROM jokes ORDER BY RAND() LIMIT 1");

      if (resultSet.next()) {
        jokeText = resultSet.getString("content"); // 假设笑话文本存储在名为 joke_text 的列
      }

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
    out.println("<p>" + jokeText + "</p>");
  %>
</div>

</body>
</html>
