<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*" %>
<%@ page import="java.sql.*" %>

<html>
<head>
  <meta charset="UTF-8">
  <title>我爱鼠哥</title>
  <style>
    body {
      background-image: url('upload/img/index_bg.jpg'); /* 替换为你的背景图片路径 */
      background-size: contain; /* 背景图片保持原始比例并完整显示 */
      background-position: top center; /* 背景图片居中 */
      background-repeat: no-repeat; /* 不重复背景图片 */
      color: black; /* 默认文字颜色设置为白色 */
      min-height: 100vh; /* 最小高度为100%视口高度 */
      margin: 0; /* 清除默认边距 */
      overflow: hidden; /* 取消滑动条 */
    }

    h1 {
      text-align: center; /* 标题居中 */
      margin-top: 20px; /* 顶部间距 */
    }

    .button {
      display: inline-block;
      padding: 5px 10px; /* 按钮内边距 */
      font-size: 14px; /* 字体大小 */
      color: white; /* 按钮文字颜色 */
      background-color: green;
      text-decoration: none;
      border-radius: 5px;
      transition: background-color 0.3s;
      margin: 20px auto; /* 按钮居中并添加间距 */
      width: 150px; /* 设置按钮的固定宽度 */
      text-align: center; /* 文本居中 */
    }

    .button:hover {
      background-color: darkgreen; /* 鼠标悬停时改变按钮颜色 */
    }

    #joke, #intro {
      position: relative; /* 设置相对定位 */
      background-color: rgba(249, 249, 249, 0.8); /* 使背景稍透明以突出文字 */
      border: 1px solid #ddd;
      padding: 15px;
      border-radius: 5px;
      margin: 20px auto; /* 设置上下间距并居中 */
      max-width: 600px; /* 最大宽度 */
      z-index: 1; /* 确保这两个部分显示在背景图片上方 */
    }

    #joke {
      margin-top: 40px; /* 为笑话部分添加顶部间距 */
    }

    @keyframes fadeIn {
      from { opacity: 0; }
      to { opacity: 1; }
    }
  </style>
</head>
<body>
<h1>我爱鼠哥</h1>
<p style="text-align: center;">hello, world!</p>

<!-- 网站介绍部分 -->
<div id="intro">
  <h2>欢迎来到我的网站!</h2>
  <p>这个网站是为了分享有趣的笑话和有意思的商品而创建的。希望能够给您带来欢笑和快乐！</p>
  <p>本网站采用jsp+servlet开发，服务器采用tomcat，数据库采用mysql。</p>
  <p>请随时浏览我们的商品</p>
</div>

<p style="text-align: center;"><a href="products.jsp" class="button">开始旅程</a></p>

<div id="joke">
  <%
    String jdbcUrl = "jdbc:mysql://localhost:3306/test?useUnicode=true&characterEncoding=utf8&serverTimezone=UTC"; // 数据库 URL
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
