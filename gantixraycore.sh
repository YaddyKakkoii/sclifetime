function gantixraycore(){
    if [ -f "/usr/local/etc/xray/serverpsk" ]; then
        clear
    else
        echo "UQ3w2q98BItd3DPgyctdoJw4cqQFmY59ppiDQdqMKbw=" > /usr/local/etc/xray/serverpsk
    fi
function donlodxraycore(){
    #curl -s ipinfo.io/city >> /usr/local/etc/xray/city
    #curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /usr/local/etc/xray/org
    #curl -s ipinfo.io/timezone >> /usr/local/etc/xray/timezone
    #domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir $domainSock_dir
    #chown www-data.www-data $domainSock_dir
    NC='\e[0m'
    GB='\e[32;1m'
    YB='\e[33;1m'
    latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v$latest_version/xray-linux-64.zip"
    echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
    if [ -f "/usr/local/bin/xray" ]; then
        echo "sudah ada core, mulai proses over write"
        clear
    else
        echo "belum ada core, mulai proses download core"
        echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Xray-Core Official Terbaru${NC}"
        sleep 0.5
        bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version >/dev/null 2>&1
        mkdir -p /backupxraycore >> /dev/null 2>&1
        mv -f /usr/local/bin/xray /backupxraycore/xray-core-offi-latest-stable
        echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Xray-Core Official Versi Beta${NC}"
        sleep 0.5
        bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" - install --beta
        mv -f /usr/local/bin/xray /backupxraycore/xray-core-offi-beta-unstable
        echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Xray-core Mod dharak${NC}"
        sleep 0.5
        wget -q -O /backupxraycore/xray-core.mod.dharak "https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit"
        cd
        curl -sL "$xraycore_link" -o xray.zip
        unzip -q xray.zip && rm -rf xray.zip
        mv -f xray /usr/local/bin/xray
        chmod +x /usr/local/bin/xray
        cp -f /usr/local/bin/xray /backupxraycore/xray-core--latest-stable-part-2
        echo -e "${GB}[ INFO ]${NC} ${YB}Download Xray-core done${NC}"
    fi
}

function xraycorebetaofficial(){
    NC='\e[0m'
    GB='\e[32;1m'
    YB='\e[33;1m'
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Xray-core Beta Official${NC}"
    rm -rf /usr/local/bin/xray
    cp -f /backupxraycore/xray-core-offi-beta-unstable /usr/local/bin/xray
    chmod 755 /usr/local/bin/xray
    systemctl restart xray
    sleep 1
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Xray-core Official versi Beta done${NC}"
    echo ""
    echo -e "${YB}Back to menu in 1 sec${NC} "
    sleep 1
    menu
}
function xraycoreterbaruofficial(){
    NC='\e[0m'
    GB='\e[32;1m'
    YB='\e[33;1m'
    echo ""
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Xray-core Latest Official${NC}"
    rm -rf /usr/local/bin/xray
    cp -f /backupxraycore/xray-core-offi-latest-stable /usr/local/bin/xray
    chmod 755 /usr/local/bin/xray
    systemctl restart xray
    sleep 1
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Xray-core Latest Official done${NC}"
    echo ""
    echo -e "${YB}Back to menu in 1 sec${NC} "
    sleep 1
    menu
}
function xraycoremod(){
    NC='\e[0m'
    GB='\e[32;1m'
    YB='\e[33;1m'
    echo ""
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Custom Xray-core${NC}"
    rm -rf /usr/local/bin/xray
    cp -f /backupxraycore/xray-core.mod.dharak /usr/local/bin/xray
    chmod 755 /usr/local/bin/xray
    systemctl restart xray
    sleep 1
    echo -e "${GB}[ INFO ]${NC} ${YB}Change Custom Xray-core Mod done${NC}"
    echo ""
    echo -e "${YB}Back to menu in 1 sec${NC} "
    sleep 1
    menu
}
echo -e "                ${WB}----- [ GANTI XRAY CORE ] -----${NC}               "
echo -e "                ${WB}----- [ MOD DAN OFFICIAL ] -----${NC}               "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${MB}[1]${NC} ${YB}Vmess Menu${NC}          ${MB}[5]${NC} ${YB}Shadowsocks 2022 Menu${NC}"
echo -e " ${MB}[2]${NC} ${YB}Vless Menu${NC}          ${MB}[6]${NC} ${YB}Socks5 Menu${NC}"
echo -e " ${MB}[3]${NC} ${YB}Trojan Menu${NC}         ${MB}[7]${NC} ${YB}All Xray Menu${NC}"
echo -e " ${MB}[4]${NC} ${YB}Shadowsocks Menu${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e "                 ${WB}----- [ OTHER SETTING ] -----${NC}                "
echo -e "${BB}————————————————————————————————————————————————————————${NC}"
echo -e " ${MB}[8]${NC} ${YB}Log Create Account${NC}  ${MB}[13]${NC} ${YB}DNS Setting${NC}"
echo -e " ${MB}[9]${NC} ${YB}Speedtest${NC}           ${MB}[14]${NC} ${YB}Check DNS Status${NC}"
echo -e " ${MB}[10]${NC} ${YB}Change Domain${NC}      ${MB}[15]${NC} ${YB}Change Xray-core Mod${NC}"
echo -e " ${MB}[11]${NC} ${YB}Cert Acme.sh${NC}       ${MB}[16]${NC} ${YB}Change Xray-core Official${NC}"
echo -e " ${MB}[12]${NC} ${YB}About Script${NC}"
echo -e "${BB}————————————————————————————————————————————————————————${NC}"

echo -e "                ${WB}----- [ 18 download XRAY CORE ] -----${NC}               "
echo -e "                ${WB}----- [ 17 xray core Beta OFFICIAL ] -----${NC}               "


echo -e ""
read -p " Select Menu :  "  opt
echo -e ""
case $opt in
1) clear ; vmess ;;
2) clear ; vless ;;
3) clear ; trojan ;;
4) clear ; shadowsocks ;;
5) clear ; shadowsocks2022 ;;
6) clear ; socks ;;
7) clear ; allxray ;;
8) clear ; log-create ;;
9) clear ; speedtest ;;
10) clear ; dns ;;
11) clear ; certxray ;;
12) clear ; about ;;
13) clear ; changer ;;
14) clear ;
resolvectl status
15) clear ; xraycoremod ;;
16) clear ; xraycoreterbaruofficial ;;
17) clear ; xraycorebetaofficial ;;
18) clear ; donlodxraycore ;;
echo ""
echo ""
read -n 1 -s -r -p "Press any key to back on menu"
echo ""
echo ""
menu ;;

x) exit ;;
*) echo -e "${YB}salah input${NC}" ; sleep 1 ; menu ;;
esac
}
gantixraycore
#client-tcp-ohp1194.ovpn


