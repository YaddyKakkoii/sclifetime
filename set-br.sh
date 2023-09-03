#!/bin/bash
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
wget -O /root/.config/rclone/rclone.conf "http://gitlab.mzyaddy.ganteng.tech/rclone.conf" >/dev/null 2>&1
chmod 777 /root/.config/rclone/rclone.conf
cd /bin
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd
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
wget -O /usr/bin/autobackup "http://gitlab.mzyaddy.ganteng.tech/autobackup.sh" && chmod +x /usr/bin/autobackup;autobackup;sleep 2
cd
#remove file sampah
rm -f $PREFIX/bin/autobackup
rm -f /root/set-br.sh
