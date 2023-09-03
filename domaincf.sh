#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
clear
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
clear
apt install jq curl -y
function subdomainsshweb() {
#SUB=microsoft.azure
#DOMAIN=ganteng.tech DOMAIN=yaddykakkoii.my.id #DOMAIN=sshweb.tech
echo "DOMAIN UTAMA ADALAH sshweb.tech"
echo "~~~~~~ petunjuk tentang custom subdomain ~~~~~~~~~"
echo "JIKA KAMU INPUT KATA: test ,maka hasilnya adalah test.sshweb.tech"
echo "JIKA KAMU INPUT KATA: custom ,maka hasilnya adalah custom.sshweb.tech"
echo "JIKA KAMU INPUT KATA: ainzoverlord ,maka hasilnya adalah ainzoverlord.sshweb.tech"
echo "JIKA KAMU INPUT KATA: sg3 ,maka hasilnya adalah sg3.sshweb.tech"
echo "JIKA KAMU INPUT KATA: memekpink ,maka hasilnya adalah memekpink.sshweb.tech"
echo ""
read -rp "silakan INPUT custom subdomain kamu : " -e SUB
echo ""
MYIP=$(wget -qO- icanhazip.com);
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
DOMAIN=sshweb.tech
SUB_DOMAIN=${SUB}.${DOMAIN}
NS_DOMAIN=ns.${SUB_DOMAIN}
echo "DOMAIN kamu adalah : ${SUB_DOMAIN}"
sleep 3
echo "IP=${SUB_DOMAIN}" > /var/lib/yaddykakkoii/ipvps.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS RECORD (DomainNameSystem) for ${SUB_DOMAIN} "
sleep 2
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
# update nameserver mu
echo "Updating NS RECORD (NameServer) for ${NS_DOMAIN} "
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
echo "DOMAIN KAMU : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/domain
echo "NAMESERVER KAMU : $NS_DOMAIN"
echo $NS_DOMAIN > /etc/xray/nsdomain
echo $NS_DOMAIN > /etc/xray/dns
sleep 3
cd
}

function randomsubdomain() {
#SUB=$(</dev/urandom tr -dc a-z0-9 | head -c5)
MYIP=$(wget -qO- icanhazip.com);
CF_ID=yadicakepp@gmail.com
CF_KEY=b22d286c2d7f6d3e5073325dd18b76ca4ddb2
SUB=$(</dev/urandom tr -dc a-z0-9 | head -c3)
DOMAIN=yaddykakkoii.my.id
SUB_DOMAIN=tensai.${SUB}.${DOMAIN}
NS_DOMAIN=ns.${SUB_DOMAIN}
echo "DOMAIN kamu adalah : ${SUB_DOMAIN}"
sleep 3
echo "IP=${SUB_DOMAIN}" > /var/lib/yaddykakkoii/ipvps.conf
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
# update domain vps mu
echo "Updating DNS RECORD (DomainNameSystem) for ${SUB_DOMAIN} "
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
# update nameserver mu
echo "Updating NS RECORD (NameServer) for ${NS_DOMAIN} "
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
echo "DOMAIN KAMU : $SUB_DOMAIN"
echo $SUB_DOMAIN > /etc/xray/domain
echo "NAMESERVER KAMU : $NS_DOMAIN"
echo $NS_DOMAIN > /etc/xray/nsdomain
sleep 3
cd
}

function cekdomain(){
clear
currentdomain=$(cat /etc/xray/domain)
    if [ -f "/etc/xray/domain" ]; then
        echo "Domainmu saat ini adalah ${currentdomain} "
    else
        echo "Belum ada domain terpasang di vps ini "
    fi
yellow "Add Domain for vmess/vless/trojan dll"
echo " "
echo -e "\e[1;32m════════════════════════════════════════════════════════════\e[0m"
echo ""
echo "jika kamu sudah punya domain sendiri, pilih nomer 1"
echo "jika kamu mau nebeng domain ku ,secara custom , pilih nomer 2"
echo "jika ingin batal , skip , atau gak jadi pointing domain, pilih nomer 3"
echo "jika kamu mau nebeng domain ku ,dengan nama acak, pilih selain nomer 1 2 3 atau tekan enter"
echo ""
echo -e "   .----------------------------------."
echo -e "   |\e[1;32mPlease select a domain type below \e[0m|"
echo -e "   '----------------------------------'"
echo -e "     \e[1;32m1)\e[0m Enter your Subdomain"
echo -e "     \e[1;32m2)\e[0m Use a custom Subdomain"
echo -e "     \e[1;32m3)\e[0m Skip , Saya tidak ingin mengganti Subdomain yg sekarang"
echo -e "   ------------------------------------"
read -p "   Please select numbers 1-2 or Any Button(Random) : " host
echo ""
    if [[ $host == "1" ]]; then
        read -rp "Input DOMAIN Kamu : " -e domainmu
        if [ -z ${domainmu} ]; then
            echo -e " Anda belum memasukkan domain! Then a random domain will be created"
            randomsubdomain
        else
	        echo "$domainmu" > /etc/xray/domain
            echo "IP=$domainmu" > /var/lib/yaddykakkoii/ipvps.conf
        fi
        clear
    elif [[ $host == "2" ]]; then
        subdomainsshweb
        clear
    elif [[ $host == "3" ]]; then
        echo " skipp gaess "
        clear
    else
        echo -e "Random Subdomain/Domain is used"
        sleep 3
        randomsubdomain
        clear
    fi
}
cekdomain
