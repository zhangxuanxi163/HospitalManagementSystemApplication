# 清理Path变量并添加Maven路径
# 使用方法：以管理员身份运行PowerShell，然后执行此脚本

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Path环境变量清理和Maven配置工具" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查管理员权限
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "错误：请以管理员身份运行此脚本！" -ForegroundColor Red
    Write-Host "右键PowerShell -> 以管理员身份运行" -ForegroundColor Yellow
    pause
    exit
}

# 获取Maven路径
$mavenPath = Read-Host "请输入Maven安装路径（例如：C:\maven，直接回车使用C:\maven）"
if ([string]::IsNullOrWhiteSpace($mavenPath)) {
    $mavenPath = "C:\maven"
}

$mavenBinPath = Join-Path $mavenPath "bin"

if (-not (Test-Path $mavenBinPath)) {
    Write-Host "错误：找不到Maven bin目录：$mavenBinPath" -ForegroundColor Red
    Write-Host "请确认Maven已正确安装" -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""
Write-Host "正在处理Path环境变量..." -ForegroundColor Yellow

# 备份当前Path
$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$backupFile = "C:\path_backup_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
$currentPath | Out-File -FilePath $backupFile -Encoding UTF8
Write-Host "✓ Path已备份到：$backupFile" -ForegroundColor Green

# 显示当前状态
Write-Host ""
Write-Host "当前Path长度：$($currentPath.Length) 字符" -ForegroundColor Cyan
if ($currentPath.Length -gt 2047) {
    Write-Host "⚠ 超过2047字符限制！" -ForegroundColor Red
}

# 清理Path：分割、去重、过滤空值
Write-Host ""
Write-Host "正在清理重复路径..." -ForegroundColor Yellow
$pathArray = $currentPath -split ';' | 
    Where-Object { $_ -ne '' -and $_ -ne $mavenBinPath } | 
    Select-Object -Unique |
    Where-Object { Test-Path $_ -ErrorAction SilentlyContinue }

# 添加Maven路径（如果不存在）
if ($pathArray -notcontains $mavenBinPath) {
    $pathArray += $mavenBinPath
    Write-Host "✓ 已添加Maven路径：$mavenBinPath" -ForegroundColor Green
} else {
    Write-Host "✓ Maven路径已存在" -ForegroundColor Yellow
}

# 重新组合Path
$newPath = $pathArray -join ';'

# 检查长度
Write-Host ""
Write-Host "新Path长度：$($newPath.Length) 字符" -ForegroundColor Cyan

if ($newPath.Length -gt 2047) {
    Write-Host ""
    Write-Host "警告：Path仍然超过2047字符限制！" -ForegroundColor Red
    Write-Host "建议操作：" -ForegroundColor Yellow
    Write-Host "  1. 手动清理更多无效路径" -ForegroundColor White
    Write-Host "  2. 或使用用户级Path变量" -ForegroundColor White
    Write-Host "  3. 或使用IDE运行项目（不需要Maven命令行）" -ForegroundColor White
    Write-Host ""
    $continue = Read-Host "是否仍然尝试设置？（Y/N）"
    if ($continue -ne 'Y' -and $continue -ne 'y') {
        Write-Host "操作已取消" -ForegroundColor Yellow
        pause
        exit
    }
}

# 设置新Path
try {
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "✓ Path环境变量已更新！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "清理了 $($currentPath.Split(';').Count - $pathArray.Count) 个重复/无效路径" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "重要提示：" -ForegroundColor Yellow
    Write-Host "  1. 请关闭所有PowerShell窗口" -ForegroundColor White
    Write-Host "  2. 重新打开PowerShell" -ForegroundColor White
    Write-Host "  3. 执行命令验证：mvn -version" -ForegroundColor White
    Write-Host ""
} catch {
    Write-Host ""
    Write-Host "错误：设置Path失败" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "建议使用用户级Path变量或IDE运行项目" -ForegroundColor Yellow
}

pause







