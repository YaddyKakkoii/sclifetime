#!/bin/bash
clear
nsdomain=$(cat /etc/xray/nsdomain)
tyblue='\e[1;36m'
function menuslowdns() {
#wget -qO nameserver "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nameserver.sh"
#chmod +x nameserver && ./nameserver && mv -f nameserver /etc/slowdns/nameserver
#wget -qO nameserver "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/nameserver.sh" && chmod +x nameserver
#bash nameserver | tee -a log-install.txt && mv -f nameserver /etc/slowdns
function installslowdns() {
    echo -e "${tyblue}.------------------------------------------.${NC}"
    echo -e "${tyblue}|           DOWNLOAD SLOWDNS            |${NC}"
    echo -e "${tyblue}'------------------------------------------'${NC}"
    sleep 2
    apt update -y && apt install -y dos2unix debconf-utils
    apt install -y python3 python3-dnslib net-tools
    apt install ncurses-utils -y && apt install dnsutils -y
    apt install golang -y && apt install iptables -y
    apt install -y whois && apt install -y sudo gnutls-bin
    apt install -y pwgen python php jq curl
    apt install -y mlocate dh-make libaudit-dev build-essential
ns_domain_cloudflare() {
    #SUB_DOMAIN=${SUB}."ganteng.tech"
    #DOMAIN=yaddykakkoii.my.id
    #DOMAIN=('sshweb.tech')
    #DOMAIN="ganteng.tech"
    DOMAIN="ganteng.tech"
	DOMAIN_VPSMU=$(cat /etc/xray/domain)
	SUB=$(tr </dev/urandom -dc a-z0-9 | head -c6)
	SUB_DOMAIN=${SUB}.$DOMAIN
	NS_DOMAIN=ns.${SUB_DOMAIN}
	#NS_DOMAIN=ns.${DOMAIN}
	CF_ID=yadicakepp@gmail.com
    CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
	set -euo pipefail
	IP=$(wget -qO- ipinfo.io/ip)
	echo "Updating DNS NS for ${NS_DOMAIN}..."
	ZONE=$(
		curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
		-H "X-Auth-Email: ${CF_ID}" \
		-H "X-Auth-Key: ${CF_KEY}" \
		-H "Content-Type: application/json" | jq -r .result[0].id
	)
	RECORD=$(
		curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
		-H "X-Auth-Email: ${CF_ID}" \
		-H "X-Auth-Key: ${CF_KEY}" \
		-H "Content-Type: application/json" | jq -r .result[0].id
	)
	if [[ "${#RECORD}" -le 10 ]]; then
		RECORD=$(
			curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
			-H "X-Auth-Email: ${CF_ID}" \
			-H "X-Auth-Key: ${CF_KEY}" \
			-H "Content-Type: application/json" \
			--data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DOMAIN_VPSMU}'","proxied":false}' | jq -r .result.id
		)
	fi
	RESULT=$(
		curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
		-H "X-Auth-Email: ${CF_ID}" \
		-H "X-Auth-Key: ${CF_KEY}" \
		-H "Content-Type: application/json" \
		--data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${DOMAIN_VPSMU}'","proxied":false}'
	)
	echo $NS_DOMAIN >/etc/xray/nsdomain
	echo $NS_DOMAIN >/etc/xray/dns
}
setup_dnstt() {
    #port nya edit manual aja yakk
    echo "Port 2222" >> /etc/ssh/sshd_config
    echo "Port 2269" >> /etc/ssh/sshd_config
    sed -i 's/#AllowTcpForwarding yes/AllowTcpForwarding yes/g' /etc/ssh/sshd_config
    service ssh restart && service sshd restart
    nsdomain=$(cat /etc/xray/nsdomain)
	cd
	rm -rf /etc/slowdns
    mkdir -m 777 /etc/slowdns
    wget -qO /etc/slowdns/dnstt-server "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/dnstt-server"
    wget -qO /etc/slowdns/dnstt-client "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/dnstt-client"
    chmod +x /etc/slowdns/dnstt-client && chmod +x /etc/slowdns/dnstt-server
	cd /etc/slowdns
	./dnstt-server -gen-key -privkey-file server.key -pubkey-file server.pub
	chmod +x /etc/slowdns/server.key && chmod +x /etc/slowdns/server.pub
	cd
    #client servis yg ini pakai port 443 :v 
    wget -qO /etc/systemd/system/slow-client.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/slow-client.service"
    wget -qO /etc/systemd/system/slow-server.service "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/slow-server.service"
	sed -i "s/xxxx/$NS_DOMAIN/g" /etc/systemd/system/slow-client.service
	sed -i "s/xxxx/$NS_DOMAIN/g" /etc/systemd/system/slow-server.service
    cat > /etc/systemd/system/client-sldns.service << END
[Unit]
Description=Client SlowDNS By YaddyKakkoii
Documentation=https://t.me/Crystalllz
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-client -udp 8.8.8.8:53 --pubkey-file /etc/slowdns/server.pub $nsdomain 127.0.0.1:2222
Restart=on-failure
[Install]
WantedBy=multi-user.target
END
    cat > /etc/systemd/system/server-sldns.service << END
[Unit]
Description=Server SlowDNS By YaddyKakkoii
Documentation=https://t.me/Crystalllz
After=network.target nss-lookup.target
[Service]
Type=simple
User=root
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/etc/slowdns/dnstt-server -udp :5300 -privkey-file /etc/slowdns/server.key $nsdomain 127.0.0.1:2269
Restart=on-failure
[Install]
WantedBy=multi-user.target
END
    chmod +x /etc/systemd/system/client-sldns.service
    chmod +x /etc/systemd/system/server-sldns.service
	iptables -I INPUT -p udp --dport 5300 -j ACCEPT
    iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
    iptables-save >/etc/iptables/rules.v4 >/dev/null 2>&1
    iptables-save >/etc/iptables.up.rules >/dev/null 2>&1
    netfilter-persistent save >/dev/null 2>&1
    netfilter-persistent reload >/dev/null 2>&1
    systemctl enable iptables >/dev/null 2>&1
    systemctl start iptables >/dev/null 2>&1
    systemctl restart iptables >/dev/null 2>&1
    pkill slow-server && pkill slow-client && pkill server-sldns && pkill server-sldns
    pkill dnstt-server && pkill dnstt-client
    systemctl daemon-reload
    systemctl stop client-sldns && systemctl stop server-sldns
    systemctl enable client-sldns && systemctl enable server-sldns
    systemctl start client-sldns && systemctl start server-sldns
    systemctl restart client-sldns && systemctl restart server-sldns
    systemctl stop slow-client && systemctl stop slow-server
    systemctl enable slow-client && systemctl enable slow-server
    systemctl start slow-client && systemctl start slow-server
    systemctl restart slow-client && systemctl restart slow-server
}
ns_domain_cloudflare
setup_dnstt
menuslowdns
}
function startslowdns() {
    systemctl daemon-reload
    systemctl enable client-sldns && systemctl enable server-sldns
    systemctl start client-sldns && systemctl start server-sldns
    systemctl restart client-sldns && systemctl restart server-sldns
    systemctl enable slow-client && systemctl enable slow-server
    systemctl start slow-client && systemctl start slow-server
    systemctl restart slow-client && systemctl restart slow-server
    sleep 2
    menuslowdns
}
function stopslowdns() {
    sleep 2
    systemctl daemon-reload
    systemctl stop client-sldns && systemctl stop server-sldns
    systemctl stop slow-client && systemctl stop slow-server
    pkill slow-server && pkill slow-client && pkill dnstt-server && pkill dnstt-client
    pkill server-sldns && pkill client-sldns
    sleep 2
    menuslowdns
}
function subdomainsshweb() {
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y
rm -rf /root/nsdomain
rm -rf /root/subdomain
mv /etc/xray/nsdomain /etc/xray/nsdomain_bak
mv /etc/xray/subdomain /etc/xray/subdomain_bak
mv /etc/xray/dns /etc/xray/dns_bak
#sub=$(</dev/urandom tr -dc a-z0-9 | head -c5)
#subns=$(</dev/urandom tr -dc a-x0-9 | head -c5)
#SUB_DOMAIN=onichan-${sub}.yaddykakkoii.my.id
#NS_DOMAIN=slowdns-${subns}.yaddykakkoii.my.id
#DOMAIN=yaddykakkoii.my.id
#SUB_DOMAIN=${sub}.yaddykakkoii.my.id
#NS_DOMAIN=${subns}yaddykakkoii.my.id
#hasil yaddykakkoii.sshweb.tech dns.sshweb.tech
sub=('yaddykakkoii')
subns=('dns')
DOMAIN=sshweb.tech
SUB_DOMAIN=${sub}.sshweb.tech
NS_DOMAIN=${subns}.sshweb.tech
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
echo "IP=""$SUB_DOMAIN" >> /var/lib/yaddykakkoii/subdomain.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Updating DNS NS for ${NS_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/subdomain
echo $SUB_DOMAIN > /root/subdomain
echo "Host NS : $NS_DOMAIN"
echo $NS_DOMAIN >/etc/xray/nsdomain
echo $NS_DOMAIN > /etc/xray/dns
echo $NS_DOMAIN > /root/nsdomain
}
function subdoganteng() {
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y
rm -rf /root/nsdomain
mv /etc/xray/nsdomain /etc/xray/nsdomain_bak
mv /etc/xray/subdomain /etc/xray/subdomain_bak
mv /etc/xray/dns /etc/xray/dns_bak
#hasil yaddykakkoii.ganteng.tech dns.ganteng.tech
sub=('yaddykakkoii')
subns=('dns')
DOMAIN=ganteng.tech
SUB_DOMAIN=${sub}.ganteng.tech
NS_DOMAIN=${subns}.ganteng.tech
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
echo "IP=""$SUB_DOMAIN" >> /var/lib/yaddykakkoii/subdomain.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Updating DNS NS for ${NS_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/subdomain
echo $SUB_DOMAIN > /root/subdomain
echo "Host NS : $NS_DOMAIN"
echo $NS_DOMAIN >/etc/xray/nsdomain
echo $NS_DOMAIN > /etc/xray/dns
echo $NS_DOMAIN > /root/nsdomain
}
function subdoyaddz() {
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
apt install jq curl -y
rm -rf /root/nsdomain
mv /etc/xray/nsdomain /etc/xray/nsdomain_bak
mv /etc/xray/subdomain /etc/xray/subdomain_bak
mv /etc/xray/dns /etc/xray/dns_bak
#hasil premium.yaddykakkoii.my.id dns.yaddykakkoii.my.id
sub=('premium')
subns=('dns')
DOMAIN=yaddykakkoii.my.id
SUB_DOMAIN=${sub}.yaddykakkoii.my.id
NS_DOMAIN=${subns}.yaddykakkoii.my.id
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
echo "IP=""$SUB_DOMAIN" >> /var/lib/yaddykakkoii/subdomain.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Updating DNS NS for ${NS_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${NS_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"NS","name":"'${NS_DOMAIN}'","content":"'${SUB_DOMAIN}'","ttl":120,"proxied":false}')
echo "Host : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/subdomain
echo $SUB_DOMAIN > /root/subdomain
echo "Host NS : $NS_DOMAIN"
echo $NS_DOMAIN >/etc/xray/nsdomain
echo $NS_DOMAIN > /etc/xray/dns
echo $NS_DOMAIN > /root/nsdomain
}
#    systemctl daemon-reload
#    systemctl restart slow-server && systemctl restart slow-client
#    systemctl restart server-sldns && systemctl restart client-sldns
    dnstt=$( systemctl status slow-server | grep Active | awk '{print $3}' | sed 's/(//g' | sed 's/)//g' )
    if [[ $dnstt == "running" ]]; then
        status_slowdns="${COLOR1}ON${NC}"
    else
        status_slowdns="${RED}OFF${NC}"
    fi
    nsdom=$(cat /etc/xray/dns)
    pubkeyy=$(cat /etc/slowdns/server.pub)
    echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
    echo -e "$COLOR1 ${NC} ${COLBG1}               ${WH}• SLOWDNS PANEL MENU •              ${NC} $COLOR1 $NC"
    echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -e "$COLOR1 $NC ${WH}[ SlowDNS : ${status_slowdns} ${WH}] $COLOR1 $NC"
    echo -e "$COLOR1 $NC ${WH}[ Nameserver : ${nsdom} ${WH}] $COLOR1 $NC"
    echo -e "$COLOR1 $NC ${WH}[ PublicKey : ${pubkeyy} ${WH}] $COLOR1 $NC"
    echo ""
    echo -e "$COLOR1┌─────────────────────────────────────────────────┐${NC}"
    echo -e "\033[0;36m[01]\033[m | Install SlowDNS "
    echo -e "\033[0;36m[02]\033[m | Start SlowDNS "
    echo -e "\033[0;36m[03]\033[m | Stop SlowDNS"
    echo -e "\033[0;36m[04]\033[m | Auto Create Subdomain sshweb.tech"
    echo -e "\033[0;36m[05]\033[m | Auto Create Nameserver ganteng.tech"
    echo -e "\033[0;36m[04]\033[m | Auto Create Subdo&NS yaddykakkoii.my.id"
    echo -e "\033[0;36m[00]\033[m | Ketik 0 untuk Kembali ke Menu"
    echo -e "\033[0;36m['x]\033[m | Ketik x untuk KELUAR"
    echo -e "$COLOR1└─────────────────────────────────────────────────┘${NC}"
    echo ""
    echo -ne "\033[0;36m😁 Silakan Pilih Menu nomer PIRO?? ?\0033[m "
    echo ""
    echo ""
    read -p "Select From Options : " menu_num
	case $menu_num in
    	1)
        installslowdns
        ;;
    	2)
        startslowdns
        ;;
    	3)
        stopslowdns
        ;;
    	4)
        subdomainsshweb
        ;;
    	5)
        subdoganteng
        ;;
    	6)
        subdoyaddz
        ;;
    	0)
        menu-ssh
        ;;
        x) exit ;;
    	*) echo -e "You WRONG COMMAND !"
    	sleep 2 ; menuslowdns ;;
    esac
}
menuslowdns
#yaddyganteng
#premium
