#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
#https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/prem.sh
#http://gitlab.mzyaddy.ganteng.tech/prem.sh
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
clear
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
function cekroot(){
    if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
    fi
    if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
    fi
}
function removepurge(){
        apt-get -y remove nginx*
        apt-get -y --purge remove nginx*
        apt-get purge nginx -y
        apt-get purge nginx nginx-common nginx-core -y
        apt-get -y remove --purge nginx nginx-common nginx-core -y
        sudo apt-get remove --purge nginx -y
        sudo apt-get remove --purge nginx-common -y
        apt-get clean all && apt update -y
        sudo apt-get clean
        sudo apt-get autoclean
        sudo apt-get autoremove -y
        apt -y remove nginx*
        apt -y --purge remove nginx*
        apt purge nginx -y
        apt purge nginx nginx-common nginx-core -y
        apt -y remove --purge nginx nginx-common nginx-core -y
        sudo apt remove --purge nginx -y
        sudo apt remove --purge nginx-common -y
        apt clean all && apt update -y
        sudo apt clean
        sudo apt autoclean
        sudo apt autoremove -y

        apt-get -y remove dropbear*
        apt-get -y --purge remove dropbear*
        apt-get purge dropbear -y
        apt-get -y remove --purge dropbear -y
        sudo apt-get remove --purge dropbear -y
        apt-get clean all && apt update -y
        sudo apt-get clean
        sudo apt-get autoclean
        sudo apt-get autoremove -y
        apt -y remove dropbear*
        apt -y --purge remove dropbear*
        apt purge dropbear -y
        apt -y remove --purge dropbear -y
        sudo apt-get remove --purge dropbear -y
        apt-get clean all && apt update -y
        sudo apt-get clean
        sudo apt-get autoclean
        sudo apt-get autoremove -y
}
function ceksisainstalasi(){
    if [ -f "/etc/xray/domain" ]; then
        echo ""
        echo -e "[ ${green}INFO${NC} ] Terdeteksi Pernah Di install Skrip "
        echo -ne "[ ${yell}WARNING${NC} ] Apakah Anda ingin menginstal lagi ? (y/n)? "
        read answer
        if [ "$answer" == "${answer#[Yy]}" ] ;then
            rm setup.sh > /dev/null 2>&1
            sleep 10
            exit 0
        else
            removepurge
            clear
        fi
    fi
}
cekroot
ceksisainstalasi
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
    if [[ "$hst" != "$dart" ]]; then
        echo "$localip $(hostname)" >> /etc/hosts
    fi
