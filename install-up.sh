#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/yaddykakkoii/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')"                    
###########- END COLOR CODE -##########

echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Remove Old Script"
#rm /usr/bin/menu-bot
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/insshws.sh && chmod +x insshws.sh && ./insshws.sh && clear
rm insshws.sh
sleep 2
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Downloading New Script"

cd /root
mkdir -p binari
cd binari

wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/menu.zip
#unzip menu.zip && cd menu
unzip menu.zip
chmod +x *

mv -f * /usr/bin
cd /root

rm -rf binari
clear
sleep 2
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Download Changelog File"
wget -q -O /root/changelog.txt "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/changelog.txt" && chmod +x /root/changelog.txt
echo -e "$COLOR1│${NC}  $COLOR1[INFO]${NC} Read Changelog? ./root/changelog.txt"
sleep 2
serverV=4.5.0
echo $serverV > /opt/.ver
menu
