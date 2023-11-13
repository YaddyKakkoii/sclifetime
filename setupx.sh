#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
############YADDY KAKKOII MAGELANG#############
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }
cd /root
#System version number
    if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
    fi
    if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
    fi

localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
    if [[ "$hst" != "$dart" ]]; then
        echo "$localip $(hostname)" >> /etc/hosts
    fi
mkdir -p /etc/xray

secs_to_human() {
    echo "Installation time : $(( ${1} / 3600 )) hours $(( (${1} / 60) % 60 )) minute's $(( ${1} % 60 )) seconds"
}
start=$(date +%s)

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

echo -e "[ ${green}INFO${NC} ] Preparing the install file 🛠"
apt install git curl -y >/dev/null 2>&1
echo -e "[ ${green}INFO${NC} ] Alright good ... installation file is ready 📡"
sleep 2
echo -ne "[ ${green}INFO${NC} ] Check permission : success 😁"
sleep 3
mkdir -p /etc/yaddykakkoii
mkdir -p /etc/yaddykakkoii/theme
mkdir -p /var/lib/yaddykakkoii >/dev/null 2>&1
echo "IP=" >> /var/lib/yaddykakkoii/ipvps.conf

    if [ -f "/etc/xray/domain" ]; then
        echo ""
        echo -e "[ ${green}INFO${NC} ] Script Already Installed"
        echo -ne "[ ${yell}WARNING${NC} ] Do you want to install again ? (y/n)? "
        read answer
        if [ "$answer" == "${answer#[Yy]}" ] ;then
            rm setup.sh
            sleep 10
            exit 0
        else
            clear
        fi
    fi

echo ""
#wget -q http://install.yudhy.net/FILE/dependencies.sh;chmod +x dependencies.sh;./dependencies.sh
#rm dependencies.sh
function dependencies(){
clear
red='\e[1;31m'
green='\e[1;32m'
yell='\e[1;33m'
NC='\e[0m'
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

    if [[ -e /etc/debian_version ]]; then
	    source /etc/os-release
	    OS=$ID # debian or ubuntu
    elif [[ -e /etc/centos-release ]]; then
	    source /etc/os-release
	    OS=centos
    fi

echo "Tools install...!"
echo "Progress..."
sleep 2

apt update -y
apt update -y
apt dist-upgrade -y
apt install sudo -y
apt-get remove --purge ufw firewalld -y 
apt-get remove --purge exim4 -y 

apt install -y screen curl jq bzip2 gzip coreutils rsyslog iftop \
htop zip unzip net-tools sed gnupg gnupg1 \
bc sudo apt-transport-https build-essential dirmngr libxml-parser-perl neofetch screenfetch git lsof \
openssl openvpn easy-rsa fail2ban tmux \
stunnel4 vnstat squid3 \
dropbear  libsqlite3-dev \
socat cron bash-completion ntpdate xz-utils sudo apt-transport-https \
gnupg2 dnsutils lsb-release chrony

curl -sSL https://deb.nodesource.com/setup_16.x | bash - 
apt-get install nodejs -y

/etc/init.d/vnstat restart
wget -q https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc >/dev/null 2>&1 && make >/dev/null 2>&1 && make install >/dev/null 2>&1
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
rm -f /root/vnstat-2.6.tar.gz >/dev/null 2>&1
rm -rf /root/vnstat-2.6 >/dev/null 2>&1

apt install -y libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev xl2tpd pptpd

yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "Dependencies successfully installed..."
sleep 3
clear
}
dependencies
clear
function tambahdomain(){
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
apt install jq curl -y
function subdomainsshweb() {
#SUB=microsoft.azure
#DOMAIN=ganteng.tech DOMAIN=yaddykakkoii.my.id #DOMAIN=sshweb.tech
echo "DOMAIN UTAMA ADALAH sshweb.tech"
echo "~~~~~~ petunjuk tentang custom subdomain ~~~~~~~~~"
echo "JIKA KAMU INPUT KATA: test ,maka hasilnya adalah test.sshweb.tech"
echo "JIKA KAMU INPUT KATA: custom ,maka hasilnya adalah custom.sshweb.tech"
echo "JIKA KAMU INPUT KATA: ainzoverlord ,maka hasilnya adalah ainzoverlord.sshweb.tech"
echo "JIKA KAMU INPUT KATA: sg3 ,maka hasilnya adalah sg3.sshweb.tech"
echo "JIKA KAMU INPUT KATA: memekpink ,maka hasilnya adalah memekpink.sshweb.tech"
echo ""
read -rp "silakan INPUT custom subdomain kamu : " -e SUB
echo ""
MYIP=$(wget -qO- icanhazip.com);
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
DOMAIN=sshweb.tech
SUB_DOMAIN=${SUB}.${DOMAIN}
NS_DOMAIN=ns.${SUB_DOMAIN}
echo "DOMAIN kamu adalah : ${SUB_DOMAIN}"
sleep 3
echo "IP=${SUB_DOMAIN}" > /var/lib/yaddykakkoii/ipvps.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS RECORD (DomainNameSystem) for ${SUB_DOMAIN} "
sleep 2
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
    if [[ "${#RECORD}" -le 10 ]]; then
        RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" \
        --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
    fi
RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
# update nameserver mu
echo "Updating NS RECORD (NameServer) for ${NS_DOMAIN} "
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" | jq -r .result[0].id)
    if [[ "${#RECORD}" -le 10 ]]; then
        RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
        -H "X-Auth-Email: ${CF_ID}" \
        -H "X-Auth-Key: ${CF_KEY}" \
        -H "Content-Type: application/json" \
        --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
    fi
RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
    -H "X-Auth-Email: ${CF_ID}" \
    -H "X-Auth-Key: ${CF_KEY}" \
    -H "Content-Type: application/json" \
    --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}')
echo "DOMAIN KAMU : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/domain
echo "NAMESERVER KAMU : $NS_DOMAIN"
echo $NS_DOMAIN > /etc/xray/nsdomain
echo $NS_DOMAIN > /etc/xray/dns
sleep 3
cd
}

