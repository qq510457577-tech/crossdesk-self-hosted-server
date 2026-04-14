# CrossDesk根证书下载和安装脚本 for Windows PowerShell
# 使用方法: 以管理员身份运行此脚本

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "CrossDesk根证书下载和安装工具" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "服务器: 43.133.192.17" -ForegroundColor Yellow
Write-Host "证书文件: api.crossdesk.cn_root.crt" -ForegroundColor Yellow
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""

# 检查是否以管理员身份运行
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Host "警告: 请以管理员身份运行此脚本!" -ForegroundColor Red
    Write-Host "右键点击PowerShell，选择'以管理员身份运行'" -ForegroundColor Yellow
    pause
    exit
}

# 选择下载方法
Write-Host "请选择下载方法:" -ForegroundColor Green
Write-Host "1. 使用SCP下载 (需要OpenSSH客户端)" -ForegroundColor White
Write-Host "2. 使用SSH命令下载 (需要OpenSSH客户端)" -ForegroundColor White
Write-Host "3. 显示手动下载说明" -ForegroundColor White
Write-Host ""
$choice = Read-Host "请输入选择 (1-3)"

# 目标路径
$downloadPath = "$env:USERPROFILE\Downloads\api.crossdesk.cn_root.crt"
$serverPath = "/var/lib/crossdesk/certs/api.crossdesk.cn_root.crt"
$serverAddress = "43.133.192.17"

switch ($choice) {
    "1" {
        # 方法1: 使用SCP
        Write-Host "`n使用SCP下载证书..." -ForegroundColor Cyan
        try {
            scp "root@${serverAddress}:${serverPath}" $downloadPath
            if (Test-Path $downloadPath) {
                Write-Host "下载成功! 证书保存在: $downloadPath" -ForegroundColor Green
            } else {
                Write-Host "下载失败，文件未找到" -ForegroundColor Red
            }
        } catch {
            Write-Host "SCP下载失败: $_" -ForegroundColor Red
            Write-Host "请确保:" -ForegroundColor Yellow
            Write-Host "1. OpenSSH客户端已安装" -ForegroundColor Yellow
            Write-Host "2. 可以连接到服务器 (端口22)" -ForegroundColor Yellow
            Write-Host "3. 用户名和密码正确" -ForegroundColor Yellow
        }
    }
    
    "2" {
        # 方法2: 使用SSH命令
        Write-Host "`n使用SSH命令下载证书..." -ForegroundColor Cyan
        try {
            $certContent = ssh root@${serverAddress} "cat ${serverPath}"
            if ($certContent) {
                $certContent | Out-File -FilePath $downloadPath -Encoding ASCII
                Write-Host "下载成功! 证书保存在: $downloadPath" -ForegroundColor Green
            } else {
                Write-Host "下载失败，无法获取证书内容" -ForegroundColor Red
            }
        } catch {
            Write-Host "SSH下载失败: $_" -ForegroundColor Red
        }
    }
    
    "3" {
        # 方法3: 手动下载说明
        Write-Host "`n========== 手动下载说明 ==========" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "步骤1: 下载并安装 WinSCP" -ForegroundColor Yellow
        Write-Host "       https://winscp.net/eng/download.php" -ForegroundColor White
        Write-Host ""
        Write-Host "步骤2: 配置连接:" -ForegroundColor Yellow
        Write-Host "       主机名: 43.133.192.17" -ForegroundColor White
        Write-Host "       端口: 22" -ForegroundColor White
        Write-Host "       用户名: root" -ForegroundColor White
        Write-Host "       密码: [您的服务器密码]" -ForegroundColor White
        Write-Host ""
        Write-Host "步骤3: 导航到目录:" -ForegroundColor Yellow
        Write-Host "       /var/lib/crossdesk/certs/" -ForegroundColor White
        Write-Host ""
        Write-Host "步骤4: 下载文件:" -ForegroundColor Yellow
        Write-Host "       api.crossdesk.cn_root.crt" -ForegroundColor White
        Write-Host ""
        Write-Host "步骤5: 保存到本地，例如:" -ForegroundColor Yellow
        Write-Host "       C:\Users\$env:USERNAME\Downloads\api.crossdesk.cn_root.crt" -ForegroundColor White
        Write-Host ""
        return
    }
    
    default {
        Write-Host "无效的选择" -ForegroundColor Red
        return
    }
}

# 如果证书下载成功，询问是否安装
if (Test-Path $downloadPath) {
    Write-Host "`n是否要安装证书到系统信任存储?" -ForegroundColor Cyan
    $installChoice = Read-Host "输入 Y 安装，其他键跳过 (Y/N)"
    
    if ($installChoice -eq "Y" -or $installChoice -eq "y") {
        try {
            Write-Host "正在安装证书..." -ForegroundColor Cyan
            certutil -addstore "Root" $downloadPath
            Write-Host "证书安装成功!" -ForegroundColor Green
            Write-Host "现在可以正常连接 CrossDesk 服务器了" -ForegroundColor Green
        } catch {
            Write-Host "证书安装失败: $_" -ForegroundColor Red
            Write-Host "您可以手动安装:" -ForegroundColor Yellow
            Write-Host "1. 双击证书文件" -ForegroundColor White
            Write-Host "2. 点击'安装证书'" -ForegroundColor White
            Write-Host "3. 选择'本地计算机'" -ForegroundColor White
            Write-Host "4. 选择'将所有证书放入下列存储'" -ForegroundColor White
            Write-Host "5. 浏览并选择'受信任的根证书颁发机构'" -ForegroundColor White
        }
    }
}

Write-Host "`n============================================" -ForegroundColor Cyan
Write-Host "服务器连接信息:" -ForegroundColor Yellow
Write-Host "地址: 43.133.192.17" -ForegroundColor White
Write-Host "信令端口: 9099" -ForegroundColor White
Write-Host "中继端口: 3478" -ForegroundColor White
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "`n按任意键退出..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")