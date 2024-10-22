<%--
  Created by IntelliJ IDEA.
  User: ROG
  Date: 2024/10/14
  Time: 下午3:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<style>
    .c {
        margin: 1px;
        width: 19px;
        height: 19px;
        background: red;
        position: absolute;
    }

    .d {
        margin: 1px;
        width: 19px;
        height: 19px;
        background: gray;
        position: absolute;
    }

    .f {
        top: 0px;
        left: 0px;
        background: black;
        position: absolute;
    }

    .info {
        top: 0px;
        background: black;
        position: absolute;
        color: white;
    }

    body {
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
        margin: 0;
    }

    #tetrisBoard {
        position: relative;
    }
</style>
<body>
<!-- 游戏内容 -->
<div id="tetrisBoard"></div>
<!-- 返回按钮 -->
<a href="userCenter.jsp" class="button">返回首页</a>

<a href="userCenter.jsp" class="button">返回个人中心</a>
</body>
</html>
<script>
    var over = false;
    var stop = false;
    var level = 1;
    //定义方块形状
    var shapes = (
        "0,1,1,1,2,1,3,1;" +
        "1,0,1,1,1,2,2,2;" +
        "2,0,2,1,2,2,1,2;" +
        "0,1,1,1,1,2,2,2;" +
        "1,2,2,2,2,1,3,1;" +
        "1,1,2,1,1,2,2,2;" +
        "0,2,1,2,1,1,2,2").split(";");
    //定义下一方块形状
    var nextShape = null;

    /**
     * 创建方块元素
     * @param tag 元素标签
     * @param css 样式
     */
    function create(tag, css) {
        var elm = document.createElement(tag);
        elm.className = css;
        document.body.appendChild(elm);
        return elm;
    }

    /**
     * 获得下落的方块
     * @param c css样式名称
     * @param t 方块坐标点集合，方块样式集合
     * @param x 初始位置x位置
     * @param y 初始位置y位置
     */
    function Tetris(c, t, x, y) {
        var c = c ? c : "c";
        //当前方块
        this.divs = [create("div", c), create("div", c), create("div", c), create("div", c)];
        //下一方块
        if ("d" != c) {
            this.nextDivs = [create("div", c), create("div", c), create("div", c), create("div", c)];
        }
        /**
         * 重置
         */
        this.reset = function () {
            this.x = typeof x != 'undefined' ? x : 3;
            this.y = typeof y != 'undefined' ? y : 0;
            this.shape = t ? t : (nextShape ? nextShape : shapes[Math.floor(Math.random() * (shapes.length - 0.00001))].split(","));
            if ("d" != c) {
                nextShape = t ? t : shapes[Math.floor(Math.random() * (shapes.length - 0.00001))].split(",");
            }
            this.show();
            if (this.field && this.field.check(this.shape, this.x, this.y, 'v') == 'D') {
                over = true;
                this.field.fixShape(this.shape, this.x, this.y);
                if (confirm("Game Over! ")) {
                    // 确认后跳转到新的 JSP 页面
                    window.location.href = "tetris.jsp"; // 将"nextPage.jsp"替换为目标 JSP 文件名
                }
                }
        };
        /**
         * 显示
         */
        this.show = function () {
            //当前方块组装
            for (var i in this.divs) {
                this.divs[i].style.left = (this.shape[i * 2] * 1 + this.x) * 20 + 'px';
                this.divs[i].style.top = (this.shape[i * 2 + 1] * 1 + this.y) * 20 + 'px';
            }
            if ("d" != c) {
                //下一方块组装
                for (var i in this.nextDivs) {
                    this.nextDivs[i].style.left = (nextShape[i * 2] * 1 + 16) * 20 + 'px';
                    this.nextDivs[i].style.top = (nextShape[i * 2 + 1] * 1 + 0) * 20 + 'px';
                }
            }
        };
        this.field = null;
        /**
         * 左右移动
         * @param step
         */
        this.hMove = function (step) {
            if(stop) return;
            var r = this.field.check(this.shape, this.x - -step, this.y, 'h');
            if (r != 'N' && r == 0) {
                this.x -= -step;
                this.show();
            }
        };
        /**
         * 向下移动
         */
        this.vMove = function () {
            if(stop) return;
            if (this.field.check(this.shape, this.x, this.y - -1, 'v') == 'N') {
                this.y++;
                this.show();
            }
            else {
                //冻结方块
                this.field.fixShape(this.shape, this.x, this.y);
                //查找填满的行，并消除
                this.field.findFull();
                //重置方块
                this.reset();
            }
        };
        /**
         * 旋转
         */
        this.rotate = function () {
            if(stop) return;
            var s = this.shape;
            var newShape = [3 - s[1], s[0], 3 - s[3], s[2], 3 - s[5], s[4], 3 - s[7], s[6]];
            var r = this.field.check(newShape, this.x, this.y, 'h');
            if (r == 'D') return;
            if (r == 0) {
                this.shape = newShape;
                this.show();
            }
            else if (this.field.check(newShape, this.x - r, this.y, 'h') == 0) {
                this.x -= r;
                this.shape = newShape;
                this.show();
            }
        };


        /**
         * 暂停开始
         * @param step
         */
        this.stop = function () {
            stop=!stop;
            if(stop){
                document.getElementById("stop").innerText=("stop");
            }else{
                document.getElementById("stop").innerText=("begin");
            }
        };
        this.restart = function() {
            over = false;
            level = 1;
            document.getElementById("source").innerText = "0";
            document.getElementById("level").innerText = "level: 1";
            clearInterval(timer);
            timer = window.setInterval("if(!over&&!stop)s.vMove();", 500);
            f.clearField();
            s.reset();
        };
        this.clearField = function() {
            for (var i = 0; i < this.width * this.height; i++) {
                if (this[i]) document.body.removeChild(this[i]);
                this[i] = null;
            }
        };
        //重置
        this.reset();
    }

    /**
     * 指定背景和初始化操作
     * @param w  宽(格字数)
     * @param h  高(格字数)
     * @constructor
     */
    function Field(w, h) {
        //默认宽15格
        this.width = w ? w : 15;
        //默认高25格
        this.height = h ? h : 25;
        //显示
        this.show = function () {
            //创建背景画布
            var f = create("div", "f");
            f.style.width = this.width * 20 + 'px';
            f.style.height = this.height * 20 + 'px';
            //创建下一个方块信息框
            var info = create("div", "info");
            info.style.width = 4 * 20 + 'px';
            info.style.height = 4 * 20 + 'px';
            info.style.top = 0 * 20 + 'px';
            info.style.left = (this.width + 1) * 20 + 'px';
            //创建分数框
            var scoreDiv = create("div", "info");
            scoreDiv.style.width = 4 * 20 + 'px';
            scoreDiv.style.height = 8 * 20 + 'px';
            scoreDiv.style.top = 5 * 20 + 'px';
            scoreDiv.style.left = (this.width + 1) * 20 + 'px';
            //得分
            var sourceInfo = document.createElement("p");
            sourceInfo.id = "sourceInfo";
            sourceInfo.innerText = "SOURCE:";
            scoreDiv.appendChild(sourceInfo);
            var source = document.createElement("p");
            source.id = "source";
            source.innerText = "0";
            scoreDiv.appendChild(source);
            //级别
            var level = document.createElement("p");
            level.id = "level";
            level.innerText = "level: 1";
            scoreDiv.appendChild(level);
            //状态
            var stop = document.createElement("p");
            stop.id = "stop";
            stop.innerText = "begin";
            scoreDiv.appendChild(stop);
        };
        //查找拼接完整的一行
        this.findFull = function () {
            //计算一次消除多少行
            var removeLineCount = 0;
            //计算消除行
            for (var l = 0; l < this.height; l++) {
                var s = 0;
                for (var i = 0; i < this.width; i++) {
                    s += this[l * this.width + i] ? 1 : 0;
                }
                if (s == this.width) {
                    removeLineCount++;
                    //消除行
                    this.removeLine(l);
                }
            }
            //计算得分
            var source = parseInt(document.getElementById("source").innerText);
            switch (removeLineCount) {
                case 0:
                    document.getElementById("source").innerText=(source+0);
                    break;
                case 1:
                    document.getElementById("source").innerText=(source+10);
                    break;
                case 2:
                    document.getElementById("source").innerText=(source+30);
                    break;
                case 3:
                    document.getElementById("source").innerText=(source+60);
                    break;
                case 4:
                    document.getElementById("source").innerText=(source+100);
                    break;
            }
            //计算级别
            if(source/100>=level && level < 3){
                level++;
                document.getElementById("level").innerText=("level: "+level);
                clearInterval(timer);
                timer=window.setInterval("if(!over&&!stop)s.vMove();", 600/level);
            }

        };
        /**
         * 消除行
         * @param line 行号
         */
        this.removeLine = function (line) {
            for (var i = 0; i < this.width; i++) {
                document.body.removeChild(this[line * this.width + i]);
            }
            for (var l = line; l > 0; l--) {
                for (var i = 0; i < this.width; i++) {
                    this[l * this.width - -i] = this[(l - 1) * this.width - -i];
                    if (this[l * this.width - -i]) this[l * this.width - -i].style.top = l * 20 + 'px';
                }
            }
        };
        /**
         * 旋转检查
         * @param shape 方块集合
         * @param x
         * @param y
         * @param d
         * @returns {*}
         */
        this.check = function (shape, x, y, d) {
            var r1 = 0, r2 = 'N';
            for (var i = 0; i < 8; i += 2) {
                if (shape[i] - -x < 0 && shape[i] - -x < r1) {
                    r1 = shape[i] - -x;
                }
                else if (shape[i] - -x >= this.width && shape[i] - -x > r1) {
                    r1 = shape[i] - -x;
                }
                if (shape[i + 1] - -y >= this.height || this[shape[i] - -x - -(shape[i + 1] - -y) * this.width]) {
                    r2 = 'D'
                }
            }
            if (d == 'h' && r2 == 'N') return r1 > 0 ? r1 - this.width - -1 : r1;
            else return r2;
        };
        /**
         * 冻结的下落方块
         * @param shape
         * @param x
         * @param y
         */
        this.fixShape = function (shape, x, y) {
            //冻结方块
            var d = new Tetris("d", shape, x, y);
            d.show();
            for (var i = 0; i < 8; i += 2) {
                this[shape[i] - -x - -(shape[i + 1] - -y) * this.width] = d.divs[i / 2];
            }
        };
    }

    var f = new Field();
    f.show();

    var s = new Tetris();
    s.field = f;
    s.show();

    //定时器，游戏未结束的情况下，每0.5s向下移动方块
    var timer = window.setInterval("if(!over&&!stop)s.vMove();", 500);
    //键盘监听
    // 键盘监听
    document.addEventListener('keydown', function (e) {
        if (over) return;
        switch (e.code) {
            case 'KeyW': // W 键 - 向上旋转
                s.rotate();
                break;
            case 'KeyA': // A 键 - 向左移动
                s.hMove(-1);
                break;
            case 'KeyS': // S 键 - 向下移动
                s.vMove();
                break;
            case 'KeyD': // D 键 - 向右移动
                s.hMove(1);
                break;
            case 'Escape': // ESC 键 - 暂停/开始
                s.stop();
                break;
        }
    });
</script>