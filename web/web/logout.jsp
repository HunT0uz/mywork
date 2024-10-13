<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Logout</title>
</head>
<body>
<script>
    alert("退出成功！");
    window.location.href = "${pageContext.request.contextPath}/index.jsp";
</script>
<%
    // 使用Java代码在服务器端销毁session
    session = request.getSession();
    session.invalidate();
%>
</body>
</html>