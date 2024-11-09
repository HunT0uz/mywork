<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>

<%
    // 获取商品名称
    String product = request.getParameter("product");

    // 获取购物车
    List<String> cart = (List<String>) session.getAttribute("cart");
    if (cart == null) {
        cart = new ArrayList<>();
    }

    // 添加商品到购物车
    if (product != null) {
        cart.add(product);
        session.setAttribute("cart", cart);
    }

    // 重定向回商品页面
    //response.sendRedirect("products.jsp");
    //out.println("alert(' "+product+"商品已经添加到购物车！');");
    response.sendRedirect("products.jsp?added=true");
%>
