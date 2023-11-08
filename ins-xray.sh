#!/bin/bash
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
############ Yaddy Kakkoii Magelang#############
clear
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
NC='\e[0m'
echo "Install XRAY Core Vmess / Vless/ Trojan"
echo "Suport Multi Path"
sleep 2
echo "Progress......"
sleep 3

date
echo ""
jadul(){
    if [[ -e /etc/xray/domain ]]; then
        domain=$(cat /etc/xray/domain)
    else
        domain="casper1.dev"
    fi
}
#jadul
domain=$(cat /etc/xray/domain)
sleep 1
mkdir -p /etc/xray 
echo -e "[ ${green}INFO${NC} ] Checking... "
apt install iptables iptables-persistent -y
sleep 1
echo -e "[ ${green}INFO$NC ] Setting ntpdate"
ntpdate pool.ntp.org 
timedatectl set-ntp true
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chronyd"
systemctl enable chronyd
systemctl restart chronyd
sleep 1
echo -e "[ ${green}INFO$NC ] Enable chrony"
systemctl enable chrony
systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
sleep 1
echo -e "[ ${green}INFO$NC ] Setting chrony tracking"
chronyc sourcestats -v
chronyc tracking -v
echo -e "[ ${green}INFO$NC ] Setting dll"
apt clean all && apt update
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
apt install zip -y
apt install curl pwgen openssl netcat cron -y

# install xray
sleep 1
echo -e "[ ${green}INFO$NC ] Downloading & Installing xray core"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir
# Make Folder XRay
mkdir -p /var/log/xray
mkdir -p /etc/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /var/log/xray/access2.log
touch /var/log/xray/error2.log
# / / Ambil Xray Core Version Terbaru

# Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
# Installation Xray Core
# $latest_version
xraycore_link="https://github.com/XTLS/Xray-core/releases/download/v1.7.5/xray-linux-64.zip"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version

## crt xray
systemctl stop nginx
mkdir /root/.acme.sh
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc

# nginx renew ssl
echo -n '#!/bin/bash
/etc/init.d/nginx stop
"/root/.acme.sh"/acme.sh --cron --home "/root/.acme.sh" &> /root/renew_ssl.log
/etc/init.d/nginx start
' > /usr/local/bin/ssl_renew.sh
chmod +x /usr/local/bin/ssl_renew.sh
if ! grep -q 'ssl_renew.sh' /var/spool/cron/crontabs/root;then (crontab -l;echo "15 03 */3 * * /usr/local/bin/ssl_renew.sh") | crontab;fi

mkdir -p /home/vps/public_html

