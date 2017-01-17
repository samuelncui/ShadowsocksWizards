#!/bin/bash

cd /tmp

apt-get -y update
apt-get -y upgrade
apt-get -y install supervisor

wget http://kernel.ubuntu.com/~kernel-ppa/mainline/v4.9.4/linux-image-4.9.4-040904-generic_4.9.4-040904.201701150831_amd64.deb
dpkg -i linux-image-4.9.4-040904-generic_4.9.4-040904.201701150831_amd64.deb
update-grub
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

read -r -p "Is your network high-latency or low-latency? [H/l]: " response
case $response in
    [lL]*)
        modprobe tcp_htcp
        ;;
    *)
        modprobe tcp_hybla
        ;;
esac

wget https://github.com/abc950309/ShadowsocksWizards/raw/master/download/shadowsocks-server.gz
gzip -d shadowsocks-server.gz
mv shadowsocks-server /usr/bin/shadowsocks-server
chown root:root /usr/bin/shadowsocks-server
chmod 755 /usr/bin/shadowsocks-server

if [ ! -d /etc/shadowsocks ];then
    mkdir /etc/shadowsocks
fi

cat > /etc/shadowsocks/config.json<<-EOF
{
    "server": "0.0.0.0",
    "server_port": 443,
    "local_port": 1080,
    "password": "password",
    "method": "aes-128-cfb-auth",
    "timeout": 600
}
EOF

read -r -p "Do you want to change the default config? [Y/n]: " response
case $response in
    [nN]*)
        ;;
    *)
        vim /etc/shadowsocks/config.json
        ;;
esac

cat > /etc/supervisor/shadowsocks.conf<<-EOF
[program:shadowsocks]

command=shadowsocks-server
environment=LANG=en_US.UTF-8,LC_ALL=en_US.UTF-8,LC_LANG=en_US.UTF-8
autorstart=true
directory=/etc/shadowsocks
autorestart=true
startsecs=10
startretries=36
redirect_stderr=true
stdout_logfile=/var/log/shadowsocks-server.out.log
stderr_logfile=/var/log/shadowsocks-server.err.log
EOF

echo "3 4 * * 1 root reboot" >> /etc/crontab
apt-get -y autoremove
apt-get -y autoclean

reboot
