# 🚀 TeleMT 一键安装工具

这是一个用于快速部署 TeleMT 代理服务的脚本工具，支持：

- 一键安装
- systemd 守护（自动重启）
- 自动端口切换（443 → 8443）
- 自动生成密钥
- 防火墙自动配置

适用于：
- Ubuntu / Debian / Oracle Linux
- ARM / x86 服务器

---

# ⚡ 一键安装

## 第一步：下载脚本
```bash
curl -s https://raw.githubusercontent.com/GuoMarks/telemt-installer/main/install.sh -o install.sh