mkdir -p /etc/xray
touch /etc/xray/domain
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
coreselect=''
cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
END
chmod 644 /root/.profile
mkdir -p /var/lib/yaddykakkoii >/dev/null 2>&1
echo "IP=" >> /var/lib/yaddykakkoii/ipvps.conf
wget -q "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/tools.sh" && chmod +x tools.sh;./tools.sh && rm tools.sh && clear
wget -q "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/domaincf.sh" && chmod +x domaincf.sh;./domaincf.sh && rm domaincf.sh && clear
function sshvpn(){
export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID
curl -sS https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password
chmod +x /etc/pam.d/common-password
cd
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
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

function nginx_install() {
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
judge() {
    if [[ 0 -eq $? ]]; then
        print_ok "$1 Complete... | thx to ${YELLOW}Yaddy_Kakkoii_ganteng_maksimal${FONT}"
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
        apt update -y && sudo apt-get install -y nginx
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
apt -y --purge remove apache2*
apt-get purge apache2 -y
sudo apt clean
sudo apt autoclean
sudo apt autoremove -y
}
nginx_install
cd /root
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
#rm /etc/nginx/nginx.conf > /dev/null 2>&1
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf" && chmod 777 /etc/nginx/nginx.conf
    mkdir -p /etc/systemd/system/nginx.service.d
    printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
    rm /etc/nginx/conf.d/default.conf > /dev/null 2>&1
mkdir -p /home/vps/public_html
/etc/init.d/nginx restart

cd /root
function pasangbadvpn(){
wget -O /usr/bin/badvpn-udpgw "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpgw"
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

}
    if [ -f "/usr/bin/badvpn-udpgw" ]; then
        echo "sudah ada badvpn, skip.." && sleep 3
        clear
    else
        pasangbadvpn
    fi
echo "=== Install Dropbear ==="

function pasangdropbear(){
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 22' /etc/ssh/sshd_config
/etc/init.d/ssh restart
source /etc/os-release
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    #purgedropbeardebian
                    apt -y install dropbear
            else
                    #purgedropbearubuntu
                    apt-get -y install dropbear
            fi
    else
        echo "ini vps Centos"
        OS=centos
        yum install -y dropbear
        echo "ubah manual apt menjadi yum , contoh apt install squid menjadi yum install squid"
        echo "atau chat saya di telegram kalau kamu ga paham"
        echo "contact person t.me/Crystalllz"
        #exit
        sleep 3s
    fi
}
pasangdropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

cd /root
function pasangstunnel(){
source /etc/os-release
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt install stunnel4 -y
            else
                    apt-get stunnel4 -y
            fi
    else
        echo "ini vps Centos"
        OS=centos
        yum install stunnel4 -y
        echo "ubah manual apt menjadi yum , contoh apt install squid menjadi yum install squid"
        echo "atau chat saya di telegram kalau kamu ga paham"
        echo "contact person t.me/Crystalllz"
        #exit
        sleep 3s
    fi
}
pasangstunnel
cat > /etc/stunnel/stunnel.conf <<-END
cert = /etc/stunnel/stunnel.pem
client = no
socket = a:SO_REUSEADDR=1
socket = l:TCP_NODELAY=1
socket = r:TCP_NODELAY=1

[dropbear]
accept = 222
connect = 127.0.0.1:22

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
rm /etc/stunnel/stunnel.pem > /dev/null 2>&1

country=ID
state=Indonesia
locality=none
organization=none
organizationalunit=none
commonname=none
email=adamspx17@gmail.com
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

function pasangfail2ban(){
source /etc/os-release
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt -y install fail2ban
            else
                    apt-get -y install fail2ban
            fi
    else
        echo "ini vps Centos"
        OS=centos
        yum -y install fail2ban
        echo "ubah manual apt menjadi yum , contoh apt install squid menjadi yum install squid"
        echo "atau chat saya di telegram kalau kamu ga paham"
        echo "contact person t.me/Crystalllz"
        #exit
        sleep 3s
    fi
}
pasangfail2ban

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

# banner /etc/issue.net
sleep 1
echo -e "[ ${green}INFO$NC ] Settings banner"
rm -f /etc/issue.net && rm -f /home/vps/public_html/index.html > /dev/null 2>&1
wget -qO /etc/issue.net "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/issue.net"
wget -qO /home/vps/public_html/index.html "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/index.txt"
chmod 777 /etc/issue.net && chmod 777 /home/vps/public_html/index.html

echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

#install bbr dan optimasi kernel
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/bbr.sh && chmod +x bbr.sh && ./bbr.sh

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

wget -qO /usr/bin/clearlog "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/clearlog.sh"
chmod 777 /usr/bin/clearlog
echo "*/25 * * * * root clearlog" >> /etc/crontab

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 2 * * * root /sbin/reboot
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END

service cron restart >/dev/null 2>&1
service cron reload >/dev/null 2>&1

# remove unnecessary files
sleep 1
echo -e "[ ${green}INFO$NC ] Clearing trash"
apt autoclean -y >/dev/null 2>&1

if dpkg -s unscd >/dev/null 2>&1; then
apt -y remove --purge unscd >/dev/null 2>&1
fi

apt-get -y --purge remove samba* >/dev/null 2>&1
apt-get -y --purge remove apache2* >/dev/null 2>&1
apt-get -y --purge remove bind9* >/dev/null 2>&1
apt-get -y remove sendmail* >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
# finishing
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"
/etc/init.d/nginx restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting nginx"
/etc/init.d/openvpn restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting cron "
/etc/init.d/ssh restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting ssh "
/etc/init.d/dropbear restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting dropbear "
/etc/init.d/fail2ban restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting fail2ban "
/etc/init.d/stunnel4 restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting stunnel4 "
/etc/init.d/vnstat restart >/dev/null 2>&1
sleep 1
echo -e "[ ${green}ok${NC} ] Restarting vnstat "
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
clear
}

function pasangxray(){
echo -e "
"
date
echo ""
domain=$(cat /etc/xray/domain)
sleep 1
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y


# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version 1.5.6

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
/etc/init.d/nginx status
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)
# xray config
cat > /etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10085,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "14016",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"                 
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vless"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "23456",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "127.0.0.1",
      "port": "25432",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",		
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/trojan-ws"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "30300",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },	
      {
        "listen": "127.0.0.1",
     "port": "24456",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
     "port": "31234",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
     "port": "33456",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
   },
   {
    "listen": "127.0.0.1",
    "port": "30310",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }	
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END
rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
cat > /etc/systemd/system/runn.service <<EOF
[Unit]
Description=Mantap-Sayang
After=network.target

[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

# Install Trojan Go
latest_version="$(curl -s "https://api.github.com/repos/p4gefau1t/trojan-go/releases" | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
trojango_link="https://github.com/p4gefau1t/trojan-go/releases/download/v${latest_version}/trojan-go-linux-amd64.zip"
mkdir -p "/usr/bin/trojan-go"
mkdir -p "/etc/trojan-go"
cd `mktemp -d`
curl -sL "${trojango_link}" -o trojan-go.zip
unzip -q trojan-go.zip && rm -rf trojan-go.zip
mv trojan-go /usr/local/bin/trojan-go
chmod +x /usr/local/bin/trojan-go
mkdir /var/log/trojan-go/
touch /etc/trojan-go/akun.conf
touch /var/log/trojan-go/trojan-go.log

# Buat Config Trojan Go
cat > /etc/trojan-go/config.json << END
{
  "run_type": "server",
  "local_addr": "0.0.0.0",
  "local_port": 2087,
  "remote_addr": "127.0.0.1",
  "remote_port": 89,
  "log_level": 1,
  "log_file": "/var/log/trojan-go/trojan-go.log",
  "password": [
      "$uuid"
  ],
  "disable_http_check": true,
  "udp_timeout": 60,
  "ssl": {
    "verify": false,
    "verify_hostname": false,
    "cert": "/etc/xray/xray.crt",
    "key": "/etc/xray/xray.key",
    "key_password": "",
    "cipher": "",
    "curves": "",
    "prefer_server_cipher": false,
    "sni": "$domain",
    "alpn": [
      "http/1.1"
    ],
    "session_ticket": true,
    "reuse_session": true,
    "plain_http_response": "",
    "fallback_addr": "127.0.0.1",
    "fallback_port": 0,
    "fingerprint": "firefox"
  },
  "tcp": {
    "no_delay": true,
    "keep_alive": true,
    "prefer_ipv4": true
  },
  "mux": {
    "enabled": false,
    "concurrency": 8,
    "idle_timeout": 60
  },
  "websocket": {
    "enabled": true,
    "path": "/trojango",
    "host": "$domain"
  },
    "api": {
    "enabled": false,
    "api_addr": "",
    "api_port": 0,
    "ssl": {
      "enabled": false,
      "key": "",
      "cert": "",
      "verify_client": false,
      "client_cert": []
    }
  }
}
END

# Installing Trojan Go Service
cat > /etc/systemd/system/trojan-go.service << END
[Unit]
Description=Trojan-Go Service Mod By ARTA M
Documentation=github.com/adammoi/vipies
After=network.target nss-lookup.target

[Service]
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/trojan-go -config /etc/trojan-go/config.json
Restart=on-failure
RestartPreventExitStatus=23

[Install]
WantedBy=multi-user.target
END

# Trojan Go Uuid
cat > /etc/trojan-go/uuid.txt << END
$uuid
END

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name $domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        }
EOF
sed -i '$ ilocation = /vless' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:14016;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /vmess' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23456;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojan-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:25432;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /trojango' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:2087;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation = /ss-ws' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:30300;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:24456;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:31234;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf

sed -i '$ ilocation ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i{' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:33456;' /etc/nginx/conf.d/xray.conf
sed -i '$ i}' /etc/nginx/conf.d/xray.conf
mkdir -p /root/backupxraykonfig
mv -f /etc/nginx/nginx.conf /root/backupxraykonfig
mv -f /etc/nginx/conf.d/xray.conf /root/backupxraykonfig
mv -f /etc/nginx/conf.d/vps.conf /root/backupxraykonfig
mv -f /etc/xray/config.json /root/backupxraykonfig/config.json.txt

uuid=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
wget -qO /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf"
chmod 777 /etc/nginx/conf.d/vps.conf
wget -qO /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf"
chmod 777 /etc/nginx/nginx.conf
wget -qO /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xray.conf"
chmod 777 /etc/nginx/conf.d/xray.conf
sed -i "s/yaddyganteng/${domainn}/g" /etc/nginx/conf.d/xray.conf
sed -i "s/trojan-ws/yaddyganteng/g" /etc/nginx/conf.d/xray.conf
wget -qO /etc/xray/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/config.json.txt"
chmod 777 /etc/xray/config.json
sed -i "s/yaddytampan/${uuid}/g" /etc/xray/config.json
sed -i "s/trojan-ws/yaddyganteng/g" /etc/xray/config.json

TIMES="10"
TIME=$(date +'%Y-%m-%d %H:%M:%S')
MYIP=$(wget -qO- ipinfo.io/ip)
CHATID="1117211252"
KEY="6129559221:AAGAkfVQqdi_So98HmZ6edqKovj-I-ldFQQ"
URL="https://api.telegram.org/bot$KEY/sendMessage"
rm /user > /dev/null 2>&1
mkdir -p /user
touch /user/namauser.txt
touch /user/waktuexpiredsc.txt
echo "YADDY KAKKOII" > /user/namauser.txt
echo "UNLIMITED LIFETIME" > /user/waktuexpiredsc.txt
USRSC=$(cat /user/namauser.txt)
EXPSC=$(cat /user/waktuexpiredsc.txt)
TIMEZONE=$(curl -s ipinfo.io/timezone )
domain=$(cat /etc/xray/domain)
TEXT="
<code>────────────────────</code>
<b>⚠️AUTOSCRIPT PREMIUM⚠️</b>
<code>────────────────────</code>
<code>Owner  : </code><code>$USRSC</code>
<code>Domain : </code><code>$domain</code>
<code>Date   : </code><code>$TIME</code>
<code>Time   : </code><code>$TIMEZONE</code>
<code>Ip vps : </code><code>$MYIP</code>
<code>Exp Sc : </code><code>$EXPSC</code>
<code>────────────────────</code>
<i>Automatic Notification from</i>
<i>Github Yaddy Kakkoii</i> 
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ🐳","url":"https://t.me/Crystalllz"},{"text":"ɪɴꜱᴛᴀʟʟ🐬","url":"https://wa.me/6281383460513"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null

echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl daemon-reload
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn
systemctl stop trojan-go
systemctl start trojan-go
systemctl enable trojan-go
systemctl restart trojan-go
clear
}

