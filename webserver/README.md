# 项目名称：template

## 项目简介

本项目为一个基于 Spring Boot 3 + MyBatis-Plus + MySQL 的后端管理系统模板，配套 Vue3 + Vite + Element Plus 的前端项目，适用于中小型管理系统、商城等场景。后端支持 JWT 鉴权、Swagger 接口文档、文件上传、AOP、常用工具集成，前端支持现代化组件和富文本编辑、数据可视化等。

---

## 目录结构

```
.
├── src/                # 后端主代码
│   └── main/
│       ├── java/com/project/platform/  # 业务代码（controller、service、mapper、entity等）
│       └── resources/                  # 配置文件、MyBatis映射文件
├── web/                # 前端项目（Vue3 + Vite）
├── sql/                # 数据库初始化脚本
├── pom.xml             # Maven 配置
└── ...
```

---

## 技术栈

- **后端**：Spring Boot 3.2、MyBatis-Plus、MySQL、JWT、Swagger、Hutool、Lombok
- **前端**：Vue 3、Vite、Element Plus、Pinia、Axios、ECharts、WangEditor、Markdown 编辑器等

---

## 快速开始

### 1. 数据库初始化

1. 安装 MySQL，创建数据库 `webserver`。
2. 执行 `sql/webserver.sql` 脚本，初始化表结构和部分数据。

### 2. 后端启动

1. 配置数据库连接（`src/main/resources/application.yaml`）：
    ```yaml
    spring:
      datasource:
        url: jdbc:mysql://localhost:3306/webserver?...
        username: root
        password: 1234
    ```
2. 使用 IDEA 或命令行运行：
    ```bash
    mvn spring-boot:run
    ```
3. 默认接口地址：`http://localhost:1000/api`

### 3. 前端启动

1. 进入 `web` 目录，安装依赖：
    ```bash
    npm install
    ```
2. 启动开发环境：
    ```bash
    npm run dev
    ```
3. 访问前端页面：`http://localhost:5173`

---

## 主要功能

- 用户、商家、商品、订单、广告、轮播图等管理
- JWT 登录鉴权
- 文件上传与下载
- Swagger3 在线接口文档（`/swagger-ui.html`）
- 数据库操作日志输出
- 前后端分离，接口规范清晰

---

## 相关配置

- **端口**：后端 `1000`，前端 `5173`
- **文件上传目录**：`uploads/`
- **接口前缀**：`/api`
- **Swagger文档**：`/swagger-ui.html`
- **数据库脚本**：`sql/webserver.sql`

---

## 依赖安装

- JDK 17+
- Node.js 16+
- MySQL 8+

---

## 其他说明

- 前端详细开发说明见 `web/README.md`
- 如需自定义配置，请修改 `application.yaml` 和前端 `.env` 文件

