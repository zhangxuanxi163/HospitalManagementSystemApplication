# 医院管理系统快速修复脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "医院信息管理系统 - 快速修复" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 1. 尝试启动MySQL服务
Write-Host "[1/4] 检查并启动MySQL服务..." -ForegroundColor Yellow
$mysqlServices = Get-Service | Where-Object { $_.Name -like "*MySQL*" }
if ($mysqlServices) {
    foreach ($service in $mysqlServices) {
        if ($service.Status -ne "Running") {
            Write-Host "  尝试启动 $($service.Name)..." -ForegroundColor Yellow
            try {
                Start-Service -Name $service.Name
                Start-Sleep -Seconds 3
                Write-Host "  ✓ $($service.Name) 已启动" -ForegroundColor Green
            } catch {
                Write-Host "  ✗ 无法启动 $($service.Name)，请手动启动" -ForegroundColor Red
            }
        } else {
            Write-Host "  ✓ $($service.Name) 正在运行" -ForegroundColor Green
        }
    }
} else {
    Write-Host "  ⚠ 未找到MySQL服务" -ForegroundColor Yellow
}

Write-Host ""

# 2. 清理占用8080端口的进程
Write-Host "[2/4] 清理端口8080..." -ForegroundColor Yellow
try {
    $connections = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
    if ($connections) {
        $processIds = $connections | Select-Object -ExpandProperty OwningProcess -Unique
        foreach ($pid in $processIds) {
            $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
            if ($process -and $process.ProcessName -like "*java*") {
                Write-Host "  发现Java进程占用端口8080 (PID: $pid)" -ForegroundColor Yellow
                Write-Host "  是否结束该进程？(Y/N): " -NoNewline -ForegroundColor Yellow
                $response = Read-Host
                if ($response -eq "Y" -or $response -eq "y") {
                    try {
                        Stop-Process -Id $pid -Force
                        Write-Host "  ✓ 进程已结束" -ForegroundColor Green
                        Start-Sleep -Seconds 2
                    } catch {
                        Write-Host "  ✗ 无法结束进程" -ForegroundColor Red
                    }
                }
            }
        }
    } else {
        Write-Host "  ✓ 端口8080可用" -ForegroundColor Green
    }
} catch {
    Write-Host "  ✓ 端口8080可用" -ForegroundColor Green
}

Write-Host ""

# 3. 重新编译项目
Write-Host "[3/4] 检查并编译项目..." -ForegroundColor Yellow
if (Test-Path "pom.xml") {
    Write-Host "  检测到Maven项目" -ForegroundColor Cyan
    
    # 检查Maven是否可用
    try {
        $mvnVersion = mvn -version 2>&1 | Select-Object -First 1
        Write-Host "  Maven: $mvnVersion" -ForegroundColor Cyan
        
        Write-Host "  是否重新编译项目？(Y/N): " -NoNewline -ForegroundColor Yellow
        $response = Read-Host
        if ($response -eq "Y" -or $response -eq "y") {
            Write-Host "  正在编译项目..." -ForegroundColor Yellow
            mvn clean compile
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  ✓ 项目编译成功" -ForegroundColor Green
            } else {
                Write-Host "  ✗ 项目编译失败，请检查错误信息" -ForegroundColor Red
            }
        }
    } catch {
        Write-Host "  ⚠ Maven未安装或未配置到PATH" -ForegroundColor Yellow
        Write-Host "  请在IDE中手动编译项目" -ForegroundColor Yellow
    }
} else {
    Write-Host "  ⚠ 未找到pom.xml" -ForegroundColor Yellow
}

Write-Host ""

# 4. 检查数据库是否存在
Write-Host "[4/4] 检查数据库配置..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\application.yml") {
    $config = Get-Content "src\main\resources\application.yml" -Raw
    if ($config -match "jdbc:mysql://([^:]+):(\d+)/([^\?]+)") {
        $dbName = $matches[3]
        Write-Host "  配置的数据库: $dbName" -ForegroundColor Cyan
        
        if (Test-Path "创建数据库.sql") {
            Write-Host "  找到数据库创建脚本" -ForegroundColor Cyan
            Write-Host "  如果数据库不存在，请运行: 创建数据库.sql" -ForegroundColor Yellow
        }
        
        if (Test-Path "修复admin密码.sql") {
            Write-Host "  找到密码修复脚本" -ForegroundColor Cyan
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "修复完成" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "下一步：" -ForegroundColor Yellow
Write-Host "1. 确保MySQL服务正在运行" -ForegroundColor Cyan
Write-Host "2. 确保数据库 hospital_db 已创建" -ForegroundColor Cyan
Write-Host "3. 在IDE中运行 HospitalManagementSystemApplication" -ForegroundColor Cyan
Write-Host "4. 或使用命令: mvn spring-boot:run" -ForegroundColor Cyan
Write-Host ""
Write-Host "访问地址: http://localhost:8080/hospital" -ForegroundColor Green
Write-Host "默认账户: admin / admin123" -ForegroundColor Green
Write-Host ""
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

