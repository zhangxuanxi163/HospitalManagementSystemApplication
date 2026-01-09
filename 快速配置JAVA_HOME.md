# 快速配置JAVA_HOME

## 问题

Maven提示：`The JAVA_HOME environment variable is not defined correctly`

## 解决方案

### 方法一：使用自动配置脚本（推荐）

1. **以管理员身份打开PowerShell**
   - 右键PowerShell → 以管理员身份运行

2. **执行配置脚本**
   ```powershell
   cd C:\Users\xx\Desktop\1
   .\配置JAVA_HOME和Maven.ps1
   ```

3. **重新打开PowerShell验证**
   ```powershell
   java -version
   echo $env:JAVA_HOME
   mvn -version
   ```

---

### 方法二：手动配置

1. **打开环境变量设置**
   - 右键"此电脑" → 属性
   - 高级系统设置 → 环境变量

2. **添加JAVA_HOME**
   - 在"系统变量"中点击"新建"
   - 变量名：`JAVA_HOME`
   - 变量值：`C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot`
   - 点击"确定"

3. **验证**
   - 关闭所有PowerShell窗口
   - 重新打开PowerShell
   - 执行：`echo $env:JAVA_HOME`
   - 应该显示Java路径

---

## 重要提示

**实际上，你不需要Maven命令行！**

项目已经在IDE中成功运行了（只是之前数据库没创建）。使用IDE运行项目更方便，不需要配置Maven环境变量。

只有在以下情况才需要Maven命令行：
- 需要在命令行编译打包项目
- 需要使用Maven的其他命令

---

## 当前状态

- ✅ 项目已在IDE中运行
- ✅ 数据库已创建
- ⚠️ Maven命令行未配置（但不影响IDE使用）

---

## 建议

**如果只是开发项目**：继续使用IDE运行，不需要配置Maven命令行。

**如果需要Maven命令行**：使用上面的方法配置JAVA_HOME。







