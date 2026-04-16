# 🚀 TeleMT 一键安装工具

![Linux](https://img.shields.io/badge/Linux-Supported-green)
![Status](https://img.shields.io/badge/Status-Stable-blue)
![Use](https://img.shields.io/badge/Use-Personal-orange)

这是一个用于快速部署 TeleMT 代理服务的一键安装脚本工具，支持：

- 自动安装
- systemd 守护
- 自动重启
- 自动端口切换（443 → 8443）
- 自动生成密钥
- 自动防火墙配置

适用于：
Ubuntu / Debian / Oracle Linux / ARM / x86 服务器
查看状态
systemctl status telemt
重启服务
systemctl restart telemt
查看日志
journalctl -u telemt -f

---

## ⚡ 一键安装

```bash
curl -s https://raw.githubusercontent.com/GuoMarks/telemt-installer/main/install.sh -o install.sh && sudo bash install.sh