function randomsubdomain() {
#SUB=$(</dev/urandom tr -dc a-z0-9 | head -c5)
MYIP=$(wget -qO- icanhazip.com);
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
SUB=$(</dev/urandom tr -dc a-z0-9 | head -c3)
DOMAIN=yaddykakkoii.my.id
SUB_DOMAIN=tensai.${SUB}.${DOMAIN}
NS_DOMAIN=ns.${SUB_DOMAIN}
echo "DOMAIN kamu adalah : ${SUB_DOMAIN}"
sleep 3
echo "IP=${SUB_DOMAIN}" > /var/lib/yaddykakkoii/ipvps.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
# update domain vps mu
echo "Updating DNS RECORD (DomainNameSystem) for ${SUB_DOMAIN} "
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi
RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
# update nameserver mu
echo "Updating NS RECORD (NameServer) for ${NS_DOMAIN} "
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)
if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi
RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}')
echo "DOMAIN KAMU : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/domain
echo "NAMESERVER KAMU : $NS_DOMAIN"
echo $NS_DOMAIN > /etc/xray/nsdomain
sleep 3
cd
}

function cekdomain(){
clear
currentdomain=$(cat /etc/xray/domain)
    if [ -f "/etc/xray/domain" ]; then
        echo "Domainmu saat ini adalah ${currentdomain} "
    else
        echo "Belum ada domain terpasang di vps ini "
    fi
yellow "Add Domain for vmess/vless/trojan dll"
echo " "
echo -e "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
echo ""
echo "jika kamu sudah punya domain sendiri, pilih nomer 1"
echo "jika kamu mau nebeng domain ku ,secara custom , pilih nomer 2"
echo "jika ingin batal , skip , atau gak jadi pointing domain, pilih nomer 3"
echo "jika kamu mau nebeng domain ku ,dengan nama acak, pilih selain nomer 1 2 3 atau tekan enter"
echo ""
echo -e "   .----------------------------------."
echo -e "   |\e[1;32mPlease select a domain type below \e[0m|"
echo -e "   '----------------------------------'"
echo -e "     \e[1;32m1)\e[0m Enter your Subdomain"
echo -e "     \e[1;32m2)\e[0m Use a custom Subdomain"
echo -e "     \e[1;32m3)\e[0m Skip , Saya tidak ingin mengganti Subdomain yg sekarang"
echo -e "   ------------------------------------"
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""
    if [[ $host == "1" ]]; then
        read -rp "Input DOMAIN Kamu : " -e domainmu
        if [ -z ${domainmu} ]; then
            echo -e " Anda belum memasukkan domain! Then a random domain will be created"
            randomsubdomain
        else
	        echo "$domainmu" > /etc/xray/domain
            echo "IP=$domainmu" > /var/lib/yaddykakkoii/ipvps.conf
        fi
        clear
    elif [[ $host == "2" ]]; then
        subdomainsshweb
        clear
    elif [[ $host == "3" ]]; then
        echo " skipp gaess "
        clear
    else
        echo -e "Random Subdomain/Domain is used"
        sleep 3
        randomsubdomain
        clear
    fi
}
cekdomain
}
tambahdomain

