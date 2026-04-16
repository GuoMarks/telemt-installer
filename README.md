# 🚀 TeleMT 一键安装工具

用于快速部署 TeleMT 代理服务，支持：

- 一键安装
- systemd 守护（自动重启）
- 自动端口切换（443 → 8443）
- 自动生成密钥
- 自动防火墙配置

适用于：
- Ubuntu / Debian / Oracle Linux
- ARM / x86 服务器

---

# ⚡ 安装步骤（严格按顺序执行）

---

## 🧩 第一步：下载脚本

```bash
curl -s https://raw.githubusercontent.com/GuoMarks/telemt-installer/main/install.sh -o install.sh
