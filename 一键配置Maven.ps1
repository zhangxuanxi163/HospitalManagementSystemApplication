# Maven环境变量一键配置脚本
# 使用方法：以管理员身份运行PowerShell，然后执行此脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Maven环境变量配置脚本" -ForegroundColor Cyan
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

# 设置Maven路径（请根据实际安装路径修改）
$mavenPath = Read-Host "请输入Maven安装路径（例如：C:\maven 或 C:\Program Files\Apache\maven）"

if (-not (Test-Path $mavenPath)) {
    Write-Host "错误：路径不存在：$mavenPath" -ForegroundColor Red
    pause
    exit
}

$mavenBinPath = Join-Path $mavenPath "bin"
if (-not (Test-Path $mavenBinPath)) {
    Write-Host "错误：找不到bin目录：$mavenBinPath" -ForegroundColor Red
    pause
    exit
}

Write-Host ""
Write-Host "正在配置环境变量..." -ForegroundColor Yellow

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
    
    # 检查是否已存在
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

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "配置完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "请关闭所有PowerShell窗口，然后重新打开，执行以下命令验证：" -ForegroundColor Yellow
Write-Host "  mvn -version" -ForegroundColor White
Write-Host ""
pause







