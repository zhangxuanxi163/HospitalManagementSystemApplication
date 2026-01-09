@echo off
chcp 65001 >nul
echo ========================================
echo 医院信息管理系统 - 启动脚本
echo ========================================
echo.

echo [1/4] 检查Java环境...
java -version
if %errorlevel% neq 0 (
    echo 错误：未找到Java，请先安装JDK 17+
    pause
    exit /b 1
)
echo Java环境正常
echo.

echo [2/4] 检查MySQL服务...
sc query MySQL80 | findstr "RUNNING" >nul
if %errorlevel% neq 0 (
    echo 警告：MySQL服务可能未运行
    echo 请确保MySQL服务已启动
    echo.
) else (
    echo MySQL服务正在运行
    echo.
)

echo [3/4] 检查项目编译状态...
if not exist "target\classes" (
    echo 项目未编译，需要先编译项目
    echo 请在IDE中执行：Build -^> Rebuild Project
    echo 或使用Maven命令：mvn clean compile
    echo.
    pause
    exit /b 1
)
echo 项目已编译
echo.

echo [4/4] 启动项目...
echo.
echo 注意：由于Maven未安装，请使用以下方式启动：
echo.
echo 方式1：在IntelliJ IDEA中
echo   1. 找到 HospitalManagementSystemApplication.java
echo   2. 右键 -^> Run
echo.
echo 方式2：如果已打包成jar文件
echo   java -jar target\hospital-management-system-1.0.0.jar
echo.
echo ========================================
echo 启动后访问：http://localhost:8080/hospital
echo 默认账户：admin / admin123
echo ========================================
echo.
pause