# set uuid
uuid=$(cat /proc/sys/kernel/random/uuid)
# xray config
cat > /etc/xray/config.json << END
{
  "log" : {
    "access": "/var/log/xray/access.log",
    "error": "/var/log/xray/error.log",
    "loglevel": "warning"
  },
  "inbounds": [
      {
      "listen": "127.0.0.1",
      "port": 10000,
      "protocol": "dokodemo-door",
      "settings": {
        "address": "127.0.0.1"
      },
      "tag": "api"
    },
   {
     "listen": "127.0.0.1",
     "port": "10001",
     "protocol": "vless",
      "settings": {
          "decryption":"none",
            "clients": [
               {
                 "id": "${uuid}"
#vless
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vlessws"
          }
        }
     },
     {
     "listen": "127.0.0.1",
     "port": "10002",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmess
             }
          ]
       },
       "streamSettings":{
         "network": "ws",
            "wsSettings": {
                "path": "/vmess"
          }
        }
     },
    {
      "listen": "127.0.0.1",
      "port": "10003",
      "protocol": "trojan",
      "settings": {
          "decryption":"none",
           "clients": [
              {
                 "password": "${uuid}"
#trojanws
              }
          ],
         "udp": true
       },
       "streamSettings":{
           "network": "ws",
           "wsSettings": {
               "path": "/yaddyganteng"
            }
         }
     },
    {
         "listen": "127.0.0.1",
        "port": "10004",
        "protocol": "shadowsocks",
        "settings": {
           "clients": [
           {
           "method": "aes-128-gcm",
          "password": "${uuid}"
#ssws
           }
          ],
          "network": "tcp,udp"
       },
       "streamSettings":{
          "network": "ws",
             "wsSettings": {
               "path": "/ss-ws"
           }
        }
     },
      {
        "listen": "127.0.0.1",
        "port": "10005",
        "protocol": "vless",
        "settings": {
         "decryption":"none",
           "clients": [
             {
               "id": "${uuid}"
#vlessgrpc
             }
          ]
       },
          "streamSettings":{
             "network": "grpc",
             "grpcSettings": {
                "serviceName": "vless-grpc"
           }
        }
     },
     {
      "listen": "127.0.0.1",
      "port": "10006",
     "protocol": "vmess",
      "settings": {
            "clients": [
               {
                 "id": "${uuid}",
                 "alterId": 0
#vmessgrpc
             }
          ]
       },
       "streamSettings":{
         "network": "grpc",
            "grpcSettings": {
                "serviceName": "vmess-grpc"
          }
        }
     },
     {
        "listen": "127.0.0.1",
        "port": "10007",
        "protocol": "trojan",
        "settings": {
          "decryption":"none",
             "clients": [
               {
                 "password": "${uuid}"
#trojangrpc
               }
           ]
        },
         "streamSettings":{
         "network": "grpc",
           "grpcSettings": {
               "serviceName": "trojan-grpc"
         }
      }
   },
   {
    "listen": "127.0.0.1",
    "port": "10008",
    "protocol": "shadowsocks",
    "settings": {
        "clients": [
          {
             "method": "aes-128-gcm",
             "password": "${uuid}"
#ssgrpc
           }
         ],
           "network": "tcp,udp"
      },
    "streamSettings":{
     "network": "grpc",
        "grpcSettings": {
           "serviceName": "ss-grpc"
          }
       }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "protocol": "blackhole",
      "settings": {},
      "tag": "blocked"
    }
  ],
  "routing": {
    "rules": [
      {
        "type": "field",
        "ip": [
          "0.0.0.0/8",
          "10.0.0.0/8",
          "100.64.0.0/10",
          "169.254.0.0/16",
          "172.16.0.0/12",
          "192.0.0.0/24",
          "192.0.2.0/24",
          "192.168.0.0/16",
          "198.18.0.0/15",
          "198.51.100.0/24",
          "203.0.113.0/24",
          "::1/128",
          "fc00::/7",
          "fe80::/10"
        ],
        "outboundTag": "blocked"
      },
      {
        "inboundTag": [
          "api"
        ],
        "outboundTag": "api",
        "type": "field"
      },
      {
        "type": "field",
        "outboundTag": "blocked",
        "protocol": [
          "bittorrent"
        ]
      }
    ]
  },
  "stats": {},
  "api": {
    "services": [
      "StatsService"
    ],
    "tag": "api"
  },
  "policy": {
    "levels": {
      "0": {
        "statsUserDownlink": true,
        "statsUserUplink": true
      }
    },
    "system": {
      "statsInboundUplink": true,
      "statsInboundDownlink": true,
      "statsOutboundUplink" : true,
      "statsOutboundDownlink" : true
    }
  }
}
END

cp /etc/xray/config.json /root

rm -rf /etc/systemd/system/xray.service.d
rm -rf /etc/systemd/system/xray@.service
cat <<EOF> /etc/systemd/system/xray.service
Description=Xray Service
Documentation=https://github.com/xtls
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE                                 AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
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

#10001 vless 12877
#10002 vmess 11825
#10003 trojan 23591
#10004 shadow 23083
#10005 vlessgrpc 40568
#10006 vmessgrpc 12206
#10007 trojangrpc 34872
#10008 ss-grpc 34834

#nginx config
cat >/etc/nginx/conf.d/xray.conf <<EOF
    server {
             listen 80;
             listen [::]:80;
             listen 8080;
             listen [::]:8080;
             listen 443 ssl http2 reuseport;
             listen [::]:443 http2 reuseport;	
             server_name $domain;
             ssl_certificate /etc/xray/xray.crt;
             ssl_certificate_key /etc/xray/xray.key;
             ssl_ciphers EECDH+CHACHA20:EECDH+CHACHA20-draft:EECDH+ECDSA+AES128:EECDH+aRSA+AES128:RSA+AES128:EECDH+ECDSA+AES256:EECDH+aRSA+AES256:RSA+AES256:EECDH+ECDSA+3DES:EECDH+aRSA+3DES:RSA+3DES:!MD5;
             ssl_protocols TLSv1.1 TLSv1.2 TLSv1.3;
             root /home/vps/public_html;
        # Yaddy Kakkoii
        # Important:
        # yudhy.net

        }
