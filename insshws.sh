#!/bin/bash
function instalsshwebsocket(){
#hapus pagar saat reinstall // uncomment cokk jancokk
setopserviswebsoket(){
systemctl stop sshws.service
tmux kill-session -t sshws
systemctl stop ws-dropbear.service
systemctl stop ws-stunnel.service
systemctl stop ws-openssh.service
systemctl stop ws-ovpn.service
rm -f /etc/systemd/system/sshws.service
rm -f /usr/bin/ssh-wsenabler
rm -f /usr/local/bin/ws-dropbear
rm -f /usr/local/bin/ws-stunnel
rm -f /usr/local/bin/ws-openssh
rm -f /usr/local/bin/ws-ovpn
rm -f /etc/systemd/system/ws-dropbear.service
rm -f /etc/systemd/system/ws-stunnel.service
rm -f /etc/systemd/system/ws-openssh.service
rm -f /etc/systemd/system/ws-ovpn.service
rm -f /usr/bin/proxy3.js
}
#setopserviswebsoket
cd
wget -qO /usr/bin/ssh-wsenabler "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ssh-wsenabler"
wget -qO /usr/bin/proxy3.js "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/proxy3.js"
wget -qO /usr/local/bin/ws-dropbear "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-dropbear"
wget -qO /usr/local/bin/ws-stunnel "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-stunnel"
wget -qO /usr/local/bin/ws-openssh "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-openssh"
wget -qO /usr/local/bin/ws-ovpn "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-ovpn"
wget -qO /etc/systemd/system/ws-ovpn.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-ovpn.service"
wget -qO /etc/systemd/system/ws-dropbear.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-dropbear.service"
wget -qO /etc/systemd/system/ws-stunnel.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-stunnel.service"
wget -qO /etc/systemd/system/ws-openssh.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/ws-openssh.service"
sleep 1
chmod +x /usr/bin/ssh-wsenabler
chmod +x /usr/bin/proxy3.js
chmod +x /usr/local/bin/ws-dropbear
chmod +x /usr/local/bin/ws-stunnel
chmod +x /usr/local/bin/ws-openssh
chmod +x /etc/systemd/system/ws-dropbear.service
chmod +x /etc/systemd/system/ws-stunnel.service
chmod +x /etc/systemd/system/ws-openssh.service
sleep 1
systemctl daemon-reload
systemctl enable ws-dropbear.service
systemctl start ws-dropbear.service
systemctl restart ws-dropbear.service
systemctl enable ws-stunnel.service
systemctl start ws-stunnel.service
systemctl restart ws-stunnel.service
systemctl enable ws-openssh.service
systemctl start ws-openssh.service
systemctl restart ws-openssh.service
systemctl enable ws-ovpn.service
systemctl start ws-ovpn.service
systemctl restart ws-ovpn.service
cat <<EOF > /etc/systemd/system/sshws.service
[Unit]
Description=WSenabler
Documentation=By YaddyKakkoii

[Service]
Type=simple
ExecStart=/usr/bin/ssh-wsenabler
KillMode=process
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOF
chmod +x /etc/systemd/system/sshws.service
systemctl daemon-reload >/dev/null 2>&1
systemctl enable sshws.service >/dev/null 2>&1
systemctl start sshws.service >/dev/null 2>&1
systemctl restart sshws.service >/dev/null 2>&1
service sshws restart
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "SSH WEBSOCKET TELAH AKTIF...!!"
echo -e "$COLOR1 ${NC}  ${WH}[${COLOR1}INFO${WH}]${NC} ${COLOR1}•${NC} ${green}SSH Websocket Started${NC}"
echo -e "$COLOR1┌────────────────────── ${WH}BY${NC} ${COLOR1}───────────────────────┐${NC}"
echo -e "$COLOR1 ${NC}                ${WH}• YADDY KAKKOII MAGELANG •${NC}                 $COLOR1 $NC"
echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"

#RESPONSE = 'HTTP/1.1 101 WebSocket <font color="lime">Yaddy Kakkoii </font><font color="yellow">Tampan </font><font color="red">Maksimal</font>\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: foo\r\n\r\n'
#RESPONSE = 'HTTP/1.1 101 WebSocket <font color="lime">Yaddy Kakkoii </font><font color="yellow">Tampan </font><font color="red">Maksimal</font>\r\nContent-Length: 104857600000\r\n\r\n'

}
instalsshwebsocket
