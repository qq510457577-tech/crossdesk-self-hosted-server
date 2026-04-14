# CrossDesk Self-Hosted Server Deployment

Self-hosted CrossDesk remote desktop server deployment in Docker environment based on official documentation.

## 📋 Features

- ✅ Complete CrossDesk self-hosted server deployment
- ✅ SSL/TLS encrypted communication
- ✅ Docker containerized deployment
- ✅ Detailed configuration guide
- ✅ Client configuration instructions

## 🚀 Quick Start

### 1. Requirements
- Docker and Docker Compose
- OpenSSL (for certificate generation)
- Public IP address

### 2. Deployment Steps

#### Clone Repository
```bash
git clone https://github.com/qq510457577-tech/crossdesk-self-hosted-server.git
cd crossdesk-self-hosted-server
```

#### Generate SSL Certificates
```bash
# Replace YOUR_SERVER_IP with your public IP
./generate_certs.sh YOUR_SERVER_IP

# Move generated certificate files to certs directory
mv crossdesk.cn.key crossdesk.cn_bundle.crt certs/
```

#### Configure Docker Compose
Edit `docker-compose.yml`, update the following environment variables:
```yaml
environment:
  - EXTERNAL_IP=YOUR_SERVER_IP      # Your public IP
  - INTERNAL_IP=172.17.0.1          # Docker internal IP
  - CROSSDESK_SERVER_PORT=8443      # Signaling server port
  - COTURN_PORT=3478                # COTURN service port
  - MIN_PORT=50000                  # Minimum UDP port
  - MAX_PORT=60000                  # Maximum UDP port
```

#### Start Service
```bash
docker compose up -d
```

### 3. Verify Deployment
```bash
# Check container status
docker ps | grep crossdesk

# View service logs
docker logs crossdesk_server --tail 10

# Check port listening
netstat -tlnp | grep -E "8443|3478"
```

## 🔧 File Description

### Core Files
- `docker-compose.yml` - Docker container configuration
- `generate_certs.sh` - SSL certificate generation script
- `README.md` - Main documentation (Chinese)
- `README_EN.md` - English documentation

### Documentation Files
- `客户端配置指南.md` - Detailed client configuration guide (Chinese)
- `部署总结.md` - Complete deployment summary (Chinese)

### Directory Structure
```
crossdesk-self-hosted-server/
├── certs/                    # Certificate directory (manually generated)
├── db/                      # Database directory (auto-created)
├── logs/                    # Log directory (auto-created)
├── docker-compose.yml       # Docker configuration
├── generate_certs.sh        # Certificate generation script
├── README.md               # Main documentation (Chinese)
├── README_EN.md            # English documentation
├── 客户端配置指南.md       # Client configuration guide (Chinese)
└── 部署总结.md             # Deployment summary (Chinese)
```

## 📱 Client Configuration

### 1. Download Root Certificate
Get the root certificate file from server: `crossdesk.cn_root.crt`

### 2. CrossDesk Client Configuration
1. Install CrossDesk client
2. Go to Settings → Self-hosted Server Configuration
3. Load root certificate file
4. Configure server information:
   - Server Address: Your public IP
   - Server Port: 8443
   - Relay Service Port: 3478
5. Enable self-hosted server configuration

## 🔒 Security Configuration

### Firewall Ports
Need to open the following ports:

| Port | Protocol | Purpose |
|------|----------|---------|
| 8443 | TCP | CrossDesk signaling server |
| 3478 | TCP | COTURN service |
| 3478 | UDP | COTURN service |
| 50000-60000 | UDP | COTURN port range |

### Certificate Security
- Certificate validity: 10 years
- Recommended to update certificates regularly
- Keep server private key secure

## 🛠️ Management Commands

### Service Management
```bash
# Start service
docker compose up -d

# Stop service
docker compose down

# Restart service
docker compose restart

# View logs
docker logs crossdesk_server -f
```

### Certificate Management
```bash
# Regenerate certificates
./generate_certs.sh YOUR_SERVER_IP
mv crossdesk.cn.key crossdesk.cn_bundle.crt certs/

# Restart service for new certificates to take effect
docker compose restart
```

## 📊 Server Requirements

### Hardware Requirements
- CPU: 1+ cores
- RAM: 512MB+
- Storage: 1GB+

### Network Requirements
- Public IP address
- Stable network connection
- Necessary ports opened

## ❓ Frequently Asked Questions

### 1. Client cannot connect
- Check firewall settings
- Verify certificate configuration
- Confirm server address and port are correct

### 2. Service fails to start
- Check if ports are occupied
- Verify certificate files exist
- Check Docker logs

### 3. Poor connection quality
- Check UDP port range
- Verify network bandwidth
- Adjust client video settings

## 📝 Version History

### v1.0.0 (2026-04-14)
- Initial release
- Complete Docker deployment configuration
- SSL certificate generation script
- Detailed configuration documentation

## 🔗 Related Links

- [CrossDesk Official GitHub](https://github.com/kunkundi/crossdesk)
- [CrossDesk Official Website](https://www.crossdesk.cn/)
- [Docker Image](https://hub.docker.com/r/crossdesk/crossdesk-server)

## 📄 License

This project is based on CrossDesk's LGPL-3.0 license.

## 🤝 Contributing

Welcome to submit Issues and Pull Requests to improve this project.

## 📧 Contact

If you have questions, please provide feedback through GitHub Issues.

---
**Deployment Time**: 2026-04-14  
**Last Updated**: 2026-04-14  
**Repository URL**: https://github.com/qq510457577-tech/crossdesk-self-hosted-server