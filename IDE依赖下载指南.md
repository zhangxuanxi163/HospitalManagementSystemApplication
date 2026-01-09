# IDE依赖下载指南

## 问题说明

如果IDE没有自动下载Maven依赖，需要手动触发下载。

## IntelliJ IDEA

### 方法一：自动导入（推荐）

1. **打开项目后，IDEA会在右下角显示提示**
   - 点击 "Enable Auto-Import"
   - 或点击 "Import Maven Project"

2. **如果没有提示，手动触发**：
   - 右键点击 `pom.xml` 文件
   - 选择 "Maven" → "Reload Project"
   - 或选择 "Add as Maven Project"

### 方法二：使用Maven工具窗口

1. **打开Maven工具窗口**：
   - 点击右侧边栏的 "Maven" 图标
   - 或 View → Tool Windows → Maven

2. **刷新项目**：
   - 在Maven工具窗口中，点击刷新图标（🔄）
   - 或右键项目 → "Reload Project"

3. **下载依赖**：
   - 展开项目 → "Dependencies"
   - 右键 → "Download Sources" 或 "Download Documentation"

### 方法三：手动执行Maven命令

1. **打开Terminal**（在IDEA底部）
2. **执行命令**：
   ```bash
   mvn clean install
   ```
   或
   ```bash
   mvn dependency:resolve
   ```

### 方法四：检查Maven配置

1. **File → Settings → Build, Execution, Deployment → Build Tools → Maven**

2. **检查以下设置**：
   - **Maven home directory**：应该指向Maven安装目录，或使用IDEA内置Maven
   - **User settings file**：使用默认或自定义settings.xml
   - **Local repository**：通常是 `C:\Users\你的用户名\.m2\repository`

3. **如果Maven未安装**：
   - 选择 "Bundled (Maven 3)" 使用IDEA内置Maven
   - 点击 "Apply" → "OK"

### 方法五：清理并重新导入

1. **File → Invalidate Caches / Restart**
2. **选择 "Invalidate and Restart"**
3. **重启后，IDEA会自动重新导入项目**

---

## Eclipse

### 方法一：更新项目

1. **右键项目** → "Maven" → "Update Project"
2. **勾选 "Force Update of Snapshots/Releases"**
3. **点击 "OK"**

### 方法二：重新导入

1. **File → Import**
2. **Maven → Existing Maven Projects**
3. **选择项目文件夹**
4. **点击 "Finish"**

### 方法三：检查Maven配置

1. **Window → Preferences → Maven**
2. **检查 "User Settings" 路径**
3. **检查 "Local Repository" 路径**

---

## VS Code

### 方法一：安装Java扩展

1. **安装扩展**：
   - "Extension Pack for Java"（Microsoft）
   - "Maven for Java"（Microsoft）

2. **打开项目后，扩展会自动下载依赖**

### 方法二：手动执行命令

1. **打开终端**（Ctrl + `）
2. **执行**：
   ```bash
   mvn clean install
   ```

---

## 通用解决方案

### 如果所有方法都不行，尝试：

1. **检查网络连接**
   - Maven需要从中央仓库下载依赖
   - 确保网络畅通

2. **配置Maven镜像源（国内用户推荐）**

   创建或编辑 `C:\Users\你的用户名\.m2\settings.xml`：
   ```xml
   <?xml version="1.0" encoding="UTF-8"?>
   <settings>
       <mirrors>
           <mirror>
               <id>aliyun</id>
               <mirrorOf>central</mirrorOf>
               <name>Aliyun Maven</name>
               <url>https://maven.aliyun.com/repository/public</url>
           </mirror>
       </mirrors>
   </settings>
   ```

3. **清理Maven本地仓库**
   ```bash
   # 删除本地仓库（会重新下载）
   rmdir /s C:\Users\你的用户名\.m2\repository
   ```

4. **检查防火墙/代理设置**
   - 确保Maven可以访问外网
   - 如有代理，需要在Maven配置中设置

---

## 验证依赖是否下载成功

### 在IDEA中：

1. **打开项目结构**：
   - File → Project Structure → Libraries
   - 应该能看到Spring Boot相关的库

2. **检查External Libraries**：
   - 在项目树中展开 "External Libraries"
   - 应该能看到很多依赖包

3. **尝试编译**：
   - Build → Rebuild Project
   - 如果没有错误，说明依赖已下载

---

## 常见错误

### 错误1：无法连接到Maven仓库

**解决**：配置国内镜像源（见上方）

### 错误2：依赖下载超时

**解决**：
- 增加超时时间
- 使用国内镜像源
- 检查网络连接

### 错误3：Java版本不匹配

**解决**：已修复pom.xml中的Java版本为17

---

## 快速检查清单

- [ ] Java版本已设置为17（已修复）
- [ ] pom.xml文件正确（已修复）
- [ ] IDE已识别Maven项目
- [ ] Maven工具窗口可以打开
- [ ] 网络连接正常
- [ ] 已配置Maven镜像源（可选，但推荐）

---

## 下一步

修复完成后：
1. 重新打开项目
2. 等待依赖下载完成
3. 运行 `HospitalManagementSystemApplication.java`







