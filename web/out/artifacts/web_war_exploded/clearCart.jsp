<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 清空购物车
    session.removeAttribute("cart"); // 移除购物车
    response.sendRedirect("products.jsp"); // 重定向回购物车
%>
