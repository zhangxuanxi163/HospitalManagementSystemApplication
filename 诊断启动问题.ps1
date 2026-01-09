# 医院管理系统启动诊断脚本
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "医院信息管理系统 - 启动诊断" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$errors = @()
$warnings = @()

# 1. 检查Java环境
Write-Host "[1/5] 检查Java环境..." -ForegroundColor Yellow
try {
    $javaVersion = java -version 2>&1 | Select-Object -First 1
    Write-Host "  Java版本: $javaVersion" -ForegroundColor Green
    
    # 检查Java版本是否符合要求（17+）
    if ($javaVersion -match "version\s+""(\d+)") {
        $majorVersion = [int]$matches[1]
        if ($majorVersion -lt 17) {
            $errors += "Java版本过低，需要Java 17或更高版本，当前版本: $majorVersion"
        } elseif ($majorVersion -gt 17 -and $majorVersion -lt 22) {
            Write-Host "  ✓ Java版本符合要求" -ForegroundColor Green
        } else {
            $warnings += "检测到Java $majorVersion，项目配置为Java 17，可能存在兼容性问题"
        }
    }
} catch {
    $errors += "未找到Java，请先安装JDK 17+"
}

Write-Host ""

# 2. 检查MySQL服务
Write-Host "[2/5] 检查MySQL服务..." -ForegroundColor Yellow
try {
    $mysqlService = Get-Service -Name "MySQL80" -ErrorAction SilentlyContinue
    if ($mysqlService) {
        if ($mysqlService.Status -eq "Running") {
            Write-Host "  ✓ MySQL服务正在运行" -ForegroundColor Green
        } else {
            $errors += "MySQL服务未运行，状态: $($mysqlService.Status)"
            Write-Host "  尝试启动MySQL服务..." -ForegroundColor Yellow
            try {
                Start-Service -Name "MySQL80" -ErrorAction Stop
                Start-Sleep -Seconds 3
                Write-Host "  ✓ MySQL服务已启动" -ForegroundColor Green
            } catch {
                $errors += "无法启动MySQL服务，请手动启动"
            }
        }
    } else {
        # 尝试查找其他MySQL服务名称
        $mysqlServices = Get-Service | Where-Object { $_.Name -like "*MySQL*" }
        if ($mysqlServices) {
            Write-Host "  找到MySQL服务: $($mysqlServices.Name -join ', ')" -ForegroundColor Yellow
            $runningMysql = $mysqlServices | Where-Object { $_.Status -eq "Running" }
            if ($runningMysql) {
                Write-Host "  ✓ MySQL服务正在运行" -ForegroundColor Green
            } else {
                $errors += "MySQL服务未运行"
            }
        } else {
            $errors += "未找到MySQL服务，请确保MySQL已安装"
        }
    }
} catch {
    $warnings += "无法检查MySQL服务状态: $_"
}

Write-Host ""

# 3. 检查端口占用
Write-Host "[3/5] 检查端口8080占用情况..." -ForegroundColor Yellow
try {
    $port8080 = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
    if ($port8080) {
        $processId = $port8080.OwningProcess | Select-Object -First 1
        $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
        if ($process) {
            $errors += "端口8080已被占用，进程: $($process.ProcessName) (PID: $processId)"
            Write-Host "  端口8080被占用，进程: $($process.ProcessName)" -ForegroundColor Red
            Write-Host "  是否要结束该进程？(Y/N): " -NoNewline -ForegroundColor Yellow
            $response = Read-Host
            if ($response -eq "Y" -or $response -eq "y") {
                try {
                    Stop-Process -Id $processId -Force
                    Write-Host "  ✓ 进程已结束" -ForegroundColor Green
                } catch {
                    Write-Host "  ✗ 无法结束进程，请手动结束" -ForegroundColor Red
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

# 4. 检查项目编译状态
Write-Host "[4/5] 检查项目编译状态..." -ForegroundColor Yellow
if (Test-Path "target\classes") {
    Write-Host "  ✓ 项目已编译" -ForegroundColor Green
} else {
    $errors += "项目未编译，需要先编译项目"
    Write-Host "  ✗ 项目未编译" -ForegroundColor Red
    Write-Host "  请在IDE中执行：Build -> Rebuild Project" -ForegroundColor Yellow
    Write-Host "  或使用Maven命令：mvn clean compile" -ForegroundColor Yellow
}

Write-Host ""

# 5. 检查数据库连接配置
Write-Host "[5/5] 检查数据库配置..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\application.yml") {
    $config = Get-Content "src\main\resources\application.yml" -Raw
    if ($config -match "jdbc:mysql://([^:]+):(\d+)/([^\?]+)") {
        $dbHost = $matches[1]
        $dbPort = $matches[2]
        $dbName = $matches[3]
        Write-Host "  数据库主机: $dbHost" -ForegroundColor Cyan
        Write-Host "  数据库端口: $dbPort" -ForegroundColor Cyan
        Write-Host "  数据库名称: $dbName" -ForegroundColor Cyan
        
        # 尝试测试数据库连接
        Write-Host "  测试数据库连接..." -ForegroundColor Yellow
        try {
            $testConnection = Test-NetConnection -ComputerName $dbHost -Port $dbPort -WarningAction SilentlyContinue
            if ($testConnection.TcpTestSucceeded) {
                Write-Host "  ✓ 数据库端口可访问" -ForegroundColor Green
            } else {
                $errors += "无法连接到数据库服务器 $dbHost:$dbPort"
            }
        } catch {
            $warnings += "无法测试数据库连接: $_"
        }
    }
} else {
    $errors += "未找到配置文件 application.yml"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "诊断结果汇总" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✓ 所有检查通过，可以尝试启动项目" -ForegroundColor Green
    Write-Host ""
    Write-Host "启动方式：" -ForegroundColor Yellow
    Write-Host "1. 在IDE中运行 HospitalManagementSystemApplication" -ForegroundColor Cyan
    Write-Host "2. 或使用命令: mvn spring-boot:run" -ForegroundColor Cyan
    Write-Host "3. 启动后访问: http://localhost:8080/hospital" -ForegroundColor Cyan
} else {
    if ($errors.Count -gt 0) {
        Write-Host "发现以下错误（必须修复）：" -ForegroundColor Red
        foreach ($error in $errors) {
            Write-Host "  ✗ $error" -ForegroundColor Red
        }
    }
    
    if ($warnings.Count -gt 0) {
        Write-Host ""
        Write-Host "发现以下警告：" -ForegroundColor Yellow
        foreach ($warning in $warnings) {
            Write-Host "  ⚠ $warning" -ForegroundColor Yellow
        }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "按任意键退出..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

