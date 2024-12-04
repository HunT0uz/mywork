<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="java.io.*" %>

<%
    String message = request.getParameter("message"); // 获取重定向消息
%>

<html>
<head>
    <title>添加/删除商品</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f7f7f7;
            color: #333;
            margin: 0;
            padding: 20px;
        }
        h1, h3 {
            color: #4CAF50;
        }
        form {
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin: 10px 0 5px;
        }
        input[type="text"], select, input[type="file"], textarea {
            width: calc(100% - 22px);
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        img {
            margin-top: 10px;
            display: none; /* 初始不显示，待选择文件后显示 */
        }
        @media (max-width: 600px) {
            form {
                padding: 10px;
            }
            input[type="text"], select, input[type="file"], textarea {
                width: 100%;
            }
        }
    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/css/select2.min.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.13/js/select2.min.js"></script>
</head>
<body>
<h1>添加/删除商品</h1>
<p><%= message != null ? message : "" %></p>

<h3>商品管理</h3>
<form action="addProduct" method="post" enctype="multipart/form-data">
    <input type="hidden" name="action" value="add">

    <label for="productName">商品名称:</label>
    <input type="text" id="productName" name="productName" required>

    <label for="productPrice">商品价格:</label>
    <input type="text" id="productPrice" name="productPrice" required>

    <label for="productDescription">商品描述:</label> <!-- 新增描述输入框 -->
    <textarea id="productDescription" name="productDescription" rows="4" required></textarea>

    <label for="productType">商品类型:</label>
    <select id="productType" name="productType" required>
        <option value="">选择商品类型</option>
        <optgroup label="电子产品">
            <option value="手机与通讯">手机与通讯</option>
            <option value="电脑与办公">电脑与办公</option>
            <option value="相机与摄影">相机与摄影</option>
            <option value="影音娱乐">影音娱乐</option>
            <option value="智能穿戴">智能穿戴</option>
            <option value="游戏与电竞">游戏与电竞</option>
        </optgroup>
        <optgroup label="服装鞋帽">
            <option value="男装">男装</option>
            <option value="女装">女装</option>
            <option value="童装">童装</option>
            <option value="内衣">内衣</option>
            <option value="鞋靴">鞋靴</option>
            <option value="箱包">箱包</option>
        </optgroup>
        <optgroup label="家居生活">
            <option value="家具">家具</option>
            <option value="家纺">家纺</option>
            <option value="家装建材">家装建材</option>
            <option value="厨房用具">厨房用具</option>
            <option value="清洁用品">清洁用品</option>
            <option value="宠物用品">宠物用品</option>
            <option value="美妆个护">美妆个护</option>
        </optgroup>
        <optgroup label="食品饮料">
            <option value="休闲零食">休闲零食</option>
            <option value="粮油调味">粮油调味</option>
            <option value="饮料冲调">饮料冲调</option>
            <option value="乳品烘焙">乳品烘焙</option>
            <option value="酒类">酒类</option>
            <option value="保健食品">保健食品</option>
            <option value="母婴用品">母婴用品</option>
        </optgroup>
        <optgroup label="图书音像">
            <option value="图书">图书</option>
            <option value="电子书">电子书</option>
            <option value="音像制品">音像制品</option>
            <option value="教育软件">教育软件</option>
        </optgroup>
        <optgroup label="运动户外">
            <option value="运动服饰">运动服饰</option>
            <option value="运动装备">运动装备</option>
            <option value="健身器材">健身器材</option>
            <option value="户外装备">户外装备</option>
            <option value="自行车与骑行">自行车与骑行</option>
            <option value="垂钓用品">垂钓用品</option>
            <option value="汽车用品">汽车用品</option>
        </optgroup>
        <optgroup label="汽车服务">
            <option value="汽车装饰">汽车装饰</option>
            <option value="车载电器">车载电器</option>
            <option value="维修保养">维修保养</option>
            <option value="汽车配件">汽车配件</option>
            <option value="汽车服务">汽车服务</option>
        </optgroup>
        <optgroup label="珠宝配饰">
            <option value="珠宝首饰">珠宝首饰</option>
            <option value="手表">手表</option>
            <option value="眼镜">眼镜</option>
            <option value="帽子围巾">帽子围巾</option>
            <option value="腰带">腰带</option>
        </optgroup>
        <optgroup label="玩具乐器">
            <option value="儿童玩具">儿童玩具</option>
            <option value="模型玩具">模型玩具</option>
            <option value="乐器">乐器</option>
        </optgroup>
        <optgroup label="医疗保健">
            <option value="医疗器械">医疗器械</option>
            <option value="中西药品">中西药品</option>
            <option value="保健滋补品">保健滋补品</option>
        </optgroup>
        <optgroup label="旅行度假">
            <option value="旅行装备">旅行装备</option>
            <option value="酒店预订">酒店预订</option>
            <option value="景点门票">景点门票</option>
            <option value="旅游服务">旅游服务</option>
        </optgroup>
        <optgroup label="其他">
            <option value="其他">其他</option>
        </optgroup>
    </select>

    <label for="productImage">上传商品图片:</label>
    <input type="file" id="productImage" name="productImage" accept="image/*" onchange="showFileName(this)" required>
    <img id="showimg" src="" alt="上传的图片" style="width:100px; height:100px;"><br>

    <button type="submit">添加商品</button>
</form>

<script>
    $(document).ready(function() {
        $('#productType').select2({
            placeholder: "请选择商品类型",
            allowClear: true
        });
    });

    function showFileName(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function(e) {
                var img = document.getElementById('showimg');
                img.src = e.target.result;
                img.style.display = 'block'; // 显示预览
            };
            reader.readAsDataURL(input.files[0]); // 读取文件并生成预览
        } else {
            document.getElementById('showimg').style.display = 'none'; // 隐藏图片
        }
    }
</script>

<h3>
    <a href="merchantDashboard.jsp" type="submit" style="color: black; text-decoration: none;">查看商品</a>
</h3>
</body>
</html>
