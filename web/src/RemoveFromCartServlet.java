import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/removeFromCart")
public class RemoveFromCartServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String productNameToRemove = request.getParameter("productNameToRemove");

        // 从 session 中获取购物车
        List<String> cart = (List<String>) request.getSession().getAttribute("cart");
        if (cart != null) {
            cart.remove(productNameToRemove); // 删除指定商品
        }

        // 重定向回购物车页面，并携带消息
        response.sendRedirect(request.getContextPath() + "/cart.jsp");
    }
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果直接访问，会重定向回添加商品页面
        String message = "请通过表单提交来删除商品。";
        ServletContext sc = getServletContext();
        RequestDispatcher rd = sc.getRequestDispatcher("/cart.jsp"); //定向的页面
        rd.forward(request, response);
        response.sendRedirect(request.getContextPath() + "/cart.jsp" );
    }
}