function tambahtema(){

#THEME RED
cat <<EOF>> /etc/yaddykakkoii/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/yaddykakkoii/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/yaddykakkoii/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/yaddykakkoii/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/yaddykakkoii/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/yaddykakkoii/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/yaddykakkoii/theme/color.conf
blue
EOF
}
tambahtema
#wget http://install.yudhy.net/FILE/SSH/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
function sshvpn(){

export DEBIAN_FRONTEND=noninteractive
MYIP=$(wget -qO- ipinfo.io/ip);
MYIP2="s/xxxxxxxxx/$MYIP/g";
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID

#detail nama perusahaan
country=ID
state=Jawa-Tengah 
locality=Magelang
organization=YaddyKakkoii
organizationalunit=YaddyKakkoii
commonname=YaddyKakkoii
email=njajaldoang@gmail.com

# simple password minimal
wget -O /etc/pam.d/common-password "https://raw.githubusercontent.com/YaddyKakkoii/kentang/main/common-password" && chmod +x /etc/pam.d/common-password
#curl -sS http://install.yudhy.net/FILE/SSH/password | openssl aes-256-cbc -d -a -pass pass:scvps07gg -pbkdf2 > /etc/pam.d/common-password && chmod +x /etc/pam.d/common-password
cd

apt update -y
apt upgrade -y
apt dist-upgrade -y
apt-get remove --purge ufw firewalld -y
apt-get remove --purge exim4 -y

#install jq
apt -y install jq
apt -y install shc
apt -y install wget curl
apt-get install figlet -y
apt-get install ruby -y
gem install lolcat

# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config

function instalwebserver(){
source /etc/os-release
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    #purgedropbeardebian
                    apt -y install nginx
            else
                    #purgedropbearubuntu
                    apt-get -y install nginx
            fi
    else
        echo "ini vps Centos"
        OS=centos
        yum install -y nginx
        echo "ubah manual apt menjadi yum , contoh apt install squid menjadi yum install squid"
        echo "atau chat saya di telegram kalau kamu ga paham"
        echo "contact person t.me/Crystalllz"
        #exit
        sleep 3s
    fi
}
instalwebserver

cd
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf" && chmod 777 /etc/nginx/nginx.conf
rm /etc/nginx/conf.d/vps.conf
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf" && chmod 777 /etc/nginx/conf.d/vps.conf
/etc/init.d/nginx restart

mkdir /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf
systemctl daemon-reload
service nginx restart
cd
mkdir /home/vps
mkdir /home/vps/public_html
echo -e "[ ${green}INFO$NC ] Settings index"
sleep 1
rm -f /home/vps/public_html/index.html > /dev/null 2>&1
wget -O /home/vps/public_html/index.html "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/index.txt"
chmod 777 /home/vps/public_html/index.html
mkdir /home/vps/public_html/ss-ws
mkdir /home/vps/public_html/clash-ws

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

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

# install badvpn
cd
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

# setting port ssh
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g'
# /etc/ssh/sshd_config
sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config
/etc/init.d/ssh restart

echo "=== Install Dropbear ==="
# install dropbear
apt -y install dropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

# install squid
# hosnem=$(hostname)
cd
apt -y install squid3
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/squid3.conf" && chmod 777 /etc/squid/squid.conf
hosnem=( `hostname` )
sed -i $MYIP2 /etc/squid/squid.conf
sed -i "s/yaddykakkoiisugoiitensaii/$hosnem/g" /etc/squid/squid.conf

cd
# install stunnel
apt install stunnel4 -y
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

# make a certificate
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095 \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email"
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem

# konfigurasi stunnel
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
/etc/init.d/stunnel4 restart

#OpenVPN
#wget http://install.yudhy.net/FILE/OPENVPN/vpn.sh &&  chmod +x vpn.sh && ./vpn.sh
function vpnbiasa(){
# initialisasi var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(wget -qO- icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
ANU=$(ip -o $ANU -4 route show to default | awk '{print $5}');
domain=$(cat /etc/xray/domain)

# Install OpenVPN dan Easy-RSA
apt install openvpn easy-rsa unzip -y
apt install openssl iptables iptables-persistent -y
mkdir -p /etc/openvpn/server/easy-rsa/
cd /etc/openvpn/

wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vpn.zip
#wget http://install.yudhy.net/FILE/OPENVPN/vpn.zip
unzip vpn.zip
rm -f vpn.zip
chown -R root:root /etc/openvpn/server/easy-rsa/

cd
mkdir -p /usr/lib/openvpn/
cp /usr/lib/x86_64-linux-gnu/openvpn/plugins/openvpn-plugin-auth-pam.so /usr/lib/openvpn/openvpn-plugin-auth-pam.so

# nano /etc/default/openvpn
sed -i 's/#AUTOSTART="all"/AUTOSTART="all"/g' /etc/default/openvpn

# restart openvpn dan cek status openvpn
systemctl enable --now openvpn-server@server-tcp-1194
systemctl enable --now openvpn-server@server-udp-2200
/etc/init.d/openvpn restart
/etc/init.d/openvpn status

# aktifkan ip4 forwarding
echo 1 > /proc/sys/net/ipv4/ip_forward
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf

# Buat config client TCP 1194
cat > /etc/openvpn/client-tcp-1194.ovpn <<-END
############## WELCOME ###############
############# By YaddyTampan ##############
client
dev tun
proto tcp
setenv CLIENT_CERT 0
remote $domain 1194
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

setenv FRIENDLY_NAME "Ovpn Tcp"
http-proxy xxxxxxxxx 3128
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host bug.com
http-proxy-option CUSTOM-HEADER X-Online-Host bug.com
http-proxy-option CUSTOM-HEADER X-Forward-Host bug.com
http-proxy-option CUSTOM-HEADER Connection: keep-alive
END

sed -i $MYIP2 /etc/openvpn/client-tcp-1194.ovpn;

# Buat config client UDP 2200
cat > /etc/openvpn/client-udp-2200.ovpn <<-END
############## WELCOME ###############
############# By YaddyKakkoii ##############
client
dev tun
proto udp
setenv CLIENT_CERT 0
remote $domain 2200
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
setenv FRIENDLY_NAME "Ovpn Udp"
END

sed -i $MYIP2 /etc/openvpn/client-udp-2200.ovpn;

# Buat config client SSL
cat > /etc/openvpn/client-tcp-ssl.ovpn <<-END
############## WELCOME ###############
############# By Yaddy Kakkoii ##############
client
dev tun
proto tcp
setenv CLIENT_CERT 0
remote $domain 110
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3
END

sed -i $MYIP2 /etc/openvpn/client-tcp-ssl.ovpn;

cd
# pada tulisan xxx ganti dengan alamat ip address VPS anda 
/etc/init.d/openvpn restart

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/client-tcp-1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-1194.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( TCP 1194 )
cp /etc/openvpn/client-tcp-1194.ovpn /home/vps/public_html/client-tcp-1194.ovpn

# masukkan certificatenya ke dalam config client UDP 2200
echo '<ca>' >> /etc/openvpn/client-udp-2200.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-udp-2200.ovpn
echo '</ca>' >> /etc/openvpn/client-udp-2200.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( UDP 2200 )
cp /etc/openvpn/client-udp-2200.ovpn /home/vps/public_html/client-udp-2200.ovpn

# masukkan certificatenya ke dalam config client SSL
echo '<ca>' >> /etc/openvpn/client-tcp-ssl.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ssl.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ssl.ovpn

# Copy config OpenVPN client ke home directory root agar mudah didownload ( SSL )
cp /etc/openvpn/client-tcp-ssl.ovpn /home/vps/public_html/client-tcp-ssl.ovpn

#firewall untuk memperbolehkan akses UDP dan akses jalur TCP

iptables -t nat -I POSTROUTING -s 10.6.0.0/24 -o $ANU -j MASQUERADE
iptables -t nat -I POSTROUTING -s 10.7.0.0/24 -o $ANU -j MASQUERADE
iptables-save > /etc/iptables.up.rules
chmod +x /etc/iptables.up.rules

iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# Restart service openvpn
systemctl enable openvpn
systemctl start openvpn
/etc/init.d/openvpn restart

# Delete script
history -c
#rm -f /root/vpn.sh
}
vpnbiasa

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

wget -qO /usr/bin/clearlog "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/clearlog.sh" && chmod 777 /usr/bin/clearlog
echo "*/25 * * * * root clearlog" >> /etc/crontab
}
#blokirtorrent

