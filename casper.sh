#!/bin/bash
MYIP=$(curl -sS ipv4.icanhazip.com)
REPO="https://raw.githubusercontent.com/YaddyKakkoii/casper/main/"
#wget ${REPO}domaincf.sh && chmod +x domaincf.sh && ./domaincf.sh
#wget https://raw.githubusercontent.com/YaddyKakkoii/casper/main/domaincf.sh && chmod +x domaincf.sh && ./domaincf.sh
#wget https://raw.githubusercontent.com/YaddyKakkoii/casper/main/tools.sh && chmod +x tools.sh && ./tools.sh
#wget https://raw.githubusercontent.com/YaddyKakkoii/casper/main/ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
#wget https://raw.githubusercontent.com/YaddyKakkoii/casper/main/udp-custom.sh && chmod +x udp-custom.sh && ./udp-custom.sh 2200
#Decrypted By YADDY D PHREAKER
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
stty erase ^?
source '/etc/os-release'
cd "$(
cd "$(dirname "$0")" || exit
pwd
)" || exit
#https://github.com/YaddyKakkoii/casper
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
sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
mkdir -p /var/lib/ >/dev/null 2>&1
echo "IP=" >> /var/lib/ipvps.conf
clear
echo -e  "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e  "${tyblue}│              INPUT YOUR NAME             │${NC}"
echo -e  "${tyblue}└──────────────────────────────────────────┘${NC}"
echo " "
    until [[ $name =~ ^[a-zA-Z0-9_.-]+$ ]]; do
        read -rp "Masukan Nama Kamu Disini tanpa spasi : " -e name
    done
