# CrossDesk 自托管服务器部署

基于CrossDesk官方文档，在Docker环境中部署自托管的CrossDesk远程桌面服务器。

## 📋 功能特性

- ✅ 完整的CrossDesk自托管服务器部署
- ✅ SSL/TLS加密通信
- ✅ Docker容器化部署
- ✅ 详细的配置指南
- ✅ 客户端配置说明

## 🚀 快速开始

### 1. 环境要求
- Docker 和 Docker Compose
- OpenSSL (用于证书生成)
- 公网IP地址

### 2. 部署步骤

#### 克隆仓库
```bash
git clone https://github.com/qq510457577-tech/crossdesk-self-hosted-server.git
cd crossdesk-self-hosted-server
```

#### 生成SSL证书
```bash
# 替换YOUR_SERVER_IP为您的公网IP
./generate_certs.sh YOUR_SERVER_IP

# 将生成的证书文件移动到certs目录
mv crossdesk.cn.key crossdesk.cn_bundle.crt certs/
```

#### 配置Docker Compose
编辑 `docker-compose.yml`，更新以下环境变量：
```yaml
environment:
  - EXTERNAL_IP=YOUR_SERVER_IP      # 您的公网IP
  - INTERNAL_IP=172.17.0.1          # Docker内部IP
  - CROSSDESK_SERVER_PORT=8443      # 信令服务器端口
  - COTURN_PORT=3478                # COTURN服务端口
  - MIN_PORT=50000                  # 最小UDP端口
  - MAX_PORT=60000                  # 最大UDP端口
```

#### 启动服务
```bash
docker compose up -d
```

### 3. 验证部署
```bash
# 检查容器状态
docker ps | grep crossdesk

# 查看服务日志
docker logs crossdesk_server --tail 10

# 检查端口监听
netstat -tlnp | grep -E "8443|3478"
```

## 🔧 文件说明

### 核心文件
- `docker-compose.yml` - Docker容器配置
- `generate_certs.sh` - SSL证书生成脚本
- `README.md` - 本说明文档

### 文档文件
- `客户端配置指南.md` - 详细的客户端配置说明
- `部署总结.md` - 完整的部署记录

### 目录结构
```
crossdesk-self-hosted-server/
├── certs/                    # 证书目录（需手动生成）
├── db/                      # 数据库目录（自动创建）
├── logs/                    # 日志目录（自动创建）
├── docker-compose.yml       # Docker配置
├── generate_certs.sh        # 证书生成脚本
├── README.md               # 主说明文档
├── 客户端配置指南.md       # 客户端配置说明
└── 部署总结.md             # 部署记录
```

## 📱 客户端配置

### 1. 下载根证书
从服务器获取根证书文件：`crossdesk.cn_root.crt`

### 2. CrossDesk客户端配置
1. 安装CrossDesk客户端
2. 进入设置 → 自托管服务器配置
3. 加载根证书文件
4. 配置服务器信息：
   - 服务器地址：您的公网IP
   - 服务器端口：8443
   - 中继服务端口：3478
5. 启用自托管服务器配置

## 🔒 安全配置

### 防火墙端口
需要开放以下端口：

| 端口 | 协议 | 用途 |
|------|------|------|
| 8443 | TCP | CrossDesk信令服务器 |
| 3478 | TCP | COTURN服务 |
| 3478 | UDP | COTURN服务 |
| 50000-60000 | UDP | COTURN端口范围 |

### 证书安全
- 证书有效期为10年
- 建议定期更新证书
- 妥善保管服务器私钥

## 🛠️ 管理命令

### 服务管理
```bash
# 启动服务
docker compose up -d

# 停止服务
docker compose down

# 重启服务
docker compose restart

# 查看日志
docker logs crossdesk_server -f
```

### 证书管理
```bash
# 重新生成证书
./generate_certs.sh YOUR_SERVER_IP
mv crossdesk.cn.key crossdesk.cn_bundle.crt certs/

# 重启服务使新证书生效
docker compose restart
```

## 📊 服务器要求

### 硬件要求
- CPU: 1核心以上
- 内存: 512MB以上
- 存储: 1GB以上

### 网络要求
- 公网IP地址
- 稳定的网络连接
- 必要的端口开放

## ❓ 常见问题

### 1. 客户端无法连接
- 检查防火墙设置
- 验证证书配置
- 确认服务器地址和端口正确

### 2. 服务启动失败
- 检查端口是否被占用
- 验证证书文件是否存在
- 查看Docker日志

### 3. 连接质量差
- 检查UDP端口范围
- 验证网络带宽
- 调整客户端视频设置

## 📝 版本历史

### v1.0.0 (2026-04-14)
- 初始版本发布
- 完整的Docker部署配置
- SSL证书生成脚本
- 详细的配置文档

## 🔗 相关链接

- [CrossDesk官方GitHub](https://github.com/kunkundi/crossdesk)
- [CrossDesk官方网站](https://www.crossdesk.cn/)
- [Docker镜像](https://hub.docker.com/r/crossdesk/crossdesk-server)

## 📄 许可证

本项目基于CrossDesk的LGPL-3.0许可证。

## 🤝 贡献

欢迎提交Issue和Pull Request来改进本项目。

## 📧 联系

如有问题，请通过GitHub Issues反馈。

---
**部署完成时间**: 2026-04-14  
**最后更新**: 2026-04-14  
**仓库地址**: https://github.com/qq510457577-tech/crossdesk-self-hosted-server