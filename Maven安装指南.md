# Maven安装配置指南

## 方案一：安装Maven（推荐用于命令行开发）

### 步骤1：下载Maven

1. 访问Maven官网：https://maven.apache.org/download.cgi
2. 下载 `apache-maven-3.9.x-bin.zip`（Windows版本）
3. 解压到任意目录，例如：`C:\Program Files\Apache\maven`

### 步骤2：配置环境变量

1. **右键"此电脑" -> 属性 -> 高级系统设置 -> 环境变量**

2. **添加MAVEN_HOME变量**：
   - 变量名：`MAVEN_HOME`
   - 变量值：`C:\Program Files\Apache\maven`（你的Maven解压路径）

3. **编辑Path变量**：
   - 在Path变量中添加：`%MAVEN_HOME%\bin`

4. **验证安装**：
   打开新的PowerShell窗口，执行：
   ```powershell
   mvn -version
   ```
   如果显示Maven版本信息，说明安装成功。

### 步骤3：运行项目

安装完成后，在项目目录执行：
```powershell
mvn clean install
mvn spring-boot:run
```

---

## 方案二：使用IDE运行（最简单，推荐）

如果你使用IntelliJ IDEA或Eclipse，可以直接在IDE中运行，无需安装Maven命令行工具。

### IntelliJ IDEA

1. **打开项目**：
   - File -> Open -> 选择项目文件夹

2. **等待依赖下载**：
   - IDEA会自动识别Maven项目并下载依赖

3. **运行项目**：
   - 找到 `HospitalManagementSystemApplication.java`
   - 右键 -> Run 'HospitalManagementSystemApplication'
   - 或点击类名旁边的绿色运行按钮

### Eclipse

1. **导入项目**：
   - File -> Import -> Maven -> Existing Maven Projects
   - 选择项目文件夹

2. **运行项目**：
   - 右键项目 -> Run As -> Spring Boot App

---

## 方案三：使用Maven Wrapper（无需安装Maven）

我可以为项目添加Maven Wrapper，这样就不需要安装Maven了。

---

## 快速检查清单

- [ ] Java已安装（✓ 已确认，版本17）
- [ ] Maven已安装（需要安装）
- [ ] MySQL已安装并运行
- [ ] 数据库已创建

## 当前状态

✅ Java 17 已安装
❌ Maven 未安装

## 建议

**如果你使用IDE开发**：直接使用方案二，最简单快捷。
**如果你需要命令行操作**：按照方案一安装Maven。