rm /etc/issue.net > /dev/null 2>&1
echo -e "[ ${green}INFO$NC ] Settings banner"
sleep 1
wget -q -O /etc/issue.net "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/issue.net" && chmod 777 /etc/issue.net
#service dropbear restart
echo "Banner /etc/issue.net" >> /etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear

cat > /etc/cron.d/re_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 7 * * * root /sbin/reboot
END

cat > /etc/cron.d/xp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/bin/xp
END

cat > /home/re_otm <<-END
7
END


# remove unnecessary files
sleep 1
echo -e "[ ${green}INFO$NC ] Clearing trash"
apt autoclean -y >/dev/null 2>&1

    if dpkg -s unscd >/dev/null 2>&1; then
        apt -y remove --purge unscd >/dev/null 2>&1
    fi

function bersihbersih(){
source /etc/os-release
    if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    echo -e "[ ${green}INFO$NC ] Clearing trash"
                    apt autoclean -y >/dev/null 2>&1
                    if dpkg -s unscd >/dev/null 2>&1; then
                        apt -y remove --purge unscd >/dev/null 2>&1
                    fi
                    apt -y --purge remove samba* >/dev/null 2>&1
                    apt -y --purge remove apache2* >/dev/null 2>&1
                    apt -y --purge remove bind9* >/dev/null 2>&1
                    apt -y remove sendmail* >/dev/null 2>&1
                    apt autoremove -y >/dev/null 2>&1
            else
                    echo -e "[ ${green}INFO$NC ] Clearing trash"
                    apt-get autoclean -y >/dev/null 2>&1
                    if dpkg -s unscd >/dev/null 2>&1; then
                        apt-get -y remove --purge unscd >/dev/null 2>&1
                    fi
                    apt-get -y --purge remove samba* >/dev/null 2>&1
                    apt-get -y --purge remove apache2* >/dev/null 2>&1
                    apt-get -y --purge remove bind9* >/dev/null 2>&1
                    apt-get -y remove sendmail* >/dev/null 2>&1
                    apt-get autoremove -y >/dev/null 2>&1
            fi
    else
        echo "ini vps Centos"
        OS=centos
        echo -e "[ ${green}INFO$NC ] Clearing trash"
        yum autoclean -y >/dev/null 2>&1
        echo "ubah manual apt menjadi yum , contoh apt install squid menjadi yum install squid"
        echo "atau chat saya di telegram kalau kamu ga paham"
        echo "contact person t.me/Crystalllz"
        #exit
        sleep 3s
    fi
}
bersihbersih
cd
chown -R www-data:www-data /home/vps/public_html
sleep 1
echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"

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

rm -f /root/key.pem
rm -f /root/cert.pem
#rm -f /root/ssh-vpn.sh

clear
}
sshvpn

