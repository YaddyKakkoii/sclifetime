#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID
country=ID
state=Jawa-Tengah 
locality=Magelang
organization=YaddyKakkoii
organizationalunit=YaddyKakkoii
commonname=YaddyKakkoii
email=njajaldoang@gmail.com
REPO="https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/"
#curl -sS http://install.yudhy.net/FILE/SSH/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
#wget -O /etc/pam.d/common-password "${REPO}common-password"
REPOC="https://raw.githubusercontent.com/YaddyKakkoii/casper/main/"
curl -sS ${REPOC}password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password
cd /root
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END
chmod +x /etc/rc.local
systemctl enable rc-local
systemctl start rc-local.service

echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y
apt -y install jq
apt -y install shc
apt -y install wget curl
apt-get install figlet -y
apt-get install ruby -y
gem install lolcat

ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

function nginx_install() {
#apt -y install nginx
Green="\e[92;1m"
RED="\033[31m"
BLUE="\033[36m"
YELLOW="\033[33m"
FONT="\033[0m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
REDBG="\033[41;37m"
OSvpsmu=$(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g')
sistemoperasimu=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
function print_ok() {
    echo -e "${OK} ${BLUE} $1 ${FONT}"
}
function print_error() {
    echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}
function judge() {
    if [[ 0 -eq $? ]]; then
        print_ok "$1 Complete... | thanks to master ${YELLOW}YaddyKakkoii${FONT}"
        sleep 1
    fi
}
    if [[ ${OSvpsmu} == "ubuntu" ]]; then
        judge "Setup nginx For OS Is ${sistemoperasimu}"
        rm -f /etc/apt/sources.list.d/nginx.list
        sudo apt-get install -y curl gnupg2 ca-certificates lsb-release ubuntu-keyring
        curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
        http://nginx.org/packages/ubuntu $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx
        apt-get update -y && sudo apt-get install -y nginx
    elif [[ ${OSvpsmu} == "debian" ]]; then
        judge "Setup nginx For OS Is ${sistemoperasimu}"
        rm -f /etc/apt/sources.list.d/nginx.list
        apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
        curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
        echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
        http://nginx.org/packages/debian $(lsb_release -cs) nginx" | tee /etc/apt/sources.list.d/nginx.list
        echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" | tee /etc/apt/preferences.d/99nginx
        apt update -y && apt install -y nginx
    else
        echo -e "${RED} Your OS Is Not Supported ( ${YELLOW}${sistemoperasimu} ${NC}"
        sleep 3
        exit 1
    fi
}
nginx_install
cd /root
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "${REPO}nginx.conf"
rm /etc/nginx/conf.d/vps.conf
wget -O /etc/nginx/conf.d/vps.conf "${REPO}vps.conf"
curl ${REPO}nginx.conf > /etc/nginx/nginx.conf
curl ${REPO}vps.conf > /etc/nginx/conf.d/vps.conf
/etc/init.d/nginx restart
sed -i 's/listen = \/var\/run\/php-fpm.sock/listen = 127.0.0.1:9000/g' /etc/php/fpm/pool.d/www.conf > /dev/null 2>&1
mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
sleep 3
cd /root
useradd -m vps;
mkdir /home/vps
mkdir /home/vps/public_html
echo "<?php phpinfo() ?>" > /home/vps/public_html/info.php
wget -O /home/vps/public_html/index.html "${REPO}index.txt"
wget -O /home/vps/public_html/tele.html "${REPOC}index.html"
mkdir /home/vps/public_html/ss-ws
mkdir /home/vps/public_html/clash-ws
chown -R www-data:www-data /home/vps/public_html
chmod -R g+rw /home/vps/public_html
systemctl daemon-reload
/etc/init.d/nginx restart
/etc/init.d/nginx status

badvpncasper(){
cd /root
wget -O /usr/sbin/badvpn "${REPO}badvpn" >/dev/null 2>&1
chmod +x /usr/sbin/badvpn > /dev/null 2>&1
wget -q -O /etc/systemd/system/badvpn1.service "${REPO}badvpn1.service" >/dev/null 2>&1
wget -q -O /etc/systemd/system/badvpn2.service "${REPO}badvpn2.service" >/dev/null 2>&1
wget -q -O /etc/systemd/system/badvpn3.service "${REPO}badvpn3.service" >/dev/null 2>&1
systemctl disable badvpn1 
systemctl stop badvpn1 
systemctl enable badvpn1
systemctl start badvpn1 
systemctl disable badvpn2 
systemctl stop badvpn2 
systemctl enable badvpn2
systemctl start badvpn2 
systemctl disable badvpn3 
systemctl stop badvpn3 
systemctl enable badvpn3
systemctl start badvpn3
}
# badvpncasper
cd /root
wget -O /usr/bin/badvpn-udpgw "${REPO}udpgw"
chmod +x /usr/bin/badvpn-udpgw
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500' /etc/rc.local
sed -i '$ i\screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500' /etc/rc.local
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500

cd /root
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
#wget -O /etc/ssh/sshd_config "${REPO}sshd_config"
/etc/init.d/ssh restart

echo "=== Install Dropbear ==="
#apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
#sed -i 's/DROPBEAR_EXTRA_ARGS=/#DROPBEAR_EXTRA_ARGS=/g' /etc/default/dropbear
#sed -i '/arguments for Dropbear/a DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

cd /root
hosnem=( `hostname` )
#apt -y install squid
#apt -y install squid3
wget -O /etc/squid/squid.conf "${REPO}squid3.conf"
sed -i $MYIP2 /etc/squid/squid.conf
sed -i "s/yaddykakkoiisugoiitensaii/$hosnem/g" /etc/squid/squid.conf

cd /root
# install stunnel
#apt install stunnel4 -y
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[openssh]
accept = 222
connect = 127.0.0.1:22

[ws-openssh]
accept = 226
connect = 127.0.0.1:88

[dropbear]
accept = 777
connect = 127.0.0.1:109

[ws-stunnel]
accept = 2096
connect = 700

[openvpn]
accept = 442
connect = 127.0.0.1:1194

END

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart
/etc/init.d/stunnel4 status
sleep 3
cd /root
wget ${REPO}vpn.sh &&  chmod +x vpn.sh && ./vpn.sh
cd /root
wget ${REPOC}udp-custom.sh && chmod +x udp-custom.sh && ./udp-custom.sh 2200
#wget ${REPOC}lolcat.sh &&  chmod +x lolcat.sh && ./lolcat.sh

# memory swap 10gb
cd /root
dd if=/dev/zero of=/swapfile bs=1024 count=5242880
mkswap /swapfile
chown root:root /swapfile
chmod 0600 /swapfile >/dev/null 2>&1
swapon /swapfile >/dev/null 2>&1
sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

apt -y install fail2ban
function proteksiddos(){
clear
echo; echo 'Installing DOS-Deflate 0.6'; echo
echo; echo -n 'Downloading source files...'
wget -q -O /usr/local/ddos/ddos.conf http://www.inetbase.com/scripts/ddos/ddos.conf
echo -n '.'
wget -q -O /usr/local/ddos/LICENSE http://www.inetbase.com/scripts/ddos/LICENSE
echo -n '.'
wget -q -O /usr/local/ddos/ignore.ip.list http://www.inetbase.com/scripts/ddos/ignore.ip.list
echo -n '.'
wget -q -O /usr/local/ddos/ddos.sh http://www.inetbase.com/scripts/ddos/ddos.sh
chmod 0755 /usr/local/ddos/ddos.sh
cp -s /usr/local/ddos/ddos.sh /usr/local/sbin/ddos
echo '...done'
echo; echo -n 'Creating cron to run script every minute.....(Default setting)'
/usr/local/ddos/ddos.sh --cron > /dev/null 2>&1
echo '.....done'
echo; echo 'Installation has completed.'
echo 'Config file is at /usr/local/ddos/ddos.conf'
echo 'Please send in your comments and/or suggestions to zaf@vsnl.com'
}
    if [ -d '/usr/local/ddos' ]; then
	    echo; echo; echo "Please un-install the previous version first"
	    clear
    else
	    mkdir /usr/local/ddos
        proteksiddos
    fi
function blokirtorrent(){
# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
}
#blokirtorrent

echo -e "[ ${green}INFO$NC ] Settings banner"
wget -q -O /etc/issue.net "${REPO}issue.net"
chmod +x /etc/issue.net
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

cd /root
wget -qO /usr/bin/clearlog "${REPO}clearlog.sh" && chmod 777 /usr/bin/clearlog
echo "*/25 * * * * root clearlog" >> /etc/crontab

cat> /etc/cron.d/ifmid << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
1 19 * * * root /usr/sbin/ifmid
END

#if [ ! -f "/etc/cron.d/bckp_otm" ]; then
cat> /etc/cron.d/bckp_otm << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /usr/bin/bottelegram
END
#fi

cat> /etc/cron.d/tendang << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/13 * * * * root /usr/bin/tendang
END

cat> /etc/cron.d/xraylimit << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/15 * * * * root /usr/bin/xraylimit
END

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 7 * * * root /sbin/reboot
END
#if [ ! -f "/etc/cron.d/xp_otm" ]; then
cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END
#fi
cat > /home/re_otm <<-END
7
END

REPOX="https://raw.githubusercontent.com/YaddyKakkoii/tes/main/"
cd /usr/bin
wget -qO gpgw "${REPOX}ewe"
wget -O speedtest "${REPO}speedtest_cli.py"
wget -O xp "${REPO}xp.sh"
wget -O auto-set "${REPO}auto-set.sh"
chmod +x speedtest
chmod +x xp
chmod +x auto-set
chmod +x gpgw
cd /root
echo -e "[ ${green}INFO$NC ] Please Wait until prosessz is finishzz..."
gpgw
echo -e "[ ${green}INFO$NC ] Clearing trash"
    if dpkg -s unscd >/dev/null 2>&1; then
        apt -y remove --purge unscd >/dev/null 2>&1
    fi
#apt-get -y --purge remove samba* >/dev/null 2>&1
apt-get -y --purge remove apache2* >/dev/null 2>&1
apt -y --purge remove apache2* >/dev/null 2>&1
apt-get purge apache2 -y >/dev/null 2>&1
# apt-get -y --purge remove bind9* >/dev/null 2>&1
# apt-get -y remove sendmail* >/dev/null 2>&1
apt autoclean -y >/dev/null 2>&1
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y

cd /root
chown -R www-data:www-data /home/vps/public_html

echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting cron "
service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting openvpn "
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting ssh "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting fail2ban "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting vnstat "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting squid "
/etc/init.d/squid restart >/dev/null 2>&1
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7100 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7200 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7300 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7400 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7500 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7600 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7700 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7800 --max-clients 500
screen -dmS badvpn badvpn-udpgw --listen-addr 127.0.0.1:7900 --max-clients 500
history -c
echo "unset HISTFILE" >> /etc/profile
# finihsing
rm /usr/bin/gpgw > /dev/null 2>&1
rm /root/udp-custom.sh > /dev/null 2>&1
rm -f /root/key.pem > /dev/null 2>&1
rm -f /root/cert.pem > /dev/null 2>&1
rm -f /root/ssh-vpn.sh > /dev/null 2>&1
rm -f /root/bbr.sh > /dev/null 2>&1
rm -rf /etc/apache2 > /dev/null 2>&1
rm -f /root/vpn.sh > /dev/null 2>&1
clear
