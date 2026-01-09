# 解决Lombok编译错误

## 错误信息

```
java.lang.NoSuchFieldError: Class com.sun.tools.javac.tree.JCTree$JCImport does not have member field 'com.sun.tools.javac.tree.JCTree qualid'
```

## 问题原因

这个错误是因为**Lombok版本与Java 17不兼容**导致的。Spring Boot 2.7.14默认使用的Lombok版本可能太旧，不支持Java 17。

## 解决方案

### ✅ 方案一：更新Lombok版本（已修复）

我已经在`pom.xml`中明确指定了Lombok版本为`1.18.30`，这个版本完全支持Java 17。

**操作步骤**：
1. 重新加载Maven项目（右键pom.xml → Maven → Reload Project）
2. 等待依赖下载完成
3. 重新编译项目

### 方案二：在IDE中配置注解处理器

如果更新版本后仍有问题，需要在IDE中启用注解处理器：

#### IntelliJ IDEA：
1. **File → Settings → Build, Execution, Deployment → Compiler → Annotation Processors**
2. **勾选 "Enable annotation processing"**
3. **点击 "Apply" → "OK"**
4. **重启IDEA**

#### Eclipse：
1. **项目右键 → Properties → Java Compiler → Annotation Processing**
2. **勾选 "Enable project specific settings"**
3. **勾选 "Enable annotation processing"**
4. **Apply → OK**

### 方案三：安装Lombok插件

确保IDE已安装Lombok插件：

#### IntelliJ IDEA：
- **File → Settings → Plugins**
- 搜索 "Lombok"
- 如果未安装，点击 "Install"
- 重启IDEA

#### Eclipse：
- **Help → Eclipse Marketplace**
- 搜索 "Lombok"
- 安装后重启Eclipse

### 方案四：清理并重新构建

如果以上方法都不行，尝试清理项目：

1. **清理Maven缓存**：
   ```bash
   # 删除本地仓库中的Lombok
   rmdir /s C:\Users\你的用户名\.m2\repository\org\projectlombok
   ```

2. **在IDE中**：
   - **Build → Clean Project**
   - **Build → Rebuild Project**

3. **重新下载依赖**：
   - 右键pom.xml → Maven → Reload Project

## 验证修复

修复后，应该能够：
- ✅ 项目正常编译，没有错误
- ✅ Lombok注解（@Data, @Entity等）正常工作
- ✅ 可以正常运行项目

## Lombok版本与Java版本对应关系

| Lombok版本 | 支持的Java版本 |
|-----------|---------------|
| 1.18.16+ | Java 8-17 |
| 1.18.20+ | Java 8-18 |
| 1.18.24+ | Java 8-19 |
| 1.18.28+ | Java 8-21 |
| 1.18.30+ | Java 8-21（推荐） |

## 当前配置

- **Java版本**：17
- **Lombok版本**：1.18.30（已更新）
- **Spring Boot版本**：2.7.14

## 如果还有问题

1. **检查IDE的Java版本设置**：
   - File → Project Structure → Project
   - 确保 "SDK" 和 "Language level" 都设置为17

2. **检查编译器的Java版本**：
   - File → Settings → Build, Execution, Deployment → Compiler → Java Compiler
   - 确保 "Project bytecode version" 为17

3. **完全重启IDE**：
   - 关闭所有窗口
   - 完全退出IDE
   - 重新打开项目

---

**修复完成后，请重新编译项目测试！**







