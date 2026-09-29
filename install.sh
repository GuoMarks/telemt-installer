#!/bin/bash

set -e

echo "===== TeleMT Auto-Port Installer ====="

# =========================
# 0. Root check
# =========================
if [ "$EUID" -ne 0 ]; then
  echo "[ERROR] Please run as root: sudo bash install.sh"
  exit 1
fi

# =========================
# 1. Dependencies
# =========================
apt update -y
apt install -y wget tar openssl ufw curl

# =========================
# 2. Detect port (AUTO SWITCH)
# =========================
PORT=443

if ss -tlnp | grep -q ':443'; then
  echo "[WARN] 443 is in use, switching to 8443"
  PORT=8443
fi

# =========================
# 3. Download TeleMT
# =========================
cd /usr/local/bin

URL="https://github.com/telemt/telemt/releases/latest/download/telemt-aarch64-linux-gnu.tar.gz"

wget -q --show-progress --tries=3 --timeout=10 "$URL"

if [ ! -f telemt-aarch64-linux-gnu.tar.gz ]; then
  echo "[ERROR] Download failed"
  exit 1
fi

tar -zxvf telemt-aarch64-linux-gnu.tar.gz
chmod +x telemt
rm -f telemt-aarch64-linux-gnu.tar.gz

# =========================
# 4. Config
# =========================
mkdir -p /etc/telemt

SECRET=$(openssl rand -hex 16)

cat > /etc/telemt/config.toml <<EOF
[general]
log_level = "silent"

[general.modes]
tls = true

[server]
port = $PORT

[[server.listeners]]
ip = "0.0.0.0"

[censorship]
tls_domain = "www.cloudflare.com"

[access.users]
user1 = "$SECRET"
EOF

# =========================
# 5. Firewall
# =========================
ufw allow 22
ufw allow $PORT
ufw --force enable

# =========================
# 6. systemd (auto restart)
# =========================
cat > /etc/systemd/system/telemt.service <<EOF
[Unit]
Description=TeleMT Proxy Service
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/telemt /etc/telemt/config.toml

Restart=always
RestartSec=3
StartLimitIntervalSec=0

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable telemt
systemctl restart telemt

# =========================
# 7. Output
# =========================
sleep 2

IP=$(curl -s ifconfig.me)

# TLS domain hex encode
DOMAIN_HEX=$(echo -n "www.cloudflare.com" | xxd -p)

echo ""
echo "=============================="
echo " INSTALL SUCCESS"
echo "=============================="
echo ""
echo "Used Port: $PORT"
echo ""
echo "Telegram Proxy Link:"
echo ""
echo "tg://proxy?server=$IP&port=$PORT&secret=ee${SECRET}${DOMAIN_HEX}"
echo ""
echo "Service:"
echo "systemctl status telemt"
echo ""
