# 配置JAVA_HOME和Maven环境变量
# 使用方法：以管理员身份运行PowerShell，然后执行此脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "配置JAVA_HOME和Maven环境变量" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "错误：请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "右键PowerShell -> 以管理员身份运行" -ForegroundColor Yellow
    pause
    exit
}

# 检测Java路径
$javaPath = "C:\Program Files\Eclipse Adoptium\jdk-17.0.17.10-hotspot"
if (-not (Test-Path $javaPath)) {
    Write-Host "警告：未找到Java路径：$javaPath" -ForegroundColor Yellow
    $javaPath = Read-Host "请输入Java安装路径（例如：C:\Program Files\Java\jdk-17）"
}

if (-not (Test-Path $javaPath)) {
    Write-Host "错误：Java路径不存在：$javaPath" -ForegroundColor Red
    pause
    exit
}

Write-Host "✓ 找到Java路径：$javaPath" -ForegroundColor Green
Write-Host ""

# 配置JAVA_HOME
Write-Host "正在配置JAVA_HOME..." -ForegroundColor Yellow
try {
    [Environment]::SetEnvironmentVariable("JAVA_HOME", $javaPath, "Machine")
    Write-Host "✓ JAVA_HOME 已设置：$javaPath" -ForegroundColor Green
} catch {
    Write-Host "✗ 设置JAVA_HOME失败：$_" -ForegroundColor Red
}

# 配置Maven（如果存在）
$mavenPath = "C:\Users\xx\Desktop\1\apache-maven-3.9.12-bin"
if (-not (Test-Path $mavenPath)) {
    Write-Host ""
    Write-Host "未找到Maven，跳过Maven配置" -ForegroundColor Yellow
    Write-Host "如果需要使用Maven，请先解压Maven到指定目录" -ForegroundColor Yellow
} else {
    Write-Host ""
    Write-Host "正在配置Maven..." -ForegroundColor Yellow
    
    # 设置MAVEN_HOME
    try {
        [Environment]::SetEnvironmentVariable("MAVEN_HOME", $mavenPath, "Machine")
        Write-Host "✓ MAVEN_HOME 已设置：$mavenPath" -ForegroundColor Green
    } catch {
        Write-Host "✗ 设置MAVEN_HOME失败：$_" -ForegroundColor Red
    }
    
    # 添加到Path
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
        $mavenBinPath = Join-Path $mavenPath "bin"
        
        if ($currentPath -notlike "*$mavenBinPath*") {
            $newPath = $currentPath + ";" + $mavenBinPath
            [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
            Write-Host "✓ Path 已更新，添加了：$mavenBinPath" -ForegroundColor Green
        } else {
            Write-Host "✓ Path 中已存在Maven路径" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "✗ 更新Path失败：$_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "重要提示：" -ForegroundColor Yellow
Write-Host "  1. 请关闭所有PowerShell窗口" -ForegroundColor White
Write-Host "  2. 重新打开PowerShell" -ForegroundColor White
Write-Host "  3. 执行以下命令验证：" -ForegroundColor White
Write-Host "     java -version" -ForegroundColor Cyan
Write-Host "     echo $env:JAVA_HOME" -ForegroundColor Cyan
if (Test-Path $mavenPath) {
    Write-Host "     mvn -version" -ForegroundColor Cyan
}
Write-Host ""
pause







