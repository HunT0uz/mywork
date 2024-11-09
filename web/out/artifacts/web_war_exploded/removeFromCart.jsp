<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
//这个有点问题，后续改
<%
    // 获取要删除的商品名称
    String productNameToRemove = request.getParameter("productName");

    // 获取购物车
    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart != null && productNameToRemove != null) {
        // 从购物车中移除该商品
        cart.remove(productNameToRemove);
        session.setAttribute("cart", cart);
    }

    // 重定向回购物车页面
    response.sendRedirect("cart.jsp");
%>
