# 医院信息管理系统

基于Spring Boot开发的医院信息管理系统，提供物资管理、库存管理、用户管理等核心功能。

## 项目简介

本系统是一个完整的医院信息管理系统，主要用于管理医院的各类物资、库存信息，以及系统用户。系统采用Spring Boot + MySQL架构，前后端分离设计，界面简洁美观，操作便捷。

## 技术栈

- **后端**：Spring Boot 2.7.14、Spring Data JPA、MySQL
- **前端**：HTML5、CSS3、JavaScript、Thymeleaf
- **构建工具**：Maven
- **开发工具**：IntelliJ IDEA

## 功能模块

### 1. 用户管理
- 用户登录/登出
- 用户信息管理（增删改查）
- 角色权限管理

### 2. 物资管理
- 物资信息管理（增删改查）
- 物资搜索功能
- 物资分类管理

### 3. 库存管理
- 实时库存查询
- 入库管理
- 出库管理
- 库存预警

### 4. 供应商管理
- 供应商信息管理
- 供应商查询

## 快速开始

### 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+

### 安装步骤

1. **克隆项目**
```bash
git clone [项目地址]
cd hospital-management-system
```

2. **创建数据库**
```bash
mysql -u root -p < src/main/resources/db/schema.sql
```

3. **修改配置**
编辑 `src/main/resources/application.yml`，修改数据库连接信息：
```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/hospital_db?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: root
    password: your_password
```

4. **编译运行**
```bash
mvn clean package
java -jar target/hospital-management-system-1.0.0.jar
```

5. **访问系统**
- 访问地址：http://localhost:8080/hospital
- 默认管理员账户：
  - 用户名：admin
  - 密码：admin123

## 项目结构

```
hospital-management-system/
├── src/
│   ├── main/
│   │   ├── java/com/hospital/
│   │   │   ├── entity/          # 实体类
│   │   │   ├── repository/      # 数据访问层
│   │   │   ├── service/         # 业务逻辑层
│   │   │   ├── controller/      # 控制器层
│   │   │   └── HospitalManagementSystemApplication.java
│   │   └── resources/
│   │       ├── templates/       # 前端模板
│   │       ├── db/             # 数据库脚本
│   │       └── application.yml  # 配置文件
│   └── test/                   # 测试代码
├── pom.xml                     # Maven配置
└── README.md                   # 项目说明
```

## 数据库设计

主要数据表：
- `users` - 用户表
- `materials` - 物资表
- `inventory` - 库存表
- `stock_in` - 入库记录表
- `stock_out` - 出库记录表
- `suppliers` - 供应商表
- `material_categories` - 物资分类表

详细数据库设计请参考 `src/main/resources/db/schema.sql`

## 开发说明

### 添加新功能

1. 在 `entity` 包中创建实体类
2. 在 `repository` 包中创建Repository接口
3. 在 `service` 包中创建Service类
4. 在 `controller` 包中创建Controller类
5. 在 `templates` 目录中创建前端页面

### 代码规范

- 使用Lombok简化代码
- 遵循Java命名规范
- 添加必要的注释
- 保持代码整洁

## 系统截图

### 登录页面
简洁美观的登录界面，使用渐变背景设计。

### 系统首页
卡片式布局，展示系统主要功能模块。

### 物资管理
提供完整的物资信息管理功能，支持搜索、添加、编辑、删除。

## 注意事项

1. 首次运行前需要执行数据库初始化脚本
2. 默认管理员密码为 `admin123`，建议首次登录后修改
3. 生产环境部署时请修改数据库密码和安全配置

## 后续改进计划

- [ ] 完善统计报表功能
- [ ] 添加数据可视化图表
- [ ] 实现批量导入导出功能
- [ ] 添加分页查询功能
- [ ] 集成Spring Security增强安全性
- [ ] 添加单元测试和集成测试
- [ ] 使用Redis缓存优化性能

## 许可证

本项目仅用于学习和教育目的。

## 联系方式

如有问题或建议，请联系项目开发者。

---

**开发时间**：2024年

**版本**：v1.0.0