function installslowdns() {
clear
tyblue='\e[1;36m'
echo -e "${tyblue}.------------------------------------------.${NC}"
echo -e "${tyblue}|           DOWNLOAD SLOWDNS            |${NC}"
echo -e "${tyblue}'------------------------------------------'${NC}"
sleep 2
alat_slowdns() {
    apt update -y && apt install -y dos2unix debconf-utils
    apt install -y python3 python3-dnslib net-tools
    apt install ncurses-utils -y && apt install dnsutils -y
    apt install golang -y && apt install iptables -y
    apt install -y whois && apt install -y sudo gnutls-bin
    apt install -y pwgen python php jq curl
    apt install -y mlocate dh-make libaudit-dev build-essential
}
setup_dnstt() {
    echo "Port 2222" >> /etc/ssh/sshd_config
    echo "Port 2269" >> /etc/ssh/sshd_config
    sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
    service ssh restart && service sshd restart
    nsdomain=$(cat /etc/xray/nsdomain)
	rm -rf /etc/slowdns > /dev/null 2>&1
    mkdir -m 777 /etc/slowdns
    wget -qO /etc/slowdns/dnstt-server "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/dnstt-server"
    wget -qO /etc/slowdns/dnstt-client "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/dnstt-client"
    chmod +x /etc/slowdns/dnstt-client && chmod +x /etc/slowdns/dnstt-server
cd /etc/slowdns
	./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
	chmod +x /etc/slowdns/server.key && chmod +x /etc/slowdns/server.pub
cd
    #client servis yg ini pakai port 443 :v 
    wget -qO /etc/systemd/system/slow-client.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/slow-client.service"
    wget -qO /etc/systemd/system/slow-server.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/slow-server.service"
	sed -i "s/xxxx/$nsdomain/g" /etc/systemd/system/slow-client.service
	sed -i "s/xxxx/$nsdomain/g" /etc/systemd/system/slow-server.service
cat > /etc/systemd/system/client-sldns.service << END
[Unit]
Description=Client SlowDNS By YaddyKakkoii
Documentation=https://t.me/Crystalllz
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-client -udp 8.8.8.8:53 --pubkey-file /etc/slowdns/server.pub $nsdomain 127.0.0.1:2222
Restart=on-failure
[Install]
WantedBy=multi-user.target
END

cat > /etc/systemd/system/server-sldns.service << END
[Unit]
Description=Server SlowDNS By YaddyKakkoii
Documentation=https://t.me/Crystalllz
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-server -udp :5300 -privkey-file /etc/slowdns/server.key $nsdomain 127.0.0.1:2269
Restart=on-failure
[Install]
WantedBy=multi-user.target
END
    chmod +x /etc/systemd/system/client-sldns.service
    chmod +x /etc/systemd/system/server-sldns.service
	iptables -I INPUT -p udp --dport 5300 -j ACCEPT
    iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
    iptables-save >/etc/iptables/rules.v4 >/dev/null 2>&1
    iptables-save >/etc/iptables.up.rules >/dev/null 2>&1
    netfilter-persistent save >/dev/null 2>&1
    netfilter-persistent reload >/dev/null 2>&1
    systemctl enable iptables >/dev/null 2>&1
    systemctl start iptables >/dev/null 2>&1
    systemctl restart iptables >/dev/null 2>&1
    pkill slow-server && pkill slow-client && pkill server-sldns && pkill server-sldns
    pkill dnstt-server && pkill dnstt-client
    systemctl daemon-reload
    systemctl stop client-sldns && systemctl stop server-sldns
    systemctl enable client-sldns && systemctl enable server-sldns
    systemctl start client-sldns && systemctl start server-sldns
    systemctl restart client-sldns && systemctl restart server-sldns
    systemctl stop slow-client && systemctl stop slow-server
    systemctl enable slow-client && systemctl enable slow-server
    systemctl start slow-client && systemctl start slow-server
    systemctl restart slow-client && systemctl restart slow-server
}
alat_slowdns
setup_dnstt
}

