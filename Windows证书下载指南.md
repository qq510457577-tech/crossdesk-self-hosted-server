# Windows PC下载CrossDesk根证书指南

## 证书信息
- **服务器IP**: 43.133.192.17
- **证书文件**: `api.crossdesk.cn_root.crt`
- **证书位置**: `/var/lib/crossdesk/certs/`
- **证书用途**: CrossDesk自托管服务器根证书

## 方法一：使用SCP命令（最简单）

### 前提条件
1. Windows 10/11 已安装OpenSSH客户端
2. 知道服务器root密码

### 下载命令
```powershell
# 以管理员身份打开PowerShell，执行：
scp root@43.133.192.17:/var/lib/crossdesk/certs/api.crossdesk.cn_root.crt C:\Users\您的用户名\Downloads\
```

### 安装命令
```powershell
# 安装证书到系统信任存储
certutil -addstore "Root" "C:\Users\您的用户名\Downloads\api.crossdesk.cn_root.crt"
```

## 方法二：使用WinSCP（图形界面）

### 步骤
1. **下载WinSCP**: https://winscp.net/eng/download.php
2. **安装并运行WinSCP**
3. **配置连接**:
   - 文件协议: SFTP
   - 主机名: `43.133.192.17`
   - 端口号: `22`
   - 用户名: `root`
   - 密码: [您的服务器密码]
4. **连接后导航到**: `/var/lib/crossdesk/certs/`
5. **下载文件**: 右键点击 `api.crossdesk.cn_root.crt` → 下载

## 方法三：使用提供的脚本

### 批处理脚本
1. 下载 `download_cert_windows.bat`
2. 双击运行
3. 按照提示选择下载方法

### PowerShell脚本
1. 下载 `Download-CrossDeskCert.ps1`
2. 右键点击 → "使用PowerShell运行"
3. 或者以管理员身份打开PowerShell，执行:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   .\Download-CrossDeskCert.ps1
   ```

## 方法四：手动复制内容

如果无法直接下载文件，可以手动复制证书内容：

1. **在服务器上查看证书内容**:
   ```bash
   cat /var/lib/crossdesk/certs/api.crossdesk.cn_root.crt
   ```

2. **在Windows上创建证书文件**:
   - 打开记事本
   - 粘贴证书内容
   - 保存为 `api.crossdesk.cn_root.crt` (注意扩展名)

## 证书安装方法

### 方法A：使用certutil命令
```powershell
# 以管理员身份运行PowerShell
certutil -addstore "Root" "C:\完整路径\api.crossdesk.cn_root.crt"
```

### 方法B：图形界面安装
1. 双击证书文件
2. 点击"安装证书"
3. 选择"本地计算机" → 下一步
4. 选择"将所有证书放入下列存储"
5. 点击"浏览" → 选择"受信任的根证书颁发机构"
6. 完成安装

### 方法C：使用证书管理器
1. 按 `Win + R`，输入 `certmgr.msc`
2. 右键"受信任的根证书颁发机构" → 所有任务 → 导入
3. 浏览选择证书文件
4. 完成导入

## 验证证书安装

### 检查证书是否安装成功
```powershell
# 查看已安装的证书
certutil -store "Root" | findstr "43.133.192.17"
```

### 测试服务器连接
```powershell
# 测试TLS连接
curl -k -v https://43.133.192.17:9099
```

## 客户端配置

### CrossDesk客户端设置
1. 打开CrossDesk客户端
2. 进入设置 → 自托管服务器配置
3. 配置以下信息:
   - 服务器地址: `43.133.192.17`
   - 服务器端口: `9099`
   - 中继服务端口: `3478`
4. 启用自托管服务器配置

## 故障排除

### 常见问题1：SCP连接失败
```
错误: Connection refused
```
**解决方案**:
- 检查服务器SSH服务是否运行: `systemctl status sshd`
- 检查防火墙是否开放22端口
- 确认用户名和密码正确

### 常见问题2：证书安装失败
```
错误: 证书不受信任
```
**解决方案**:
- 确保证书文件完整
- 以管理员身份运行安装命令
- 尝试图形界面安装方法

### 常见问题3：客户端无法连接
```
错误: 无法验证服务器证书
```
**解决方案**:
- 确保证书已正确安装到"受信任的根证书颁发机构"
- 重启CrossDesk客户端
- 检查服务器端口9099和3478是否开放

## 安全注意事项

1. **保护证书文件**: 根证书是信任基础，不要随意分享
2. **定期更新**: 证书有效期为10年，建议定期更新
3. **备份证书**: 备份证书文件以便重装系统时使用
4. **监控访问**: 定期检查服务器访问日志

## 技术支持

如果遇到问题，请检查:
1. 服务器状态: `docker ps` (容器应正常运行)
2. 端口状态: `netstat -tlnp | grep -E "9099|3478"`
3. 证书文件: `ls -la /var/lib/crossdesk/certs/`
4. 服务日志: `docker logs crossdesk_server --tail 20`

---
**最后更新**: 2026年4月14日
**服务器IP**: 43.133.192.17
**服务状态**: ✅ 正常运行