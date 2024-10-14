<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.net.*" %>
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
</body>
</html>
