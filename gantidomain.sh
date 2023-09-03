#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
colornow=$(cat /etc/yaddykakkoii/theme/color.conf)
#NC="\e[0m"
#RED="\033[0;31m" 
COLOR1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')" 
WH='\033[1;37m'                   
###########- Yaddy Kakkoii-##########
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White
UWhite='\033[4;37m'       # White
On_IPurple='\033[0;105m'  #
On_IRed='\033[0;101m'
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White
#NC='\e[0m'
# // Export Color & Information
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export LIGHT='\033[0;37m'
export NC='\033[0m'
# // Export Banner Status Information
export EROR="[${RED} EROR ${NC}]"
export INFO="[${YELLOW} INFO ${NC}]"
export OKEY="[${GREEN} OKEY ${NC}]"
export PENDING="[${YELLOW} PENDING ${NC}]"
export SEND="[${YELLOW} SEND ${NC}]"
export RECEIVE="[${YELLOW} RECEIVE ${NC}]"
# // Export Align
export BOLD="\e[1m"
export WARNING="${RED}\e[5m"
export UNDERLINE="\e[4m"
# // Root Checking
if [ "${EUID}" -ne 0 ]; then
		echo -e "${EROR} Please Run This Script As Root User !"
		exit 1
fi
function perbaruisertifikat(){
    cekray=`cat /root/log-install.txt | grep -ow "XRAY" | sort | uniq`
    if [ "$cekray" = "XRAY" ]; then
        domainlama=`cat /etc/xray/domain`
    else
        domainlama=`cat /etc/xray/domain`
    fi
    clear
    echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo -e "$COLBG1               • RENEW DOMAIN SSL •               $NC"
    echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo -e ""
    echo -e "[ ${green}INFO${NC} ] Start " 
    sleep 0.5
    systemctl stop nginx
    systemctl stop udpcore
    domain=$(cat /var/lib/yaddykakkoii/ipvps.conf | cut -d'=' -f2)
    Cek=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
    if [[ ! -z "$Cek" ]]; then
        sleep 1
        echo -e "[ ${red}WARNING${NC} ] Detected port 80 used by $Cek " 
        systemctl stop $Cek
        sleep 1
        echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
        sleep 1
    fi
    echo -e "[ ${green}INFO${NC} ] Starting renew cert... " 
    sleep 2
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    echo -e "[ ${green}INFO${NC} ] Renew cert done... "
    sleep 1
    echo -e "[ ${green}INFO${NC} ] Starting service $Cek " 
    sleep 2
    echo $domain > /etc/xray/domain
    systemctl restart $Cek
    systemctl restart nginx
    systemctl restart udpcore
    echo -e "[ ${green}INFO${NC} ] All finished... " 
    sleep 0.5
    echo ""
    echo -e "$COLOR1━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$NC"
    echo ""
    read -n 1 -s -r -p "Press any key to back on menu"
    menu
}
function gantidomain(){
    clear
    echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
    echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• GANTI DOMAIN / HOST VPS •                ${NC} $COLOR1 $NC"
    echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
    read -rp "  New Host Name : " -e host
    echo ""
    if [ -z $host ]; then
        echo -e "  [INFO] Type Your Domain/sub domain"
        echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
        echo ""
        read -n 1 -s -r -p "  Tekan Enter untuk Kembali "
        gantidomain
    else
        echo "IP=$host" > /var/lib/yaddykakkoii/ipvps.conf
        echo ""
        echo "  [INFO] Memperbarui Sertifikat"
        echo ""
        echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
        echo ""
        read -n 1 -s -r -p "  Tekan Enter untuk Memperbarui Sertifikat"
        perbaruisertifikat
    fi
}
gantidomain
