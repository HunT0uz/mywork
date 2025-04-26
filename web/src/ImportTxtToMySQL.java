import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ImportTxtToMySQL {
    public static void main(String[] args) {
        String jdbcURL = "jdbc:mysql://localhost:3306/test"; // 替换为你的数据库名
        String username = "root"; // 替换为你的用户名
        String password = "1234"; // 替换为你的密码
        String filePath = "E:\\DesktopData\\111.txt"; // 替换为你的TXT文件路径
        String driver = "com.mysql.cj.jdbc.Driver"; // 驱动名

        try {
            Class.forName(driver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }


        String insertSQL = "INSERT INTO test.jokes (id, content) VALUES (?, ?)";

        try (Connection connection = DriverManager.getConnection(jdbcURL, username, password);
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL);
             BufferedReader br = new BufferedReader(new FileReader(filePath))) {

            String line;
            while ((line = br.readLine()) != null) {
                String[] values = line.split("\\."); // 根据你的文件格式调整分隔符
                if (values.length >= 2) { // 确保有足够的列
                    preparedStatement.setString(1, values[0].trim());
                    preparedStatement.setString(2, values[1].trim());
                    preparedStatement.addBatch(); // 添加到批处理
                }
            }

            preparedStatement.executeBatch(); // 执行批处理
            System.out.println("Data imported successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}