function installsshudp(){
clear
#NC='\e[0m'
#tyblue='\e[1;36m'
systemctl stop udp-custom > /dev/null 2>&1
systemctl stop udpcore > /dev/null 2>&1
    echo -e "${tyblue}.------------------------------------------.${NC}"
    echo -e "${tyblue}|           INSTALL UDP            |${NC}"
    echo -e "${tyblue}'------------------------------------------'${NC}"
    sleep 2
rm -f /etc/systemd/system/udp-custom.service > /dev/null 2>&1
rm -f /etc/systemd/system/udpcore.service > /dev/null 2>&1
rm -rf /root/udp > /dev/null 2>&1
rm -rf /etc/udpxyaddy > /dev/null 2>&1
    mkdir -p /etc/udpxyaddy
    echo "change to time GMT+7"
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ixz82G_ruRBnEEp4vLPNF2KZ1k8UfrkV' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ixz82G_ruRBnEEp4vLPNF2KZ1k8UfrkV" -O /etc/udpxyaddy/udpcore
    rm -rf /tmp/cookies.txt && chmod +x /etc/udpxyaddy/udpcore
    wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1klXTiKGUd2Cs5cBnH3eK2Q1w50Yx3jbf' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1klXTiKGUd2Cs5cBnH3eK2Q1w50Yx3jbf" -O /etc/udpxyaddy/config.json
    rm -rf /tmp/cookies.txt && chmod +x /etc/udpxyaddy/config.json
if [ -z "$1" ]; then
cat <<EOF > /etc/systemd/system/udpcore.service
[Unit]
Description=UDP Custom by YaddyKakkoii

[Service]
User=root
Type=simple
ExecStart=/etc/udpxyaddy/udpcore server
WorkingDirectory=/etc/udpxyaddy/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
else
cat <<EOF > /etc/systemd/system/udpcore.service
[Unit]
Description=UDP Custom by YaddyKakkoii

[Service]
User=root
Type=simple
ExecStart=/etc/udpxyaddy/udpcore server -exclude $1
WorkingDirectory=/etc/udpxyaddy/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
fi
wget -q -O /usr/bin/udpxp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpxp.sh" && chmod +x /usr/bin/udpxp; udpxp >/dev/null 2>&1
cat >/etc/cron.d/udpexpi <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/udpxp
END
    chmod +x /etc/systemd/system/udpcore.service
    systemctl daemon-reload
    systemctl start udpcore &>/dev/null
    systemctl enable udpcore &>/dev/null
    service udpcore restart
wget -qO /root/apete "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/apete.sh" && chmod +x /root/apete && ./apete && rm /root/apete
wget -qO /root/updatesshws "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/updatesshws.sh" && chmod +x /root/updatesshws && ./updatesshws && rm /root/updatesshws
}
sshvpn
pasangxray
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/insshws.sh && chmod +x insshws.sh && ./insshws.sh && clear

wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ohp.sh && chmod +x ohp.sh && ./ohp.sh && clear
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/set-br.sh &&  chmod +x set-br.sh && ./set-br.sh && clear
installslowdns
installsshudp

cat> /root/.profile << END
# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

mesg n || true
clear
menu
END
chmod 644 /root/.profile

    if [ -f "/root/log-install.txt" ]; then
        rm /root/log-install.txt > /dev/null 2>&1
    fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
    if [ ! -f "/etc/log-create-user.log" ]; then
        echo "Log All Account " > /etc/log-create-user.log
    fi
history -c
serverV=1.7
echo $serverV > /opt/.ver
autoreboot=$(cat /home/re_otm)
b=11
    if [ $autoreboot -gt $b ]
        then
        gg="PM"
    else
        gg="AM"
    fi
curl -sS ifconfig.me > /etc/myipvps
echo " "
echo "=====================-[ SCRIPT YADDYKAKKOII CELL TUNNEL ]-===================="
echo ""
echo "------------------------------------------------------------"
echo ""
echo ""
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - OpenSSH		: 22"  | tee -a log-install.txt
echo "   - SSH Websocket	: 80 [ON]" | tee -a log-install.txt
echo "   - SSH SSL Websocket	: 443" | tee -a log-install.txt
echo "   - Stunnel4		: 447, 777" | tee -a log-install.txt
echo "   - Dropbear		: 109, 143" | tee -a log-install.txt
echo "   - Badvpn		: 7100-7900" | tee -a log-install.txt
echo "   - Nginx		: 81" | tee -a log-install.txt
echo "   - Vmess TLS		: 443" | tee -a log-install.txt
echo "   - Vmess None TLS	: 80" | tee -a log-install.txt
echo "   - Vless TLS		: 443" | tee -a log-install.txt
echo "   - Vless None TLS	: 80" | tee -a log-install.txt
echo "   - Trojan GRPC		: 443" | tee -a log-install.txt
echo "   - Trojan WS		: 443" | tee -a log-install.txt
echo "   - Trojan Go		: 443" | tee -a log-install.txt
echo "   - slowdns              : 443,80,8080,53,5300" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone		: Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban		: [ON]"  | tee -a log-install.txt
echo "   - Dflate		: [ON]"  | tee -a log-install.txt
echo "   - IPtables		: [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot		: [ON]"  | tee -a log-install.txt
echo "   - IPv6			: [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On	: $autoreboot:00 $gg GMT +7" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully automatic script" | tee -a log-install.txt
echo "   - VPS settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Change port" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""
echo ""
echo "------------------------------------------------------------"
echo ""
echo "===============-[ Script Created By YADDYKAKKOII CELL ]-==============="
echo -e ""
echo ""
echo "" | tee -a log-install.txt
rm -f /root/key.pem
rm -f /root/cert.pem
rm -f /root/ssh-vpn.sh
rm -f /root/bbr.sh
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/setup.sh

