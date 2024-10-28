import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.ResultSet;

import org.json.JSONException;
import org.json.JSONObject;
@WebServlet("/saveSnakeScore")
public class SaveSnakeScoreServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
    // 游戏结束时，将得分设置到隐藏表单中并提交
        String scoreStr = request.getParameter("snakescore");
        int snakescore = Integer.parseInt(scoreStr); // 获取得分
        // 读取请求体中的得分
        StringBuilder sb = new StringBuilder();
        String line;
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        //int snakescore = Integer.parseInt(sb.toString().split(":")[1].replaceAll("[^0-9]", "")); // 获取得分

        // 数据库连接信息
        String jdbcUrl = "jdbc:mysql://localhost:3306/test";
        String dbUser = "root";
        String dbPassword = "1234";

        try (Connection connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword)) {
            // 首先查询用户的当前最高得分
            String checkSql = "SELECT snakescore FROM test.user WHERE username = ?";
            PreparedStatement checkStatement = connection.prepareStatement(checkSql);
            checkStatement.setString(1, username);
            ResultSet resultSet = checkStatement.executeQuery();

            int currentHighScore = 0; // 当前最高分

            if (resultSet.next()) {
                currentHighScore = resultSet.getInt("snakescore");
            }

            // 只有在新分数比当前最高分高时才进行更新
            if (snakescore > currentHighScore) {
                String updateSql = "UPDATE test.user SET snakescore = ? WHERE username = ?";
                PreparedStatement updateStatement = connection.prepareStatement(updateSql);
                updateStatement.setInt(1, snakescore);
                updateStatement.setString(2, username);
                updateStatement.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        String redirectUrl =request.getContextPath() + "/Snake.jsp";
        response.sendRedirect(redirectUrl);
    }
}
