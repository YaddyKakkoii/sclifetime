#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- MZ YADDY GANTENG-#########
    if [ -f "/usr/bin/mpstat" ]; then
        clear
    else
        apt install sysstat
    fi
tomem="$(free | awk '{print $2}' | head -2 | tail -n 1 )"
usmem="$(free | awk '{print $3}' | head -2 | tail -n 1 )"
cpu1="$(mpstat | awk '{print $4}' | head -4 |tail -n 1)"
cpu2="$(mpstat | awk '{print $6}' | head -4 |tail -n 1)"
persenmemori="$(echo "scale=2; $usmem*100/$tomem" | bc)"
persencpu="$(echo "scale=2; $cpu1+$cpu2" | bc)"
vlx=$(grep -c -E "^#& " "/etc/xray/config.json")
let jumlahakunvless=$vlx/2
vmc=$(grep -c -E "^### " "/etc/xray/config.json")
let jumlahakunvmess=$vmc/2
jumlahakunssh="$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd | wc -l)"
trx=$(grep -c -E "^#! " "/etc/xray/config.json")
let jumlahakuntrojan=$trx/2
ssx=$(grep -c -E "^## " "/etc/xray/config.json")
let jumlahakunshadowsock=$ssx/2
colornow=$(cat /etc/yaddykakkoii/theme/color.conf)
export NC="\e[0m"
export YELLOW='\033[0;33m';
export RED="\033[0;31m" 
export COLOR1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
export COLBG1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')" 
WH='\033[1;37m'                   
###########- Yaddy Kakkoii-##########
tram=$( free -h | awk 'NR==2 {print $2}' )
uram=$( free -h | awk 'NR==2 {print $3}' )
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
export RED='\033[0;31m'
export GREEN='\033[0;32m'
# status
#echo "$date" > /root/status
#rm -f /root/status
statushariini=$( curl -sS https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/statushariini)
#statushariini=$( curl -sS https://gitlab.mzyaddy.ganteng.tech/statushariini)
#wget -q -O /root/status "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/statushariini"
# usage
vnstat_profile=$(vnstat | sed -n '3p' | awk '{print $1}' | grep -o '[^:]*')
vnstat -i ${vnstat_profile} >/root/t1
bulan=$(date +%b)
today=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
todayd=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $8}')
today_v=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $9}')
today_rx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $2}')
today_rxv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $3}')
today_tx=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $5}')
today_txv=$(vnstat -i ${vnstat_profile} | grep today | awk '{print $6}')
if [ "$(grep -wc ${bulan} /root/t1)" != '0' ]; then
    bulan=$(date +%b)
    month=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $9}')
    month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $10}')
    month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $3}')
    month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $4}')
    month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $6}')
    month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $7}')
else
    bulan=$(date +%Y-%m)
    month=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $8}')
    month_v=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $9}')
    month_rx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $2}')
    month_rxv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $3}')
    month_tx=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $5}')
    month_txv=$(vnstat -i ${vnstat_profile} | grep "$bulan " | awk '{print $6}')
fi
if [ "$(grep -wc yesterday /root/t1)" != '0' ]; then
    yesterday=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $8}')
    yesterday_v=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $9}')
    yesterday_rx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $2}')
    yesterday_rxv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $3}')
    yesterday_tx=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $5}')
    yesterday_txv=$(vnstat -i ${vnstat_profile} | grep yesterday | awk '{print $6}')
else
    yesterday=NULL
    yesterday_v=NULL
    yesterday_rx=NULL
    yesterday_rxv=NULL
    yesterday_tx=NULL
    yesterday_txv=NULL
fi
# // STATUS OPENVPN 
openvpn=$( systemctl status ohp | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $openvpn == "running" ]]; then
    status_openvpn="${COLOR1}ON${NC}"
else
    status_openvpn="${RED}OFF${NC}"
fi
# // STATUS SQUID PROXY
squidproxy=$( systemctl status squid | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $squidproxy == "running" ]]; then
    status_squid="${COLOR1}ON${NC}"
else
    status_squid="${RED}OFF${NC}"
fi
# // STATUS SLOWDNS
#slowdnss=$( systemctl status slow-server | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
slowdnss=$( systemctl status server-sldns | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $slowdnss == "running" ]]; then
    status_slowdns="${COLOR1}ON${NC}"
else
    status_slowdns="${RED}OFF${NC}"
fi
# // STATUS OPENSSH BSD
openssh=$( systemctl status ssh | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $openssh == "running" ]]; then
    status_openssh="${COLOR1}ON${NC}"
else
    status_openssh="${RED}OFF${NC}"
fi
# // STATUS SSH DROPBEAR
dropbearr=$( systemctl status dropbear | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $dropbearr == "running" ]]; then
    status_dropbear="${COLOR1}ON${NC}"
else
    status_dropbear="${RED}OFF${NC}"
fi
# // STATUS SSH UDP
sshudpserver=$( systemctl status udpcore | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $sshudpserver == "running" ]]; then
    status_sshudp="${COLOR1}ON${NC}"
else
    status_sshudp="${RED}OFF${NC}"
