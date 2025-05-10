# 项目名称：Brian's Shop

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

## 性能测试说明

### 1. 负载测试
负载测试用于评估系统在预期负载下的性能表现。

测试场景：
- 模拟100个并发用户
- 持续运行30分钟
- 测试主要API接口的响应时间
- 监控系统资源使用情况（CPU、内存、网络）

### 2. 压力测试
压力测试用于确定系统的极限承载能力。

测试场景：
- 逐步增加并发用户数（从100到1000）
- 每个负载级别持续5分钟
- 记录系统响应时间、错误率
- 观察系统崩溃点

### 3. 并发测试
并发测试用于验证系统在大量并发请求下的稳定性。

测试场景：
- 模拟500个并发用户同时操作
- 测试用户登录、数据查询等核心功能
- 验证数据一致性
- 检查死锁和资源竞争情况

### 如何运行性能测试

1. 安装JMeter
```bash
# Windows
下载并安装JMeter: https://jmeter.apache.org/download_jmeter.cgi

# 或使用Maven运行测试
mvn verify
```

2. 运行测试计划
```bash
# 使用JMeter GUI
jmeter -n -t performance-test.jmx -l results.jtl

# 或使用Maven
mvn jmeter:jmeter
```

3. 查看测试报告
```bash
# 生成HTML报告
jmeter -g results.jtl -o report
```

### 性能指标参考值

- 响应时间：95%的请求应在500ms内完成
- 错误率：应低于1%
- CPU使用率：平均不超过70%
- 内存使用率：平均不超过80%
- 吞吐量：根据具体业务场景设定基准值

### 注意事项

1. 测试前确保测试环境与生产环境配置相似
2. 测试数据应具有代表性
3. 测试过程中监控系统各项指标
4. 保存测试结果以便后续分析
5. 定期进行性能回归测试

