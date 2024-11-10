<%@ page import="java.net.*" %>
<%@ page import="java.io.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>每日冷笑话</title>
</head>
<body>
<h1>今日冷笑话</h1>
<%
    String jokeUrl = "http://api.icndb.com/jokes/random";
    try {
        URL url = new URL(jokeUrl);
        BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
        String inputLine;
        StringBuilder responser = new StringBuilder();

        while ((inputLine = reader.readLine()) != null) {
            responser.append(inputLine);
        }
        reader.close();

        // 解析JSON响应以获取笑话文本
        JSONObject jsonObject = new JSONObject(response.toString());
        String joke = jsonObject.getString("value");
        out.println("<blockquote>" + joke + "</blockquote>");
    } catch (IOException e) {
        e.printStackTrace();
    }
%>
<script src="https://cdn.jsdelivr.net/npm/json@latest/json.min.js"></script>
</body>
</html>