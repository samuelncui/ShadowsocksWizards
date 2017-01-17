# ShadowsocksWizards

A Shadowsocks Installation Wizards for Ubuntu Server

一个为 Ubuntu Server 准备的引导式 Shadowsocks 自动安装脚本

## 使用

```shell
wget --no-check-certificate https://raw.githubusercontent.com/abc950309/ShadowsocksWizards/master/wizards.sh
sudo bash wizards.sh
```

## 特性

 * 自动安装 shadowsocks-go，并询问是否更改默认配置
 * 自动安装 Google TCP BBR
 * 询问响应类型，并根据响应类型进行 TCP 优化
 * 自动添加每周重启，防止长时间开机后死机
 * 自动安装 supervisor 作为守护进程
 * 自动清理缓存文件
 * 默认监听 443，利用 GFW 对常用端口检查较弱提高速度。
