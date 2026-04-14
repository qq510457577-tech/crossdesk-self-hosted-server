#!/bin/bash
set -e

# 检查参数
if [ "$#" -ne 1 ]; then
 echo "Usage: $0 <SERVER_IP>"
 exit 1
fi

SERVER_IP="$1"

# 文件名
ROOT_KEY="crossdesk.cn_root.key"
ROOT_CERT="crossdesk.cn_root.crt"
SERVER_KEY="crossdesk.cn.key"
SERVER_CSR="crossdesk.cn.csr"
SERVER_CERT="crossdesk.cn_bundle.crt"
FULLCHAIN_CERT="crossdesk.cn_fullchain.crt"

# 证书主题
SUBJ="/C=CN/ST=Zhejiang/L=Hangzhou/O=CrossDesk/OU=CrossDesk/CN=$SERVER_IP"

# 1. 生成根证书
echo "Generating root private key..."
openssl genrsa -out "$ROOT_KEY" 4096

echo "Generating self-signed root certificate..."
openssl req -x509 -new -nodes -key "$ROOT_KEY" -sha256 -days 3650 -out "$ROOT_CERT" -subj "$SUBJ"

# 2. 生成服务器私钥
echo "Generating server private key..."
openssl genrsa -out "$SERVER_KEY" 2048

# 3. 生成服务器 CSR
echo "Generating server CSR..."
openssl req -new -key "$SERVER_KEY" -out "$SERVER_CSR" -subj "$SUBJ"

# 4. 生成临时 OpenSSL 配置文件，加入 SAN
SAN_CONF="san.cnf"
cat > $SAN_CONF <<EOL
[ req ]
default_bits = 2048
distinguished_name = req_distinguished_name
req_extensions = req_ext
prompt = no

[ req_distinguished_name ]
C = CN
ST = Zhejiang
L = Hangzhou
O = CrossDesk
OU = CrossDesk
CN = $SERVER_IP

[ req_ext ]
subjectAltName = IP:$SERVER_IP
EOL

# 5. 用根证书签发服务器证书（包含 SAN）
echo "Signing server certificate with root certificate..."
openssl x509 -req -in "$SERVER_CSR" -CA "$ROOT_CERT" -CAkey "$ROOT_KEY" -CAcreateserial \
 -out "$SERVER_CERT" -days 3650 -sha256 -extfile "$SAN_CONF" -extensions req_ext

# 6. 生成完整链证书
cat "$SERVER_CERT" "$ROOT_CERT" > "$FULLCHAIN_CERT"

# 7. 清理中间文件
rm -f "$ROOT_CERT.srl" "$SAN_CONF" "$ROOT_KEY" "$SERVER_CSR" "$FULLCHAIN_CERT"

echo "Generation complete. Deployment files:"
echo " Client root certificate: $ROOT_CERT"
echo " Server private key: $SERVER_KEY"
echo " Server certificate: $SERVER_CERT"