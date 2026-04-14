@echo off
echo ============================================
echo CrossDesk根证书下载脚本 for Windows
echo ============================================
echo.
echo 服务器: 43.133.192.17
echo 证书文件: api.crossdesk.cn_root.crt
echo 证书位置: /var/lib/crossdesk/certs/
echo.
echo 请选择下载方法:
echo.
echo 1. 使用SCP (需要OpenSSH客户端)
echo 2. 使用PowerShell (需要PowerShell 5.1+)
echo 3. 手动下载说明
echo.
set /p choice="请选择 (1-3): "

if "%choice%"=="1" goto scp_method
if "%choice%"=="2" goto powershell_method
if "%choice%"=="3" goto manual_method
goto end

:scp_method
echo.
echo 使用SCP下载证书...
echo 请确保已安装OpenSSH客户端
echo.
scp root@43.133.192.17:/var/lib/crossdesk/certs/api.crossdesk.cn_root.crt %USERPROFILE%\Downloads\
if %errorlevel% equ 0 (
    echo 下载成功! 证书保存在: %USERPROFILE%\Downloads\api.crossdesk.cn_root.crt
) else (
    echo 下载失败，请检查:
    echo 1. SSH服务是否运行 (端口22)
    echo 2. 用户名和密码是否正确
    echo 3. 网络连接是否正常
)
goto end

:powershell_method
echo.
echo 使用PowerShell下载证书...
echo.
powershell -Command "$certContent = (ssh root@43.133.192.17 'cat /var/lib/crossdesk/certs/api.crossdesk.cn_root.crt'); if ($certContent) { $certContent | Out-File -FilePath \"$env:USERPROFILE\Downloads\api.crossdesk.cn_root.crt\" -Encoding ASCII; Write-Host '下载成功!' } else { Write-Host '下载失败' }"
goto end

:manual_method
echo.
echo ========== 手动下载说明 ==========
echo.
echo 步骤1: 下载并安装 WinSCP
echo        https://winscp.net/eng/download.php
echo.
echo 步骤2: 配置连接:
echo        主机名: 43.133.192.17
echo        端口: 22
echo        用户名: root
echo        密码: [您的服务器密码]
echo.
echo 步骤3: 导航到目录:
echo        /var/lib/crossdesk/certs/
echo.
echo 步骤4: 下载文件:
echo        api.crossdesk.cn_root.crt
echo.
echo 步骤5: 保存到本地，例如:
echo        C:\Users\%USERNAME%\Downloads\api.crossdesk.cn_root.crt
echo.
goto end

:end
echo.
echo ============================================
echo 证书安装步骤:
echo.
echo 1. 以管理员身份打开PowerShell
echo 2. 运行命令:
echo    certutil -addstore "Root" "C:\路径\到\api.crossdesk.cn_root.crt"
echo.
echo 或者双击证书文件，选择"安装证书"
echo 存储位置选择"受信任的根证书颁发机构"
echo ============================================
pause