sleep 2
clear
#wget http://install.yudhy.net/FILE/XRAY/ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
function instalxray(){

dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
############YaddyKakkoii#############
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
echo "Install XRAY Core Vmess / Vless/ Trojan"
echo "Suport Multi Path"
sleep 2
echo "Progress......"
sleep 3

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

# Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
# Installation Xray Core
# $latest_version
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v1.7.5/xray-linux-64.zip"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version

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
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)
# xray config
cat > /etc/xray/yudhy-dm-config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10000,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "10001",
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
                "path": "/vlessws"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "10002",
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
      "port": "10003",
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
               "path": "/yudhynet"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "10004",
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
        "port": "10005",
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
      "port": "10006",
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
        "port": "10007",
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
    "port": "10008",
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
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
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
Description=Xray
After=network.target

[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

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
        # YaddyKakkoii
        # Important:
        # yudhy.net

        }
EOF
sed -i '$ i# SERVER LISTEN XRAY' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vless Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location /vlessws {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vlessws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:10001;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vmess Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location / {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   if ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   rewrite /(.*) /vmess break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:10002;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Trojan Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ ilocation /yudhynet {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /yudhynet break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:10003;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # This is the proxy Xray For SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   location /ss-ws {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   if ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   rewrite /(.*) /ss-ws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:10004;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Setting Server gRPC' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC VL Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_pass grpc://127.0.0.1:10005;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC VM Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:10006;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC TR Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                          grpc_pass grpc://127.0.0.1:10007;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:10008;' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ i      # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i      # This is the proxy Xray For SSH Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location /DM {' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   # Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ i                   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf

mv -f /etc/nginx/conf.d/xray.conf /etc/nginx/conf.d/yudhy-dm-xray.conf

uuidd=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)


wget -qO /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xray.conf"
chmod 777 /etc/nginx/conf.d/xray.conf
sed -i "s/yaddyganteng/${domainn}/g" /etc/nginx/conf.d/xray.conf
sed -i "s/trojan-ws/yaddyganteng/g" /etc/nginx/conf.d/xray.conf
wget -qO /etc/xray/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/config.json.txt"
chmod 777 /etc/xray/config.json
sed -i "s/yaddytampan/${uuidd}/g" /etc/xray/config.json
sed -i "s/trojan-ws/yaddyganteng/g" /etc/xray/config.json

sleep 1
echo -e "[ ${green}INFO$NC ] Installing bbr.."
wget -q -O /usr/bin/bbr "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1
#rm -f /root/bbr.sh
echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn

sleep 1

#rm -f ins-xray.sh  

}
instalxray
#Install SSH Websocket
sleep 2
clear
#wget http://install.yudhy.net/FILE/WEBSOCKET/insshws.sh && chmod +x insshws.sh && ./insshws.sh
function instalsshwebsocket(){
#hapus pagar saat reinstall // uncomment cokk jancokk
setopserviswebsoket(){
systemctl stop sshws.service
tmux kill-session -t sshws
systemctl stop ws-dropbear.service
systemctl stop ws-stunnel.service
systemctl stop ws-openssh.service
rm -f /etc/systemd/system/sshws.service
rm -f /usr/bin/ssh-wsenabler
rm -f /usr/local/bin/ws-dropbear
rm -f /usr/local/bin/ws-stunnel
rm -f /usr/local/bin/ws-openssh
rm -f /etc/systemd/system/ws-dropbear.service
rm -f /etc/systemd/system/ws-stunnel.service
rm -f /etc/systemd/system/ws-openssh.service
rm -f /usr/bin/proxy3.js
}
#setopserviswebsoket
cd
wget -qO /usr/bin/ssh-wsenabler "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ssh-wsenabler"
wget -qO /usr/bin/proxy3.js "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/proxy3.js"
wget -qO /usr/local/bin/ws-dropbear "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-dropbear"
wget -qO /usr/local/bin/ws-stunnel "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-stunnel"
wget -qO /usr/local/bin/ws-openssh "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-openssh"
wget -qO /etc/systemd/system/ws-dropbear.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-dropbear.service"
wget -qO /etc/systemd/system/ws-stunnel.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-stunnel.service"
wget -qO /etc/systemd/system/ws-openssh.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-openssh.service"
sleep 1
chmod +x /usr/bin/ssh-wsenabler
chmod +x /usr/bin/proxy3.js
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel
chmod +x /usr/local/bin/ws-openssh
chmod +x /etc/systemd/system/ws-dropbear.service
chmod +x /etc/systemd/system/ws-stunnel.service
chmod +x /etc/systemd/system/ws-openssh.service
sleep 1
systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
systemctl enable ws-openssh.service
systemctl start ws-openssh.service
systemctl restart ws-openssh.service
cat <<EOF > /etc/systemd/system/sshws.service
[Unit]
Description=WSenabler
Documentation=By YaddyKakkoii

[Service]
Type=simple
ExecStart=/usr/bin/ssh-wsenabler
KillMode=process
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
chmod +x /etc/systemd/system/sshws.service
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sshws.service >/dev/null 2>&1
systemctl start sshws.service >/dev/null 2>&1
systemctl restart sshws.service >/dev/null 2>&1
service sshws restart
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "SSH WEBSOCKET TELAH AKTIF...!!"
echo -e "$COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}]${NC} ${COLOR1}•${NC} ${green}SSH Websocket Started${NC}"
echo -e "$COLOR1┌────────────────────── ${WH}BY${NC} ${COLOR1}───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• YADDY KAKKOII MAGELANG •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"

#RESPONSE = 'HTTP/1.1 101 WebSocket <font color="lime">Yaddy Kakkoii </font><font color="yellow">Tampan </font><font color="red">Maksimal</font>\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: foo\r\n\r\n'
#RESPONSE = 'HTTP/1.1 101 WebSocket <font color="lime">Yaddy Kakkoii </font><font color="yellow">Tampan </font><font color="red">Maksimal</font>\r\nContent-Length: 104857600000\r\n\r\n'

}
instalsshwebsocket
#Install OHP Websocket
sleep 2
clear
#wget http://install.yudhy.net/FILE/OPENVPN/ohp.sh && chmod +x ohp.sh && ./ohp.sh
function instalohp(){

#Open HTTP Puncher
#Direct Proxy Squid For OpenVPN TCP
RED='\e[1;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
NC='\e[0m'
MYIP=$(wget -qO- https://icanhazip.com);
MYIP2="s/xxxxxxxxx/$MYIP/g";
domain=$(cat /etc/xray/domain)
#Update Repository VPS
clear
apt update 
apt-get -y upgrade

#Port Server ovpn ohp
#Jika Ingiin Mengubah Port Silahkan Sesuaikan Dengan Port Yang Ada Di VPS Mu
Port_OpenVPN_TCP='1194';
Port_Squid='3128';
Port_OHP='8787';

#Installing ohp Server
wget -qO /usr/local/bin/ohp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ohp" && chmod 777 /usr/local/bin/ohp

#Buat File OpenVPN TCP OHP
cat > /etc/openvpn/client-tcp-ohp1194.ovpn <<END
############## WELCOME ###############
############# By Yaddykakkoii Magelang ##############
client
dev tun
proto tcp
remote "bug.com" 1194
resolv-retry infinite
route-method exe
nobind
remote-cert-tls server
cipher AES-256-CBC
auth SHA256
persist-key
persist-tun
auth-user-pass
comp-lzo
verb 3

setenv FRIENDLY_NAME "TCP OHP VPN"
http-proxy ${domain} 8787
http-proxy-option CUSTOM-HEADER CONNECT HTTP/1.1
http-proxy-option CUSTOM-HEADER Host bug.com
http-proxy-option CUSTOM-HEADER X-Online-Host bug.com
http-proxy-option CUSTOM-HEADER X-Forward-Host bug.com
http-proxy-option CUSTOM-HEADER Connection: keep-alive
END

sed -i $MYIP2 /etc/openvpn/client-tcp-ohp1194.ovpn;

# masukkan certificatenya ke dalam config client TCP 1194
echo '<ca>' >> /etc/openvpn/client-tcp-ohp1194.ovpn
cat /etc/openvpn/server/ca.crt >> /etc/openvpn/client-tcp-ohp1194.ovpn
echo '</ca>' >> /etc/openvpn/client-tcp-ohp1194.ovpn
cp /etc/openvpn/client-tcp-ohp1194.ovpn /home/vps/public_html/client-tcp-ohp1194.ovpn
clear
cd 

#Buat Service Untuk OHP Ovpn
cat > /etc/systemd/system/ohp.service <<END
[Unit]
Description=Direct Squid Proxy For OpenVPN TCP By Yaddy Kakkoii
Documentation=https://t.me/Crystalllz
Wants=network.target
After=network.target

[Service]
ExecStart=/usr/local/bin/ohp -port 8787 -proxy 127.0.0.1:3128 -tunnel 127.0.0.1:1194
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
END

systemctl daemon-reload
systemctl enable ohp
systemctl restart ohp
echo ""
echo -e "${GREEN}Done Installing OHP Server${NC}"
echo -e "Port OVPN OHP TCP: $Port_OHP"
echo -e "Link Download OVPN OHP: http://$MYIP:81/client-tcp-ohp1194.ovpn"
echo -e "Yaddy Kakkoii Magelang"
}
instalohp
#Install AutoBackup
sleep 2
clear
#wget http://install.yudhy.net/backup/set-br.sh && chmod +x set-br.sh && ./set-br.sh
function instalautobackup(){

RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
MYIP=$(wget -qO- ipinfo.io/ip);
curl https://rclone.org/install.sh | bash
apt install rclone -y
printf "q\n" | rclone config
wget -qO /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/rclone.conf"
chmod 777 /root/.config/rclone/rclone.conf
cd /bin
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user backupsmtp93@gmail.com
from backupsmtp93@gmail.com
password sdallofkbpuhbtoa 
logfile ~/.msmtp.log

EOF
chown -R www-data:www-data /etc/msmtprc
wget -O /usr/bin/autobackup "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/autobackup.sh" && chmod +x /usr/bin/autobackup;autobackup > /dev/null 2>&1
cd
#remove file sampah
rm -f $PREFIX/bin/autobackup
#rm -f /root/set-br.sh

}
instalautobackup
#Download Extra Menu

sleep 2
#wget http://install.yudhy.net/FILE/MENU/update.sh && chmod +x update.sh && ./update.sh
wget -q -O /usr/bin/menu "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu.sh" && chmod +x /usr/bin/menu
wget -q -O /usr/bin/menu-trojan "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu-trojan.sh" && chmod +x /usr/bin/menu-trojan

sed -i "s/yudhynetwork-pro/yaddykakkoii/g" /usr/bin/menu-trojan
sed -i "s/yudhynetwork/yaddykakkoii/g" /usr/bin/menu-trojan
sed -i "s/yudhynet/yaddyganteng/g" /usr/bin/menu-trojan
sed -i "s/tema/theme/g" /usr/bin/menu

rm -f /usr/bin/xrayfix && rm -f /usr/bin/fixdb  > /dev/null 2>&1
rm -f /usr/bin/purgenginx >/dev/null 2>&1 && rm -f /usr/bin/xraydbfix >/dev/null 2>&1
rm -f /usr/bin/menuudp >/dev/null 2>&1 && rm -f /usr/bin/sshwsfix >/dev/null 2>&1
rm -f /usr/bin/menuslowdns >/dev/null 2>&1 && rm -f /usr/bin/updatesshws >/dev/null 2>&1
wget -q -O /usr/bin/xrayfix "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xrayfix.sh"
chmod +x /usr/bin/xrayfix
wget -q -O /usr/bin/fixdb "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fixdb.sh"
chmod +x /usr/bin/fixdb
wget -q -O /usr/bin/gantidomain "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/gantidomain.sh" && chmod +x /usr/bin/gantidomain.sh
wget -q -O /usr/bin/apete "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/apete.sh" && chmod +x /usr/bin/apete;apete > /dev/null 2>&1
wget -q -O /usr/bin/menuslowdns "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/menuslowdns.sh" && chmod +x /usr/bin/menuslowdns
wget -q -O /usr/bin/menuudp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/menuudp.sh" && chmod +x /usr/bin/menuudp
wget -q -O /usr/bin/gantidomain "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/gantidomain.sh" && chmod +x /usr/bin/gantidomain
wget -q -O /usr/bin/purgenginx "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/purgenginx.sh" && chmod +x /usr/bin/purgenginx
wget -q -O /usr/bin/updatesshws "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/updatesshws.sh" && chmod +x /usr/bin/updatesshws
wget -q -O /usr/bin/sshwsfix "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/sshwsfix.sh" && chmod +x /usr/bin/sshwsfix
wget -q -O /usr/bin/xraydbfix "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/fix/xraydbfix.sh" && chmod +x /usr/bin/xraydbfix

wget -q -O /usr/bin/auto-set "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/auto-set.sh" && chmod +x /usr/bin/auto-set
wget -q -O /usr/bin/crtxray "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/crt.sh" && chmod +x /usr/bin/crtxray

cd /usr/bin
wget -O speedtest "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/speedtest_cli.py"
wget -O xp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xp.sh"

chmod +x speedtest
chmod +x xp
cd


clear
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
serverV=$( curl -sS http://install.yudhy.net/FILE/version  )
echo $serverV > /opt/.ver
aureb=$(cat /home/re_otm)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
curl -sS ifconfig.me > /etc/myipvps

echo " "
echo "Installation has been completed!!"
echo " "
echo "=========================[SCRIPT PREMIUM]========================"
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI SSH ]" | tee -a log-install.txt
echo "    -------------------------" | tee -a log-install.txt
echo "   - OpenSSH                 : 22"  | tee -a log-install.txt
echo "   - Stunnel4                : 447, 777"  | tee -a log-install.txt
echo "   - Dropbear                : 109, 143"  | tee -a log-install.txt
echo "   - SSH Websocket           : 80"  | tee -a log-install.txt
echo "   - SSH SSL Websocket       : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI  Badvpn, Nginx]" | tee -a log-install.txt
echo "    ---------------------------" | tee -a log-install.txt
echo "   - Badvpn                  : 7100-7900"  | tee -a log-install.txt
echo "   - Nginx                   : 81"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI Shadowsocks-R & Shadowsocks]"  | tee -a log-install.txt
echo "    ---------------------------------------" | tee -a log-install.txt
echo "   - Websocket Shadowsocks   : 443"  | tee -a log-install.txt
echo "   - Shadowsocks GRPC        : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI XRAY]"  | tee -a log-install.txt
echo "    ----------------" | tee -a log-install.txt
echo "   - Xray Vmess Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vless Ws Tls       : 443"  | tee -a log-install.txt
echo "   - Xray Vmess Ws None Tls  : 80"  | tee -a log-install.txt
echo "   - Xray Vless Ws None Tls  : 80"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "    [INFORMASI TROJAN]"  | tee -a log-install.txt
echo "    ------------------" | tee -a log-install.txt
echo "   - Websocket Trojan        : 443"  | tee -a log-install.txt
echo "   - Trojan GRPC             : 443"  | tee -a log-install.txt
echo "   --------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Auto Reboot On           : $aureb:00 $gg GMT +7" | tee -a log-install.txt
echo "   - Custom Path " | tee -a log-install.txt
echo "   - Auto Backup Data" | tee -a log-install.txt
echo "   - AutoKill Multi Login User" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Fully Automatic Script" | tee -a log-install.txt
echo "   - VPS Settings" | tee -a log-install.txt
echo "   - Admin Control" | tee -a log-install.txt
echo "   - Backup & Restore Data" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "=========================[SCRIPT PREMIUM]========================"
echo ""
sleep 3
echo -e "    ${tyblue}.------------------------------------------.${NC}"
echo -e "    ${tyblue}|     SUCCESFULLY INSTALLED THE SCRIPT     |${NC}"
echo -e "    ${tyblue}'------------------------------------------'${NC}"
echo ""
echo -e "   ${tyblue}Your VPS Will Be Automatical Reboot In 10 seconds${NC}"
rm /root/cf.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/insshws.sh > /dev/null 2>&1
rm /root/update.sh > /dev/null 2>&1
#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
tyblue='\e[1;36m'
domain=$(cat /etc/xray/domain)
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
function yaddykakkoii(){
echo ""
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              \033[1;37mTERIMA KASIH                ${tyblue}│${NC}"
echo -e  "${tyblue}│         \033[1;37mSUDAH MENGGUNAKAN SCRIPT         ${tyblue}│${NC}"
echo -e  "${tyblue}│                \033[1;37mDARI YADDY TAMPAN                 ${tyblue}│${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
}
function purgenginxnow() {
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
}
function nginx_installx() {
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
        print_ok "$1 Complete... | thx to ${YELLOW}yaddykakkoii${FONT}"
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
function nginx_install() {
    # // Checking System
    if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
        print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        # // sudo add-apt-repository ppa:nginx/stable -y 
        sudo add-apt-repository ppa:nginx/stable -y
        sudo apt-get install nginx -y
    elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
        print_success "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
        apt -y install nginx
    else
        echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
        exit 1
    fi
}
function fixxx(){
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf_bak > /dev/null 2>&1
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf"
chmod 777 /etc/nginx/nginx.conf
mkdir -p /etc/systemd/system/nginx.service.d
printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
rm /etc/nginx/conf.d/default.conf > /dev/null 2>&1
    sleep 0.5
    Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
    if [[ ! -z "$Cek" ]]; then
        sleep 1
        echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
        systemctl daemon-reload
        systemctl stop nginx
        systemctl stop udpcore > /dev/null 2>&1
        systemctl stop udp-custom > /dev/null 2>&1
        systemctl stop $Cek
        sleep 1
        echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
        sleep 2
    fi
uuid=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
rm -f /etc/nginx/conf.d/vps.conf
#wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf"
#chmod 777 /etc/nginx/conf.d/vps.conf

rm -f /etc/nginx/conf.d/xray.conf
rm -f /etc/xray/config.json

#cp -f /tmp/xray.conf /etc/nginx/conf.d/xray.conf
#cp -f /tmp/config.json /etc/xray/config.json
#chmod 777 /etc/nginx/conf.d/xray.conf
#chmod 777 /etc/xray/config.json

updateconfiglagi(){
uuid=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
wget -O /etc/xray/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/config.json.txt"
chmod 777 /etc/xray/config.json
sed -i "s/yaddytampan/${uuid}/g" /etc/xray/config.json

wget -qO /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf"
chmod 777 /etc/nginx/conf.d/vps.conf
wget -qO /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xray.conf"
chmod 777 /etc/nginx/conf.d/xray.conf
sed -i "s/yaddyganteng/${domainn}/g" /etc/nginx/conf.d/xray.conf
sed -i "s/trojan-ws/yaddyganteng/g" /etc/nginx/conf.d/xray.conf
wget -qO /etc/xray/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/config.json.txt"
chmod 777 /etc/xray/config.json
sed -i "s/yaddytampan/${uuid}/g" /etc/xray/config.json
sed -i "s/trojan-ws/yaddyganteng/g" /etc/xray/config.json
}
updateconfiglagi

rm -fr /etc/systemd/system/runn.service
rm -fr /etc/systemd/system/xray.service
rm -fr /etc/systemd/system/xray.service.d
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
Description=Xray
After=network.target

[Service]
Type=simple
ExecStartPre=-/usr/bin/mkdir -p /var/run/xray
ExecStart=/usr/bin/chown www-data:www-data /var/run/xray
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
sleep 2
systemctl daemon-reload
systemctl restart $Cek
echo -e "[ ${green}ok${NC} ] Restarting nginx"
systemctl restart nginx
#systemctl restart udpcore

auto-set
systemctl restart xray
systemctl enable runn
systemctl start runn
systemctl restart runn

echo -e "[ ${green}INFO${NC} ] All finished... " 
sleep 0.5
echo ""
echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
/etc/init.d/nginx status
sleep 3
yaddykakkoii
sleep 6
#mv /usr/local/sbin/menu /usr/local/sbin/menu_bakk
#mv -f /usr/bin/menu /usr/local/sbin/menu
menu
}
purgenginxnow
#nginx_installx
nginx_install
fixxx
