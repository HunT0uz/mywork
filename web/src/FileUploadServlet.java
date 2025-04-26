import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;
import org.apache.commons.fileupload.FileItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.util.List;

@WebServlet("/upload")
public class FileUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 设置响应内容类型
        response.setContentType("text/html;charset=UTF-8");

        // 获取字符流，可以使用writer.print()在页面打印值
        PrintWriter writer = response.getWriter();

        // 创建DiskFileItemFactory工厂对象
        DiskFileItemFactory factory = new DiskFileItemFactory();
        // 设置文件缓存目录
        File repository = (File) getServletContext().getAttribute("javax.servlet.context.tempdir");
        factory.setRepository(repository);

        // 创建 ServletFileUpload对象
        ServletFileUpload upload = new ServletFileUpload(factory);

        // 设置字符编码
        upload.setHeaderEncoding("UTF-8");

        // 解析请求的内容提取文件数据
        try {
            List<FileItem> formItems = upload.parseRequest(request);
            if (formItems != null && !formItems.isEmpty()) {
                // 迭代表单数据
                for (FileItem item : formItems) {
                    // 处理不在表单中的字段
                    if (!item.isFormField()) {
                        String fileName = new File(item.getName()).getName();
                        String filePath = getServletContext().getRealPath("/upload/img/");
                        File uploadDir = new File(filePath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        String serverFilePath = filePath + fileName;
                        File storeFile = new File(serverFilePath);
                        // 在控制台输出文件的上传路径
                        System.out.println("保存路径: " + serverFilePath);
                        // 保存文件到硬盘
                        item.write(storeFile);
                        // 上传成功后，不显示图片
                        writer.print("文件上传成功：" + fileName);
                    }
                }
            }
        } catch (Exception ex) {
            writer.print("错误信息：" + ex.getMessage());
        }
        // 如果直接访问，会重定向回添加商品页面
        response.sendRedirect(request.getContextPath() + "/addProduct.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 如果直接访问，会重定向回添加商品页面
        response.sendRedirect(request.getContextPath() + "/addProduct.jsp");
    }
}