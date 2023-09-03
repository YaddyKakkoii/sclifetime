#!/bin/bash
NC='\e[0m'
tyblue='\e[1;36m'
function installsshudplama(){
    echo -e "${tyblue}.------------------------------------------.${NC}"
    echo -e "${tyblue}|           INSTALL UDP            |${NC}"
    echo -e "${tyblue}'------------------------------------------'${NC}"
    sleep 2
    systemctl stop udp-custom
    systemctl stop udpcore
    rm -f /etc/systemd/system/udp-custom.service
    rm -f /etc/systemd/system/udpcore.service
    rm -rf /root/udp
    rm -rf /etc/udpxyaddy
    mkdir -p /etc/udpxyaddy
    echo "change to time GMT+7"
    ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
    wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1ixz82G_ruRBnEEp4vLPNF2KZ1k8UfrkV' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1ixz82G_ruRBnEEp4vLPNF2KZ1k8UfrkV" -O /etc/udpxyaddy/udpcore && rm -rf /tmp/cookies.txt
    chmod +x /etc/udpxyaddy/udpcore
    wget -q --show-progress --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1klXTiKGUd2Cs5cBnH3eK2Q1w50Yx3jbf' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1klXTiKGUd2Cs5cBnH3eK2Q1w50Yx3jbf" -O /etc/udpxyaddy/config.json && rm -rf /tmp/cookies.txt
#    wget -q -O /etc/udpxyaddy/udpcore "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udp-custom" && chmod +x /etc/udpxyaddy/udpcore
#    wget -q -O /etc/udpxyaddy/config.json "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/UDPconfig.json" && chmod +x /etc/udpxyaddy/config.json
    if [ -z "$1" ]; then
        cat <<EOF > /etc/systemd/system/udpcore.service
[Unit]
Description=UDP Custom by YaddyKakkoii

[Service]
User=root
Type=simple
ExecStart=/etc/udpxyaddy/udpcore server
WorkingDirectory=/etc/udpxyaddy/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
    else
        cat <<EOF > /etc/systemd/system/udpcore.service
[Unit]
Description=UDP Custom by YaddyKakkoii

[Service]
User=root
Type=simple
ExecStart=/etc/udpxyaddy/udpcore server -exclude $1
WorkingDirectory=/etc/udpxyaddy/
Restart=always
RestartSec=2s

[Install]
WantedBy=default.target
EOF
    fi
    wget -q -O /usr/bin/udpxp "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/udpxp.sh" && chmod +x /usr/bin/udpxp; udpxp >/dev/null 2>&1
    cat >/etc/cron.d/udpexpi <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
3 0 * * * root /usr/bin/udpxp
END
    chmod +x /etc/udpxyaddy/config.json
    chmod +x /etc/udpxyaddy/udpcore
    chmod +x /etc/systemd/system/udpcore.service
    systemctl daemon-reload
    systemctl start udpcore &>/dev/null
    systemctl enable udpcore &>/dev/null
    service udpcore restart
    service cron reload >/dev/null 2>&1
    systemctl restart cron >/dev/null 2>&1
    /etc/init.d/cron restart >/dev/null 2>&1
    service cron restart >/dev/null 2>&1
}
installsshudplama