fi
# // STATUS SSH WEBSOCKET ATAU WS STUNNEL4 
ssh_ws=$( systemctl status ws-stunnel | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $ssh_ws == "running" ]]; then
    status_ws="${COLOR1}ON${NC}"
else
    status_ws="${RED}OFF${NC}"
fi
# // STATUS NGINX
nginx=$( systemctl status nginx | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $nginx == "running" ]]; then
    status_nginx="${COLOR1}ON${NC}"
else
    status_nginx="${RED}OFF${NC}"
fi
# // STATUS XRAY
xray=$( systemctl status xray | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
if [[ $xray == "running" ]]; then
    status_xray="${COLOR1}ON${NC}"
else
    status_xray="${RED}OFF${NC}"
fi
clear
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• VPS PANEL MENU •              ${NC} $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
uphours=`uptime -p | awk '{print $2,$3}' | cut -d , -f1`
upminutes=`uptime -p | awk '{print $4,$5}' | cut -d , -f1`
uptimecek=`uptime -p | awk '{print $6,$7}' | cut -d , -f1`
cekup=`uptime -p | grep -ow "day"`
IPVPS=$(curl -s ipinfo.io/ip )
serverVersion=$( curl -sS https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/versi)
#echo -e "$COLOR1 $NC ${WH}Public Key     ${COLOR1}: ${WH}$(cat /etc/slowdns/server.pub)"
uis="${COLOR1}Premium Version$NC"
echo -e "$COLOR1 $NC ${WH}User Roles     ${COLOR1}: ${WH}$uis"
if [ "$cekup" = "day" ]; then
    echo -e "$COLOR1 $NC ${WH}System Uptime  ${COLOR1}: ${WH}$uphours $upminutes $uptimecek"
else
    echo -e "$COLOR1 $NC ${WH}System Uptime  ${COLOR1}: ${WH}$uphours $upminutes"
fi
echo -e "$COLOR1 $NC ${WH}Memory Usage   ${COLOR1}: ${WH}$uram / $tram"
echo -e "$COLOR1 $NC ${WH}ISP & City     ${COLOR1}: ${WH}$ISP & $CITY"
echo -e "$COLOR1 $NC ${WH}Current Domain ${COLOR1}: ${WH}$(cat /etc/xray/domain)"
#echo -e "$COLOR1 $NC ${WH}Alter Domain   ${COLOR1}: ${WH}$(cat /etc/xray/subdomain)"
echo -e "$COLOR1 $NC ${WH}NS Domain      ${COLOR1}: ${WH}$(cat /etc/xray/nsdomain)"
echo -e "$COLOR1 $NC ${WH}IP-VPS         ${COLOR1}: ${WH}$IPVPS${NC}"
echo -e "$COLOR1 $NC ${WH}Server Resource${COLOR1}: ${WH}RAM = $persenmemori% | CPU = $persencpu%${NC}"
echo -e "$COLOR1 $NC ${WH}Status Hari ini${COLOR1}: ${WH}${statushariini}${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "$COLOR1 $NC ${WH}[ SSH WSS : ${status_ws} ${WH}]  ${WH}[ NGINX   : ${status_nginx} ${WH}]   ${WH}[ XRAY  : ${status_xray} ${WH}] $COLOR1 $NC"
echo -e "$COLOR1 $NC ${WH}[ SSH UDP : ${status_sshudp} ${WH}]  ${WH}[ OPENSSH : ${status_openssh} ${WH}]   ${WH}[ SQUID : ${status_squid} ${WH}] $COLOR1 $NC"
echo -e "$COLOR1 $NC ${WH}[ SLOWDNS : ${status_slowdns} ${WH}]  ${WH}[ OPENVPN : ${status_openvpn} ${WH}]   ${WH}[ DRPBR : ${status_dropbear} ${WH}] $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}┌──────────────────────────────────────────────────┐${NC}"
echo -e "${GREEN}│  \033[0m ${BOLD}${YELLOW}SSH  |  VMESS  |  VLESS  |  TROJAN  |  SHADOWSOC$NC  $COLOR1"
echo -e "${GREEN}│  \033[0m ${Blue} $jumlahakunssh        $jumlahakunvmess         $jumlahakunvless          $jumlahakuntrojan            $jumlahakunshadowsock   $NC"
echo -e "${GREEN}└──────────────────────────────────────────────────┘${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "$COLOR1 ${COLOR1}Traffic${NC}      ${COLOR1}Today       Yesterday       Month   ${NC}"
echo -e "$COLOR1 ${WH}Download${NC}   ${WH}$today_tx $today_txv     $yesterday_tx $yesterday_txv      $month_tx $month_txv   ${NC}"
echo -e "$COLOR1 ${WH}Upload${NC}     ${WH}$today_rx $today_rxv     $yesterday_rx $yesterday_rxv      $month_rx $month_rxv   ${NC}"
echo -e "$COLOR1 ${COLOR1}Total${NC}    ${COLOR1}  $todayd $today_v     $yesterday $yesterday_v      $month $month_v  ${NC} "
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
echo -e "  ${WH}[${COLOR1}01${WH}]${NC} ${COLOR1}• ${WH}SSHWS   ${WH}[${COLOR1}${status_ws}${WH}]   ${WH}[${COLOR1}09${WH}]${NC} ${COLOR1}• ${WH}SET DNS $WH}[${COLOR1}Menu${WH}]  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}02${WH}]${NC} ${COLOR1}• ${WH}SSH UDP ${WH}[${COLOR1}${status_sshudp}${WH}]   ${WH}[${COLOR1}10${WH}]${NC} ${COLOR1}• ${WH}THEME    ${WH}[${COLOR1}Menu${WH}]  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}03${WH}]${NC} ${COLOR1}• ${WH}SLDNS   ${WH}[${COLOR1}${status_slowdns}${WH}]   ${WH}[${COLOR1}11${WH}]${NC} ${COLOR1}• ${WH}BACKUP   ${WH}[${COLOR1}Menu${WH}]  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}04${WH}]${NC} ${COLOR1}• ${WH}VMESS   ${WH}[${COLOR1}${status_xray}${WH}]   ${WH}[${COLOR1}12${WH}]${NC} ${COLOR1}• ${WH}GANTI DOMAIN  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}05${WH}]${NC} ${COLOR1}• ${WH}VLESS   ${WH}[${COLOR1}${status_xray}${WH}]   ${WH}[${COLOR1}13${WH}]${NC} ${COLOR1}• ${WH}UPDATE SKRIP       $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}06${WH}]${NC} ${COLOR1}• ${WH}TROJAN  ${WH}[${COLOR1}${status_xray}${WH}]   ${WH}[${COLOR1}14${WH}]${NC} ${COLOR1}• ${WH}GANTI X-CORE  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}07${WH}]${NC} ${COLOR1}• ${WH}SS WS   ${WH}[${COLOR1}${status_xray}${WH}]   ${WH}[${COLOR1}15${WH}]${NC} ${COLOR1}• ${WH}SETTINGS ${WH}[${COLOR1}Menu${WH}]  $COLOR1 $NC"
echo -e "  ${WH}[${COLOR1}08${WH}]${NC} ${COLOR1}• ${WH}PURGE   ${WH}[${COLOR1}ON${WH}]   ${WH}[${COLOR1}16${WH}]${NC} ${COLOR1}• ${WH}INFO     ${WH}[${COLOR1}Menu${WH}]  $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
function updateskripp(){
rm -f usr/bin/updateskrip > /dev/null 2>&1
wget -q -O /usr/bin/updateskrip "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/install-up.sh" && chmod +x /usr/bin/updateskrip
updateskrip
}
myver="$(cat /opt/.ver)"
    if [[ $serverVersion > $myver ]]; then
        echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
        echo -e "$COLOR1 $NC ${WH}[${COLOR1}100${WH}]${NC} ${COLOR1}• ${WH}UPDATE TO V$serverVersion${NC}" 
        echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
        up2u="updateskripp"
    else
        up2u="menu"
    fi
echo -e "$COLOR1┌─────────────────────────────────────────────────┐$NC"
echo -e "$COLOR1 $NC ${WH}Version     ${COLOR1}:${WH} $(cat /opt/.ver) Latest Version${NC}"
echo -e "$COLOR1 $NC ${WH}Client Name ${COLOR1}: ${WH}MZ YADDY GANTENG 💯 ${NC}"
echo -e "$COLOR1 $NC ${WH}License     ${COLOR1}: ${WH}LifeTime 😁 ${NC}"
echo -e "$COLOR1 $NC ${WH}Developer   ${COLOR1}: ${WH}Yaddy D phreaker ${NC}"
echo -e "$COLOR1└─────────────────────────────────────────────────┘$NC"
echo -e "$COLOR1┌────────────────────── ${WH}BY${NC} ${COLOR1}───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}             ${WH}• MZ YADDY KAKKOII 2027 •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
echo -e ""
echo -ne " ${WH}Note ${COLOR1}: 🍁 ${WH}"
echo -ne " ${WH}Ketik X untuk keluar dari menu ${COLOR1}🍁 ${WH}"
echo -e ""
echo -e ""
echo -e ""
echo -ne " ${WH}Select menu ${COLOR1}: ${WH}"; read opt
case $opt in
01 | 1) clear ; menu-ssh ;;
02 | 2) clear ; menuudp ;;
03 | 3) clear ; menuslowdns ;;
04 | 4) clear ; menu-vmess ;;
05 | 5) clear ; menu-vless ;;
06 | 6) clear ; menu-trojan ;;
07 | 7) clear ; menu-ss ;;
08 | 8) clear ; purgenginx ;;
09 | 9) clear ; menu-dns ;;
10) clear ; menu-theme ;;
11) clear ; menu-backup ;;
12) clear ; gantidomain ;;
13) clear ; updateskripp ;;
14) clear ; gantixraycore ;;
15) clear ; menu-set ;;
16) clear ; info ;;
17) clear ; install-up ;;
100) clear ; $up2u ;;
00 | 0) clear ; menu ;;
x | X) clear ; exit ;;
*) clear ; menu ;;
esac