rm -rf /etc/profil
echo "$name" > /etc/profil
echo ""
clear
author=$(cat /etc/profil)
echo ""
echo ""
function memek(){
#wget ${REPO}tools.sh &> /dev/null && bash tools.sh && clear
wget ${REPO}domaincf.sh && chmod +x domaincf.sh && ./domaincf.sh && rm domaincf.sh
wget ${REPO}addtema.sh && chmod +x addtema.sh && ./addtema.sh && rm addtema.sh
wget ${REPO}tools.sh && chmod +x tools.sh && ./tools.sh && rm tools.sh
}
function pink(){
fun_bar() {
CMD[0]="$1"
CMD[1]="$2"
(
[[ -e $HOME/fim ]] && rm $HOME/fim
${CMD[0]} -y >/dev/null 2>&1
${CMD[1]} -y >/dev/null 2>&1
touch $HOME/fim
) >/dev/null 2>&1 &
tput civis
echo -ne "  \033[0;33mLagi Menginstal File \033[1;37m- \033[0;33m["
while true; do
for ((i = 0; i < 18; i++)); do
echo -ne "\033[0;32m#"
sleep 0.1s
done
[[ -e $HOME/fim ]] && rm $HOME/fim && break
echo -e "\033[0;33m]"
sleep 1s
tput cuu1
tput dl1
echo -ne "  \033[0;33mLagi Menginstal File \033[1;37m- \033[0;33m["
done
echo -e "\033[0;33m]\033[1;37m -\033[1;32m Succes !\033[1;37m"
tput cnorm
}
res2() {
wget ${REPO}ssh-vpn.sh && chmod +x ssh-vpn.sh && ./ssh-vpn.sh
clear
}
res3() {
wget ${REPO}ins-xray.sh && chmod +x ins-xray.sh && ./ins-xray.sh
curl -s ipinfo.io/city?token=75082b4831f909 > /etc/xray/city
curl -s ipinfo.io/org?token=75082b4831f909  | cut -d " " -f 2-10 > /etc/xray/isp
clear
}
res4() {
wget ${REPO}insshws.sh && chmod +x insshws.sh && ./insshws.sh
clear
}
res5() {
wget ${REPO}set-br.sh && chmod +x set-br.sh && ./set-br.sh
clear
}
res6() {
wget ${REPO}ohp.sh && chmod +x ohp.sh && ./ohp.sh
clear
}
res7() {
clear
mkdir /root/menu
cd /root/menu
wget ${REPO}menu.zip
#7z e -phehe1 menu.zip &> /dev/null
unzip menu.zip
chmod +x *
mv -f * /usr/bin
rm -rf /root/menu
cd /root
clear
}
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│      PROCESS INSTALLED SSH ALL IN ONE    │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
fun_bar 'res2'
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│           PROCESS INSTALLED XRAY         │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
fun_bar 'res3'
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│       PROCESS INSTALLED WEBSOCKET SSH    │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
fun_bar 'res4'
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│       PROCESS INSTALLED BACKUP MENU      │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
fun_bar 'res5'
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│           PROCESS INSTALLED OHP          │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
fun_bar 'res6'
echo -e "${tyblue}┌──────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│           DOWNLOAD FILE MENU             │${NC}"
echo -e "${tyblue}└──────────────────────────────────────────┘${NC}"
cat> /root/.profile << END
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
fun_bar 'res7'
cd /root
}
function wangy(){
domain=$(cat /etc/xray/domain)
TIMES="10"
#KEY="6129559221:AAGAkfVQqdi_So98HmZ6edqKovj-I-ldFQQ"
KEY2="6093232802:AAFULABHNHz8pW6tT1ApFACFHiXZMixkeSA"
KEY="6203209250:AAG7GoBbaUqo2qh4N-IGvScNisDWTHfLh8M"
CHATID="1117211252"
CHATID2="1117211252"
#CHATID="-1001319592446"
#KEY="6084073663:AAHdbteum38_25MavUHrZb_bt-NbZul9mvE"
URL="https://api.telegram.org/bot$KEY/sendMessage"
#CHATID2="-1001622671335"
#KEY2="5577483045:AAHgg4g4qgmjwmPOzsIPlbLXk_nAp5ClxhA"
URL2="https://api.telegram.org/bot$KEY2/sendMessage"
ISP=$(cat /etc/xray/isp)
CITY=$(cat /etc/xray/city)
domain=$(cat /etc/xray/domain)
TIME=$(date +'%Y-%m-%d %H:%M:%S')
RAMMS=$(free -m | awk 'NR==2 {print $2}')
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
MYIP=$(curl -sS ipv4.icanhazip.com)
today=$(date -d "0 days" +"%Y-%m-%d")
IZIN=$(curl -sS https://raw.githubusercontent.com/casper9/permission/main/ipmini | grep $MYIP | awk '{print $3}' )
REGIST=$(curl -sS https://raw.githubusercontent.com/casper9/permission/main/ipmini | wc -l )
d1=$(date -d "$IZIN" +%s)
d2=$(date -d "$today" +%s)
EXP=$(( (d1 - d2) / 86400 ))
TEXT="
<code>◇━━━━━━━━━━━━━━◇</code>
<code>⚠️ AUTOSCRIPT PREMIUM</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>NAME : </code><code>${author}</code>
<code>TIME : </code><code>${TIME} WIB</code>
<code>DOMAIN : </code><code>${domain}</code>
<code>IP : </code><code>${MYIP}</code>
<code>ISP : </code><code>${ISP}</code>
<code>CITY : </code><code>${CITY}</code>
<code>OS LINUX : </code><code>${MODEL2}</code>
<code>RAM : </code><code>${RAMMS} MB</code>
<code>EXP SCRIPT : </code><code>$IZIN ($EXP Days)</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Automatic Notification From Installer Client...</i>
"'&reply_markup={"inline_keyboard":[[{"text":"🔥ʟɪsᴛ ᴏʀᴅᴇʀ","url":"https://api.whatsapp.com/send?phone=6281383460513&text=Assalamualaikum%20Mass%20Ganteng"},{"text":"⚡ᴀᴅᴍɪɴ","url":"https://t.me/Crystalllz"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
TEXT2="
<code>◇━━━━━━━━━━━━━━◇</code>
<code>⚠️ AUTOSCRIPT PREMIUM</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<code>NAME : </code><code>${author}</code>
<code>TIME : </code><code>${TIME} WIB</code>
<code>DOMAIN : </code><code>${domain}</code>
<code>IP : </code><code>${MYIP}</code>
<code>ISP : </code><code>${ISP}</code>
<code>CITY : </code><code>${CITY}</code>
<code>OS LINUX : </code><code>${MODEL2}</code>
<code>RAM : </code><code>${RAMMS} MB</code>
<code>EXP SCRIPT : </code><code>$IZIN ($EXP Days)</code>
<code>◇━━━━━━━━━━━━━━◇</code>
<i>Automatic Notification From Installer Client...</i>
"'&reply_markup={"inline_keyboard":[[{"text":"🔥ʟɪsᴛ ᴏʀᴅᴇʀ","url":"https://api.whatsapp.com/send?phone=6281383460513&text=Assalamualaikum%20Mass%20Ganteng"},{"text":"⚡ᴏʀᴅᴇʀ sᴄʀɪᴘᴛ","url":"https://t.me/Crystalllz"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID2&disable_web_page_preview=1&text=$TEXT2&parse_mode=html" $URL2 >/dev/null
clear

}
memek
pink
wangy
#rm -rf *
echo -e "${tyblue}┌────────────────────────────────────────────┐${NC}"
echo -e "${tyblue}│  Install SCRIPT SELESAI..                  │${NC}"
echo -e "${tyblue}└────────────────────────────────────────────┘${NC}"
echo  ""
clear
#rm -rf /usr/bin/setup
menu
