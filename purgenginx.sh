#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
domain=$(cat /etc/xray/domain)
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
function pasangdropbear(){
cd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 500' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 40000' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 51443' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 58080' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 200' /etc/ssh/sshd_config
#sed -i '/Port 22/a Port 22' /etc/ssh/sshd_config
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
function fixxx(){
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default
mv -f /etc/nginx/nginx.conf /etc/nginx/nginx.conf_bak > /dev/null 2>&1
wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf" && chmod 777 /etc/nginx/nginx.conf
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
        systemctl stop udpcore
        systemctl stop $Cek
        sleep 1
        echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
        sleep 2
    fi
uuid=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
rm -f /etc/nginx/conf.d/vps.conf > /dev/null 2>&1
rm -f /etc/nginx/conf.d/xray.conf > /dev/null 2>&1
rm -f /etc/xray/config.json > /dev/null 2>&1
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
    systemctl restart udpcore

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
    menu
}
purgenginxnow

pasangdropbear
sed -i 's/NO_START=1/NO_START=0/g' /etc/default/dropbear
sed -i 's/DROPBEAR_PORT=22/DROPBEAR_PORT=143/g' /etc/default/dropbear
sed -i 's/DROPBEAR_EXTRA_ARGS=/DROPBEAR_EXTRA_ARGS="-p 50000 -p 109 -p 110 -p 69"/g' /etc/default/dropbear
echo "/bin/false" >> /etc/shells
echo "/usr/sbin/nologin" >> /etc/shells
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/issue.net"@g' /etc/default/dropbear
/etc/init.d/ssh restart
/etc/init.d/dropbear restart

nginx_install
fixxx
