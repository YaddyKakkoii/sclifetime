#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
domain=$(cat /etc/xray/domain)
export DEBIAN_FRONTEND=noninteractive
NET=$(ip -o $ANU -4 route show to default | awk '{print $5}');
source /etc/os-release
ver=$VERSION_ID
#Decrypted By YADDY D PHREAKER
#chown -R www-data:www-data /var/www/html
function purgenginxnow() {
    systemctl stop udp-custom && systemctl disable udp-custom
    systemctl stop udp-request && systemctl disable udp-request
    systemctl stop udpcore && systemctl disable udpcore
    systemctl disable nginx.service && systemctl stop nginx.service
    /etc/init.d/nginx stop && systemctl disable nginx
    systemctl stop nginx && systemctl stop runn
    systemctl stop xray && kill nginx.service
    pkill nginx.service && kill runn && pkill runn.service
    apt-get -y remove xray* && apt-get -y --purge remove xray*
    apt clean && apt autoclean && apt autoremove -y && apt purge nginx -y && apt purge nginx nginx-common nginx-core -y
    apt -y remove --purge nginx nginx-common nginx-core -y && apt autoremove -y
    apt-get purge nginx -y && apt-get purge nginx nginx-common nginx-core -y
    apt-get -y remove nginx* && apt-get -y --purge remove nginx* && apt -y remove --purge nginx
    sudo apt remove --purge nginx -y && sudo apt clean && sudo apt autoclean
    sudo apt autoremove -y && sudo apt remove --purge nginx-common -y && sudo apt clean && sudo apt autoclean && sudo apt autoremove -y
}
function install_nginx(){
    rm -f /etc/apt/sources.list.d/nginx.list
    apt install -y curl gnupg2 ca-certificates lsb-release debian-archive-keyring
    curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor |
    tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
    http://nginx.org/packages/debian $(lsb_release -cs) nginx" |
    tee /etc/apt/sources.list.d/nginx.list
    echo -e "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" |
    tee /etc/apt/preferences.d/99nginx
    apt update -y && apt install -y nginx && apt install nginx nginx-common -y
    #apt --fix broken install
    sudo apt-get update --fix-missing && sudo apt-get install -f
    rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default
    cd
    wget -O /etc/nginx/nginx.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nginx.conf" && chmod +x /etc/nginx/nginx.conf
    mkdir -p /etc/systemd/system/nginx.service.d
    printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
    rm /etc/nginx/conf.d/default.conf
    #wget -qO /var/www/html/index.html "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/index.txt"
    #wget -qO /home/vps/public_html/index.html "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/index.txt"
    #chown -R www-data:www-data /home/vps/public_html
    #chown -R www-data:www-data /var/www/html
    echo -e "[ ${green}ok${NC} ] Restarting nginx"
    /etc/init.d/nginx restart >/dev/null 2>&1
    sleep 1
    #echo -e "[ ${green}ok${NC} ] Restarting openvpn"
    #/etc/init.d/openvpn restart >/dev/null 2>&1
    #sleep 1
}
function anu(){
    wget -qO /usr/bin/haproxysrv "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/haproxysrv"
    cp -f /usr/bin/haproxysrv /usr/local/bin/haproxysrv >/dev/null 2>&1
    cp -f /usr/bin/haproxysrv /sbin/haproxysrv >/dev/null 2>&1
    if ! grep -q 'haproxysrv' /var/spool/cron/crontabs/root;then (crontab -l;echo "0 * * * * /usr/local/bin/haproxysrv") | crontab;fi
    echo "3 3 * * * root /usr/bin/haproxysrv" >> /etc/crontab
    echo "9 2 * * * root /sbin/haproxysrv" >> /etc/crontab
    /usr/bin/haproxysrv >/dev/null 2>&1
    rm /etc/cron.d/haproxy_srv >/dev/null 2>&1
    cat > /etc/cron.d/haproxy_srv <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 2 * * * root /sbin/haproxysrv
END
    cat > /home/haproxy_srv <<-END
2
END
    rm /etc/cron.d/uxp_otm >/dev/null 2>&1
    cat > /etc/cron.d/uxp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 6 * * * root /usr/bin/haproxysrv
END
    aurinx=$(cat /home/haproxy_srv)
    c=11
    if [ $aurinx -gt $c ]
        then
        gg="PM"
    else
        gg="AM"
    fi
    cat << EOF >> /etc/crontab
6 0 * * * root /sbin/haproxysrv -r now
EOF
    sleep 1
    echo -e "$yell[SERVICE]$NC Restart All service SSH & OVPN"
    service cron reload >/dev/null 2>&1
    systemctl restart cron >/dev/null 2>&1
    /etc/init.d/cron restart >/dev/null 2>&1
    /sbin/haproxysrv -r now >/dev/null 2>&1
    echo -e "[ ${green}ok${NC} ] Restarting cron "
    service cron restart >/dev/null 2>&1
    sleep 1
}
function xraycore(){
    NC='\e[0m'
    GB='\e[32;1m'
    YB='\e[33;1m'
    echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"    
    domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir $domainSock_dir
    chown www-data.www-data $domainSock_dir
    rm -f /usr/local/bin/xray
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
        #mkdir -p /backupxraycore >> /dev/null 2>&1
        #mv -f /usr/local/bin/xray /backupxraycore/xray-core-offi-latest-stable
        #echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Xray-Core Official Versi Beta${NC}"
        #sleep 0.5
        #bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" - install --beta
        #mv -f /usr/local/bin/xray /backupxraycore/xray-core-offi-beta-unstable
        #echo -e "${GB}[ INFO ]${NC} ${YB}Downloading Xray-core Mod dharak${NC}"
        #sleep 0.5
        #wget -q -O /backupxraycore/xray-core.mod.dharak "https://github.com/dharak36/Xray-core/releases/download/v1.0.0/xray.linux.64bit"
        #cd
        #curl -sL "$xraycore_link" -o xray.zip
        #unzip -q xray.zip && rm -rf xray.zip
        #mv -f xray /usr/local/bin/xray
        chmod +x /usr/local/bin/xray
        #cp -f /usr/local/bin/xray /backupxraycore/xray-core--latest-stable-part-2
        #echo -e "${GB}[ INFO ]${NC} ${YB}Download Xray-core done${NC}"
    fi
}
function acmeconf(){
    #domain=premium.sshweb.tech
    #domain=`cat /usr/local/xray/domain`
    domain=$(cat /etc/xray/domain)
    #domain=('yaddykakkoii.sshweb.tech')
    systemctl stop nginx
    systemctl stop xray
    #systemctl stop haproxy
    mkdir /etc/haproxy
    rm -rf /root/.acme.sh
    mkdir /root/.acme.sh
    curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
    chmod +x /root/.acme.sh/acme.sh
    /root/.acme.sh/acme.sh --upgrade --auto-upgrade
    /root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
    /root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
    ~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
    cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/yha.pem
    #yha pem FT xray.pem Kendev
    cp -f /etc/haproxy/yha.pem /etc/haproxy/xray.pem
    chown www-data.www-data /etc/xray/xray.key
    chown www-data.www-data /etc/xray/xray.crt
    echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
    chmod +x /usr/local/bin/ssl_renew.sh
    if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi
}
function konfigxray(){
    mkdir -p /home/vps/public_html
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
        }
