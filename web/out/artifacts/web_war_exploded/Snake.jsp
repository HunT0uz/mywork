<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>贪吃蛇游戏</title>
    <style>
        body {
            display: flex;
            flex-direction: column; /* 纵向布局 */
            align-items: center; /* 垂直居中 */
            height: 100vh;
            margin: 0;
            background-color: #f9f9f9; /* 可选背景颜色 */
        }
        #container {
            display: flex; /* 使用 Flexbox 布局 */
            justify-content: space-between; /* 左右对齐 */
            width: 80%; /* 设置容器宽度 */
            max-width: 1200px; /* 最大宽度 */
            margin-top: 20px; /* 顶部边距 */
        }
        #gameContainer {
            width: 50%; /* 设置游戏区域宽度 */
            display: flex;
            flex-direction: column;
            align-items: center; /* 内容居中 */
        }
        canvas {
            border: 2px solid black;
            width: 500px; /* 设置Canvas宽度 */
            height: 500px; /* 设置Canvas高度 */
        }
        #score {
            position: absolute; /* 绝对定位 */
            top: 10px;
            left: 10px;
            font-size: 20px;
            color: black; /* 改为黑色 */
            z-index: 10; /* 确保得分在最上层 */
        }
        h2 {
            margin: 20px 0; /* 标题的上下边距 */
            text-align: center; /* 标题居中 */
        }
        table {
            border-collapse: collapse; /* 合并边框 */
            width: 100%; /* 设置表格宽度 */
            max-width: 400px; /* 设置表格最大宽度 */
        }
        th, td {
            border: 1px solid #ddd; /* 边框 */
            padding: 8px; /* 内边距 */
            text-align: center; /* 文字居中 */
        }
        th {
            background-color: #f2f2f2; /* 表头背景色 */
        }
        .button {
            display: inline-block; /* 使按钮成为内联块，方便设置样式 */
            background-color: green; /* 绿色背景 */
            color: white; /* 白色文字 */
            padding: 10px 20px; /* 内边距 */
            text-decoration: none; /* 去除下划线 */
            border: none; /* 去掉边框 */
            border-radius: 5px; /* 添加圆角 */
            cursor: pointer; /* 鼠标悬停时更改为手型光标 */
            font-size: 16px; /* 字体大小 */
            margin-top: 20px; /* 顶部边距 */
        }
        .button:hover {
            background-color: darkgreen; /* 鼠标悬停时更深的绿色 */
        }
        /* 对于按钮的容器，确保居中对齐 */
        .button-container {
            display: flex;
            justify-content: center; /* 中心对齐 */
            margin-top: 10px; /* 顶部边距 */
        }
    </style>
</head>
<body>

