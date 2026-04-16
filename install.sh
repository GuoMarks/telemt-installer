#!/bin/bash

set -e

echo "===== TeleMT One-Click Installer ====="

# 更新系统
apt update -y
apt install -y wget tar openssl ufw curl

# 下载 telemt
cd /usr/local/bin
wget -q https://github.com/telemt/telemt/releases/latest/download/telemt-aarch64-linux-gnu.tar.gz

tar -zxvf telemt-aarch64-linux-gnu.tar.gz
chmod +x telemt
rm -f telemt-aarch64-linux-gnu.tar.gz

# 配置目录
mkdir -p /etc/telemt

# 生成 secret
SECRET=$(openssl rand -hex 16)

# 写配置
cat > /etc/telemt/config.toml << EOF
[general]
log_level = "silent"

[general.modes]
tls = true

[server]
port = 443

[[server.listeners]]
ip = "0.0.0.0"

[censorship]
tls_domain = "www.cloudflare.com"

[access.users]
user1 = "$SECRET"
EOF

# 防火墙
ufw default deny incoming
ufw allow 443
ufw allow 22
ufw --force enable

# systemd
cat > /etc/systemd/system/telemt.service << EOF
[Unit]
Description=TeleMT Proxy
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/telemt /etc/telemt/config.toml
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable telemt
systemctl start telemt

sleep 2

IP=$(curl -s ifconfig.me)

echo ""
echo "===== INSTALL COMPLETE ====="
echo ""
echo "Telegram Proxy Link:"
echo "tg://proxy?server=$IP&port=443&secret=ee$SECRET"
echo ""
