<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>贪吃蛇游戏</title>
    <style>
        .button {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            color: white;
            background-color: green;
            text-decoration: none;
            border-radius: 5px;
        }
    </style>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        canvas {
            border: 2px solid black;
        }
        #score {
            position: absolute;
            top: 10px;
            left: 10px;
            font-size: 20px;
            color: white;
        }
    </style>
</head>
<body>
<canvas id="gameCanvas" width="500" height="500"></canvas>
<div id="score">Score: 0</div>
<script>
    const canvas = document.getElementById('gameCanvas');
    const ctx = canvas.getContext('2d');
    const scoreDisplay = document.getElementById('score');

    const boxSize = 20;
    const canvasSize = 500;
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
        food = {
            x: Math.floor(Math.random() * (canvasSize / boxSize)) * boxSize,
            y: Math.floor(Math.random() * (canvasSize / boxSize)) * boxSize,
        };
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

        // 仅在超过设定延迟的情况下才处理按键事件
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

    snake.push({ x: boxSize * 2, y: boxSize });
    snake.push({ x: boxSize, y: boxSize });
    snake.push({ x: 0, y: boxSize });

    generateFood();
    scoreDisplay.textContent = 'Score: 0';
    draw();
</script>
    <a href="userCenter.jsp" class="button">返回主页</a>
</body>
</html>