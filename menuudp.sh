#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
###########- COLOR CODE -##############
#& vless ### vmess #! trojanws ## ssws
colornow=$(cat /etc/yaddykakkoii/theme/color.conf)
COLOR1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "TEXT" | cut -d: -f2|sed 's/ //g')"
COLBG1="$(cat /etc/yaddykakkoii/theme/$colornow | grep -w "BG" | cut -d: -f2|sed 's/ //g')" 
WH='\033[1;37m'
NC="\e[0m"
RED="\033[0;31m"
clear
###########- Yaddy Kakkoii-##########
#sshudpserver=$( systemctl status alter-udp-yaddyganteng | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
function menuudp() {
#Script Installer UDP by YaddyKakkoii 
#echo -e "$COLOR1 $NC ${WH}[ SSH UDP : ${status_sshudp} ${WH}] $COLOR1 $NC"
function sockipudpreques(){
    cd
    rm -f /etc/udp
    mkdir -p /etc/udp
    #Decrypted By YADDY D PHREAKER #=== setup ===&>/dev/null
    sudo apt update -y && sudo apt upgrade -y 
    sudo apt install -y wget && sudo apt install -y curl && sudo apt install -y dos2unix
    wget "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udp-request" -O /usr/bin/udp-request
    chmod +x /usr/bin/udp-request
    wget -O /bin/udpgw 'https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpgw'
    chmod +x /bin/udpgw
    wget -O /etc/systemd/system/udpgw.service 'https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpgw.service'
    chmod 777 /etc/systemd/system/udpgw.service
    wget -O /etc/systemd/system/udp-request.service 'https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udp-request.service'
    chmod 777 /etc/systemd/system/udp-request.service
    wget "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/sockipconfig.json" -O /etc/udp/config.json
    chmod 777 /etc/udp/config.json
    systemctl daemon-reload
    systemctl enable udpgw && systemctl start udpgw
    systemctl enable udp-request && systemctl start udp-request
    systemctl enable udpgw.service && systemctl start udpgw.service
    systemctl enable udp-request.service && systemctl start udp-request.service
    clear
    echo "==========SCRIPT UDP REQUEST APK SOCKSIP SUKSES TERINSTAL==========="
    sleep 2
    menuudp
}
function stopsockip(){
    systemctl daemon-reload
    systemctl disable udpgw && systemctl stop udpgw
    systemctl disable udp-request && systemctl stop udp-request
    systemctl disable udpgw.service && systemctl stop udpgw.service
    systemctl disable udp-request.service && systemctl stop udp-request.service
    echo "KELUAR DARI MENU LALU MASUK LAGI UNTUK MELIHAT EFEKNYA "
    sleep 2
    clear
    menuudp
}
function startsockip(){
    systemctl daemon-reload
    systemctl enable udpgw && systemctl start udpgw
    systemctl enable udp-request && systemctl start udp-request
    systemctl enable udpgw.service && systemctl start udpgw.service
    systemctl enable udp-request.service && systemctl start udp-request.service
    echo "KELUAR DARI MENU LALU MASUK LAGI UNTUK MELIHAT EFEKNYA "
    sleep 2
    clear
    menuudp
}
function startsshudp(){
    #systemctl start udp-custom &>/dev/null
    systemctl daemon-reload
    systemctl start udpcore &>/dev/null
    systemctl enable udpcore &>/dev/null
    service udpcore restart
    echo "KELUAR DARI MENU LALU MASUK LAGI UNTUK MELIHAT EFEKNYA "
    sleep 2
    clear
    menuudp
}
function stopsshudp(){
    #systemctl stop alter-udp-yaddyganteng
    systemctl daemon-reload
    systemctl stop udpcore
    echo "KELUAR DARI MENU LALU MASUK LAGI UNTUK MELIHAT EFEKNYA "
    sleep 2
    clear
    menuudp
}
function installsshudplama(){
    wget -qO installsshudplama "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/installsshudplama.sh"
    chmod +x installsshudplama && ./installsshudplama 2200,7100,7200,7300,53,5300
    clear
    echo "==========SCRIPT UDP SUKSES TERINSTAL==========="
    rm -f installsshudplama
    menuudp
}
function installsshudp(){
    wget -qO install-udp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/install-udp.sh" && chmod +x install-udp && ./install-udp
    clear
    echo " "
    echo "==========SCRIPT UDP SUKSES TERINSTAL==========="
    echo " "
    echo "================-Yaddy Kakkoii Recode-==============" | tee -a log-install.txt
    echo "" | tee -a log-install.txt
    echo "----------------------------------------------" | tee -a log-install.txt
    echo "" | tee -a log-install.txt
    echo "   - Dev/Main           : Yaddy D Phreaker" | tee -a log-install.txt
    echo "   - Telegram           : t.me/Crystalllz" | tee -a log-install.txt
    echo "   - Instagram          : @yaddykakkoii" | tee -a log-install.txt
    echo "   - Whatsapp           : wa.me/6281383460513" | tee -a log-install.txt
    echo "   - Facebook           : fb.me/yaddyganteng" | tee -a log-install.txt
    echo "--------Script Created By Yaddy Kakkoii------"      | tee -a log-install.txt
    echo ""
    echo "========SUKSES MENGINSTALL UDP-CUSTOM========"
    echo "===============KETIK YADDY GANTENG================"
    echo ""
    rm -f install-udp
    sleep 3
    clear
    menuudp
}
    #Script Installer UDP by YaddyKakkoii
    udpcustom=$( systemctl status udpcore | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
    if [[ $udpcustom == "running" ]]; then
        status_udpcustom="${COLOR1}ON${NC}"
    else
        status_udpcustom="${RED}OFF${NC}"
    fi
    udpsockip=$( systemctl status udp-request.service | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
    if [[ $udpsockip == "running" ]]; then
        status_udpsockip="${COLOR1}ON${NC}"
    else
        status_udpsockip="${RED}OFF${NC}"
    fi
    echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
    echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• SSHUDP PANEL MENU •              ${NC} $COLOR1 $NC"
    echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo -e " $COLOR1┌───────────────────────────────────────────────┐${NC}"
    echo ""
    echo -e "$COLOR1 $NC ${WH}[ SSH UDP HTTPCUSTOM : ${status_udpcustom} ${WH}] $COLOR1 $NC"
    echo -e "$COLOR1 $NC ${WH}[ SSH UDP APK SOCKSIP : ${status_udpsockip} ${WH}] $COLOR1 $NC"
    echo ""
    echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo -e "\033[0;36m[01]\033[m | START SSH UDP Http Custom"
    echo -e "\033[0;36m[02]\033[m | STOP SSH UDP Http Custom"
    echo -e "\033[0;36m[03]\033[m | START SSH UDP request socksip"
    echo -e "\033[0;36m[04]\033[m | STOP SSH UDP request socksip"
    echo -e "\033[0;36m[05]\033[m | RE INSTALL UDP CORE, APK HTTPCUSTOM TERBARU"
    echo -e "\033[0;36m[06]\033[m | RE INSTALL UDP CORE, APK HTTPCUSTOM VERSI LAMA"
    echo -e "\033[0;36m[07]\033[m | RE INSTALL UDP REQUEST, APK SOCKSIP "
    echo -e "\033[0;36m[00]\033[m | Ketik 0 untuk Kembali ke Menu"
    echo -e "\033[0;36m['x]\033[m | Ketik x untuk KELUAR"
    echo ""
    echo -ne "\033[0;36m😁 Silakan Pilih Menu nomer PIRO ?\0033[m "
    echo ""
    echo ""
    read -p "Select From Options : " menu_num
	case $menu_num in
    	1) startsshudp ;;
    	2) stopsshudp ;;
    	3) startsockip ;;
    	4) stopsockip ;;
    	5)
        installsshudp
        ;;
    	6) installsshudplama 2200,7100,7200,7300,53,5300 ;;
    	7) sockipudpreques ;;
        00 | 0) clear ; menu-ssh ;;
        X | x) exit ;;
    	*) echo -e "You WRONG COMMAND !"
    	sleep 2 ; clear ; menuudp ;;
    esac
}
menuudp
