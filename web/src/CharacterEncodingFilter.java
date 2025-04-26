import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CharacterEncodingFilter implements Filter {
    private String encoding;

    @Override
    public void init(FilterConfig filterConfig) {
        encoding = filterConfig.getInitParameter("encoding");
        if (encoding == null) {
            encoding = "UTF-8"; // 默认编码
        }
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // 设置请求编码
        if (request instanceof HttpServletRequest) {
            request.setCharacterEncoding(encoding);
        }

        // 设置响应编码
        if (response instanceof HttpServletResponse) {
            response.setCharacterEncoding(encoding);
            response.setContentType("text/html; charset=" + encoding);
        }

        // 继续处理请求
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // 资源清理
    }
}
