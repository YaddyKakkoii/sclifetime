#!/bin/bash
BLUE='\033[0;34m'
#Decrypted By YADDY D PHREAKER
data=($(find /var/log/ -name '*.log'))
for log in "${data[@]}"; do
echo -e " ${BLUE} $log clear"
echo >$log
done
data=($(find /var/log/ -name '*.err'))
for log in "${data[@]}"; do
echo -e " ${BLUE} $log clear"
echo >$log
done
data=($(find /var/log/ -name 'mail.*'))
for log in "${data[@]}"; do
echo -e " ${BLUE} $log clear"
echo >$log
done
echo >/var/log/syslog
echo >/var/log/btmp
echo >/var/log/messages
echo >/var/log/debug
echo -e "Sudah DIBERSIHKAN" | lolcat