<div id="container">
    <!-- 游戏区域 -->
    <div id="gameContainer">
        <canvas id="gameCanvas" width="500" height="500"></canvas>
        <div id="score">Score: 0</div> <!-- 得分显示 -->
    </div>

    <!-- 排行榜区域 -->
    <div id="leaderboardContainer" style="width: 400px;"> <!-- 设置固定宽度 -->
        <h2>排行榜</h2>

        <table>
            <tr>
                <th>用户名</th>
                <th>得分</th>
            </tr>
            <%
                String jdbcUrl = "jdbc:mysql://localhost:3306/test"; // 数据库 URL
                String dbUser = "root"; // 数据库用户名
                String dbPassword = "1234"; // 数据库密码

                Connection connection = null;
                List<Map<String, Object>> leaderboard = new ArrayList<>();

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    connection = DriverManager.getConnection(jdbcUrl, dbUser, dbPassword);
                    String sql = "SELECT username, snakescore FROM test.user WHERE snakescore > 0 ORDER BY snakescore DESC";
                    Statement statement = connection.createStatement();
                    ResultSet resultSet = statement.executeQuery(sql);

                    while (resultSet.next()) {
                        Map<String, Object> row = new HashMap<>();
                        row.put("username", resultSet.getString("username"));
                        row.put("snakescore", resultSet.getInt("snakescore"));
                        leaderboard.add(row);
                    }
                } catch (SQLException | ClassNotFoundException e) {
                    e.printStackTrace();
                } finally {
                    if (connection != null) {
                        try {
                            connection.close();
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Map<String, Object> entry : leaderboard) {
            %>
            <tr>
                <td><%= entry.get("username") %></td>
                <td><%= entry.get("snakescore") %></td>
            </tr>
            <%
                }
            %>
        </table>

        <!-- 返回主页按钮 容器让它居中 -->
        <div class="button-container">
            <a href="userCenter.jsp" class="button">返回主页</a>
        </div>
    </div>
</div>

<!-- 提交得分的隐藏表单 -->
<form id="scoreForm" action="saveSnakeScore" method="post" style="display: none;">
    <input type="hidden" name="snakescore" id="snakescore" value="">
</form>

<script>
    // JavaScript 代码
    const canvas = document.getElementById('gameCanvas');
    const ctx = canvas.getContext('2d');
    const scoreDisplay = document.getElementById('score');

    const boxSize = 20;
    const canvasSize = 500; // 调整为新的canvas size
    let snake = [];
    let direction = 'right';
    let food = {};
    let score = 0;

    function drawSnakePart(x, y) {
        ctx.fillStyle = 'green';
        ctx.fillRect(x, y, boxSize, boxSize);
        ctx.strokeStyle = 'black';
        ctx.strokeRect(x, y, boxSize, boxSize);
    }

    function drawFood(x, y) {
        ctx.fillStyle = 'red';
        ctx.fillRect(x, y, boxSize, boxSize);
        ctx.strokeStyle = 'black';
        ctx.strokeRect(x, y, boxSize, boxSize);
    }

    function generateFood() {
        do {
            food = {
                x: Math.floor(Math.random() * (canvasSize / boxSize)) * boxSize,
                y: Math.floor(Math.random() * (canvasSize / boxSize)) * boxSize,
            };
        } while (checkCollision(food.x, food.y, snake)); // 检查生成的食物是否与蛇重叠
    }

    function checkCollision(x, y, array) {
        for (let i = 0; i < array.length; i++) {
            if (x === array[i].x && y === array[i].y) {
                return true;
            }
        }
        return false;
    }

    function draw() {
        ctx.clearRect(0, 0, canvasSize, canvasSize);
        const headX = snake[0].x + (direction === 'right' ? boxSize : direction === 'left' ? -boxSize : 0);
        const headY = snake[0].y + (direction === 'down' ? boxSize : direction === 'up' ? -boxSize : 0);

        if (
            headX < 0 ||
            headX >= canvasSize ||
            headY < 0 ||
            headY >= canvasSize ||
            checkCollision(headX, headY, snake)
        ) {
            // 游戏结束时，将得分设置到隐藏表单中并提交
            document.getElementById('snakescore').value = score; // 将得分放入隐藏输入框
            document.getElementById('scoreForm').submit(); // 提交表单
            alert('游戏结束！得分：' + score);
            score = 0;
            snake.length = 0;
            direction = 'right';
            snake.push({ x: boxSize * 2, y: boxSize });
            generateFood();
            scoreDisplay.textContent = 'Score: 0';
            draw();
            return;
        }

        if (headX === food.x && headY === food.y) {
            score += 10;
            scoreDisplay.textContent = 'Score: ' + score;
            generateFood();
        } else {
            snake.pop();
        }

        const newHead = { x: headX, y: headY };
        snake.unshift(newHead);

        for (let i = 0; i < snake.length; i++) {
            const { x, y } = snake[i];
            drawSnakePart(x, y);
        }

        drawFood(food.x, food.y);
        setTimeout(draw, 250);
    }

    let lastKeyTime = 0; // 记录上一次按键的时间
    const keyDelay = 200; // 设定延迟时间为 200ms

    document.addEventListener('keydown', (event) => {
        const currentTime = new Date().getTime(); // 获取当前时间
        if (currentTime - lastKeyTime > keyDelay) {
            const key = event.key;
            // 处理按键逻辑
            if ((key === 'w' || key === 'ArrowUp') && direction !== 'down') {
                direction = 'up';
            } else if ((key === 's' || key === 'ArrowDown') && direction !== 'up') {
                direction = 'down';
            } else if ((key === 'a' || key === 'ArrowLeft') && direction !== 'right') {
                direction = 'left';
            } else if ((key === 'd' || key === 'ArrowRight') && direction !== 'left') {
                direction = 'right';
            }
            lastKeyTime = currentTime; // 更新上一次按键时间
        }
    });

    // 初始化蛇的长度
    snake.push({ x: boxSize * 2, y: boxSize });
    snake.push({ x: boxSize, y: boxSize });
    snake.push({ x: 0, y: boxSize });

    generateFood();
    scoreDisplay.textContent = 'Score: 0';
    draw();
</script>

</body>
</html>