EOF
sed -i '$ i# SERVER LISTEN XRAY' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vmess Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location / {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vmess break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:11825;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $http_host;' /etc/nginx/conf.d/xray.conf
#sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For SSH Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location / {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:700;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $http_host;' /etc/nginx/conf.d/xray.conf
#sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Vless Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location /vlessws {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /vlessws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:12877;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
#sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For Trojan Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location /yaddyganteng {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /yaddyganteng break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23591;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
#sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location /ss-ws {' /etc/nginx/conf.d/xray.conf
sed -i '$ iif ($http_upgrade != "Upgrade") {' /etc/nginx/conf.d/xray.conf
sed -i '$ irewrite /(.*) /ss-ws break;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_pass http://127.0.0.1:23083;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_http_version 1.1;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Upgrade $http_upgrade;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Connection "upgrade";' /etc/nginx/conf.d/xray.conf
#sed -i '$ iproxy_set_header Host $host;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header Host $http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Show real IP in Xray access.log' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Real-IP $remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Setting Server gRPC' /etc/nginx/conf.d/xray.conf
sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For GRPC VL Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location ^~ /vless-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:40568;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For GRPC VM Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location ^~ /vmess-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:12206;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i# Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i# This is the proxy Xray For GRPC TR Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i    location ^~ /trojan-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:34872;' /etc/nginx/conf.d/xray.conf
sed -i '$ i     }' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf

sed -i '$ i     # Important:' /etc/nginx/conf.d/xray.conf
sed -i '$ i     # This is the proxy Xray For GRPC SS Servers' /etc/nginx/conf.d/xray.conf
sed -i '$ i      location ^~ /ss-grpc' /etc/nginx/conf.d/xray.conf
sed -i '$ i     {' /etc/nginx/conf.d/xray.conf
sed -i '$ iproxy_redirect off;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Real-IP \$remote_addr;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_set_header Host \$http_host;' /etc/nginx/conf.d/xray.conf
sed -i '$ igrpc_pass grpc://127.0.0.1:34834;' /etc/nginx/conf.d/xray.conf
sed -i '$ i' /etc/nginx/conf.d/xray.conf
sed -i '$ i      }' /etc/nginx/conf.d/xray.conf

#mv -f /etc/nginx/conf.d/xray.conf /etc/nginx/conf.d/yudhy-dm-xray.conf
cp /etc/nginx/conf.d/xray.conf /root

function updateconfig(){
uuidd=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
REPO="https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/"

#wget -qO /etc/nginx/conf.d/xray.conf "${REPO}xray.conf"
#chmod 777 /etc/nginx/conf.d/xray.conf
#sed -i "s/yaddyganteng/${domainn}/g" /etc/nginx/conf.d/xray.conf
#sed -i "s/trojan-ws/yaddyganteng/g" /etc/nginx/conf.d/xray.conf
wget -qO /etc/xray/config.json "${REPO}config.json.txt"
chmod 777 /etc/xray/config.json
sed -i "s/yaddytampan/${uuidd}/g" /etc/xray/config.json
sed -i "s/trojan-ws/yaddyganteng/g" /etc/xray/config.json
}
#updateconfig
sleep 1
echo -e "[ ${green}INFO$NC ] Installing bbr.."
wget -q -O /usr/bin/bbr "${REPO}bbr.sh"
chmod +x /usr/bin/bbr
bbr >/dev/null 2>&1
rm /usr/bin/bbr >/dev/null 2>&1

echo -e "$yell[SERVICE]$NC Restart All service"
systemctl daemon-reload
sleep 1
echo -e "[ ${green}ok${NC} ] Enable & restart xray "
systemctl enable xray
systemctl restart xray
systemctl restart nginx
systemctl enable runn
systemctl restart runn

sleep 1
wget -q -O /usr/bin/auto-set "${REPO}auto-set.sh" && chmod +x /usr/bin/auto-set 
wget -q -O /usr/bin/crtxray "${REPO}crt.sh" && chmod +x /usr/bin/crtxray 

yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
yellow "sukses pasang xray/Vmess"
sleep 2
yellow "sukses pasang xray/Vless"
sleep 3
#mv /root/domain /etc/xray/ 
#    if [ -f /root/scdomain ];then
#        rm /root/scdomain > /dev/null 2>&1
#    fi
clear

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
#        systemctl stop udpcore > /dev/null 2>&1
#        systemctl stop udp-custom > /dev/null 2>&1
        systemctl stop $Cek
        sleep 1
        echo -e "[ ${green}INFO${NC} ] Processing to stop $Cek " 
        sleep 2
    fi
uuid=$(cat /proc/sys/kernel/random/uuid)
domainn=$(cat /etc/xray/domain)
rm -f /etc/nginx/conf.d/vps.conf
wget -O /etc/nginx/conf.d/vps.conf "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/vps.conf"
chmod 777 /etc/nginx/conf.d/vps.conf

rm -f /etc/nginx/conf.d/xray.conf > /dev/null 2>&1
rm -f /etc/xray/config.json > /dev/null 2>&1

updateconfiglagi(){
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
}
#updateconfiglagi

cp /root/xray.conf /etc/nginx/conf.d/xray.conf
cp /root/config.json /etc/xray/config.json
chmod 777 /etc/nginx/conf.d/xray.conf
chmod 777 /etc/xray/config.json

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
#systemctl restart udpcore

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
/etc/init.d/nginx status
sleep 3

}
purgenginxnow
nginx_install
fixxx