function updatemenu() {
cd /root
mkdir -p binari
cd binari

wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu.zip && chmod +x menu.zip && unzip menu.zip && chmod +x *

mv -f * /usr/bin
cd /root

rm -rf binari
clear
rm -fr /root/backupmenu >/dev/null 2>&1
mkdir -p /root/backupmenu


mv -f /usr/bin/menu-backup /root/backupmenu
mv -f /usr/bin/menu-theme /root/backupmenu
mv -f /usr/bin/menu-dns /root/backupmenu
mv -f /usr/bin/info /root/backupmenu
mv -f /usr/bin/menu-set /root/backupmenu
mv -f /usr/bin/updateskrip /root/backupmenu

wget -q -O /usr/bin/menu-backup "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-backup.sh" && chmod +x /usr/bin/menu-backup

wget -q -O /usr/bin/menu-theme "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-theme.sh" && chmod +x /usr/bin/menu-theme

wget -q -O /usr/bin/menu-dns "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-dns.sh" && chmod +x /usr/bin/menu-dns

wget -q -O /usr/bin/menu-set "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-set.sh" && chmod +x /usr/bin/menu-set

wget -q -O /usr/bin/updateskrip "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/updateskrip.sh" && chmod +x /usr/bin/updateskrip

wget -q -O /usr/bin/info "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/info.sh" && chmod +x /usr/bin/info


mv -f /usr/bin/menu-ssh /root/backupmenu
mv -f /usr/bin/menu-vmess /root/backupmenu
mv -f /usr/bin/menu-vless /root/backupmenu
mv -f /usr/bin/menu-ss /root/backupmenu


wget -q -O /usr/bin/menu-ssh "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-ssh.sh" && chmod +x /usr/bin/menu-ssh

wget -q -O /usr/bin/menu-vmess "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-vmess.sh" && chmod +x /usr/bin/menu-vmess

wget -q -O /usr/bin/menu-vless "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-vless.sh" && chmod +x /usr/bin/menu-vless

wget -q -O /usr/bin/menu-ss "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-ss.sh" && chmod +x /usr/bin/menu-ss


mv -f /usr/bin/menu-trojan /root/backupmenu
mv -f /usr/bin/menu /root/backupmenu

wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu.sh" && chmod +x /usr/bin/menu

wget -q -O /usr/bin/menu-trojan "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-trojan.sh" && chmod +x /usr/bin/menu-trojan

#sed -i "s/yudhynetwork-pro/yaddykakkoii/g" /usr/bin/menu-trojan
#sed -i "s/yudhynetwork/yaddykakkoii/g" /usr/bin/menu-trojan
#sed -i "s/yudhynet/yaddyganteng/g" /usr/bin/menu-trojan

wget -q -O /usr/bin/gantidomain "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/gantidomain.sh" && chmod +x /usr/bin/gantidomain

wget -q -O /usr/bin/menuudp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menuudp.sh" && chmod +x /usr/bin/menuudp

wget -q -O /usr/bin/menuslowdns "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menuslowdns.sh" && chmod +x /usr/bin/menuslowdns

wget -q -O /usr/bin/gantixraycore "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/gantixraycore.sh" && chmod +x /usr/bin/gantixraycore


wget -q -O /usr/bin/purgenginx "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/purgenginx.sh" && chmod +x /usr/bin/purgenginx

}
updatemenu

function secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
echo -e "
"
read -n 1 -s -r -p "Press any key to reboot"
reboot
