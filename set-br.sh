#!/bin/bash
REPO="https://raw.githubusercontent.com/YaddyKakkoii/casper/main/"
REPOX="https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/"
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
MYIP=$(wget -qO- ipinfo.io/ip);
curl https://rclone.org/install.sh | bash
apt install rclone -y
printf "q\n" | rclone config
wget -O /root/.config/rclone/rclone.conf "${REPOX}rclone.conf" >/dev/null 2>&1
chmod 777 /root/.config/rclone/rclone.conf
cd /bin
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd /root
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user backupsmtp93@gmail.com
from backupsmtp93@gmail.com
password sdallofkbpuhbtoa 
logfile ~/.msmtp.log

EOF
chown -R www-data:www-data /etc/msmtprc
echo "please wait until prosess finished...."
wget -qO /usr/bin/autobackup "${REPO}autobackup.sh" && chmod +x /usr/bin/autobackup;autobackup > /dev/null 2>&1
cd /root
mv -f $PREFIX/bin/autobackup /usr/sbin/ifmid

if [ ! -f "/etc/cron.d/cleaner" ]; then
cat> /etc/cron.d/cleaner << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/2 * * * * root /usr/bin/cleaner
END
fi

if [ ! -f "/etc/cron.d/xp_otm" ]; then
cat> /etc/cron.d/xp_otm << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 0 * * * root /usr/bin/xp
END
fi
cat > /home/re_otm <<-END
7
END

if [ ! -f "/etc/cron.d/bckp_otm" ]; then
cat> /etc/cron.d/bckp_otm << END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 5 * * * root /usr/bin/bottelegram
END
fi

if [ ! -f "etc/systemd/system/autocpu.service" ]; then
cat> /etc/systemd/system/autocpu.service << END
[Unit]
Description=Autocpu
After=network.target

[Service]
ExecStart=/usr/bin/autocpu
Restart=always
RestartSec=30

[Install]
WantedBy=default.target
END

fi

service cron restart > /dev/null 2>&1
systemctl enable autocpu
systemctl restart autocpu
    
rm -f /root/set-br.sh
rm -f /etc/cron.d/autocpu