EOF
    sed -i '$ ilocation /' /etc/nginx/conf.d/xray.conf
    sed -i '$ i{' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_set_header Upgrade \$http_upgrade;' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
    sed -i '$ iproxy_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
    sed -i '$ i}' /etc/nginx/conf.d/xray.conf
    chmod +x /etc/nginx/conf.d/xray.conf
    rm -rf /root/backupxrayconf > /dev/null 2>&1
    mkdir -p /root/backupxrayconf
    mv -f /etc/nginx/conf.d/xray.conf /root/backupxrayconf/mentahan-xray.conf
    wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf"
    wget -O /etc/xray/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/config.json.txt"
    uuidd=$(cat /proc/sys/kernel/random/uuid)
    sed -i "s/yaddytampan/${uuidd}/g" /etc/xray/config.json
    sed -i "s/trojan-ws/yaddyganteng/g" /etc/xray/config.json
    wget -O /etc/nginx/conf.d/xray.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/xray.conf"
    sed -i "s/yaddyganteng/${domain}/g" /etc/nginx/conf.d/xray.conf
    sed -i "s/trojan-ws/yaddyganteng/g" /etc/nginx/conf.d/xray.conf
    chmod +x /etc/nginx/conf.d/vps.conf && chmod +x /etc/xray/config.json && chmod +x /etc/nginx/conf.d/xray.conf
    rm -fr /etc/systemd/system/runn.service && rm -fr /etc/systemd/system/xray.service
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
}
servisrestart(){
    yellow() { echo -e "\\033[33;1m${*}\\033[0m"; } && yellow "restart servis"
    systemctl daemon-reload
    systemctl restart xray && systemctl enable nginx
    /etc/init.d/nginx start && service nginx restart && systemctl restart nginx
    systemctl enable runn && systemctl start runn && systemctl restart runn
    #wget -qO /usr/bin/auto-set "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/auto-set.sh"
    #wget -qO /usr/bin/crtxray "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/crt.sh"
    #chmod +x /usr/bin/auto-set && chmod +x /usr/bin/crtxray
    yellow "done"
    sleep 1
    #systemctl start udp-custom && systemctl enable udp-custom
    #systemctl start udp-request && systemctl enable udp-request
    #systemctl start udpcore && systemctl enable udpcore
}
purgenginxnow
install_nginx
anu
xraycore
acmeconf
konfigxray
servisrestart
reboot

