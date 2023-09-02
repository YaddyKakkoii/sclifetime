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
echo -e "[ ${green}INFO${NC} ] Preparing the install file"
function pasangpaketygdiperlukan(){
totet=`uname -r`
PAKET_YANG_DIPERLUKAN="linux-headers-${totet}"
PKG_OK=$(dpkg-query -W --showformat='${Status}\n' ${PAKET_YANG_DIPERLUKAN} | grep "install ok installed")
echo "Checking for ${PAKET_YANG_DIPERLUKAN}: ${PKG_OK} "
    if [ "" = "$PKG_OK" ]; then
        if [ -f "/usr/bin/apt-get" ];then
            isDebian=`cat /etc/issue|grep Debian`
            if [ "$isDebian" != "" ];then
                    apt update -y && apt upgrade -y && apt dist-upgrade -y && update-grub
            else
                    apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && update-grub
            fi
        fi
        sleep 2
        echo -e "[ ${yell}WARNING${NC} ] Mencoba untuk menginstal...."
        echo "No ${PAKET_YANG_DIPERLUKAN} . Setting up ${PAKET_YANG_DIPERLUKAN} ."
        sleep 3
        apt-get --yes install ${PAKET_YANG_DIPERLUKAN}
        apt-get update && apt-get upgrade -y && apt dist-upgrade -y && update-grub
        apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen

        echo ""
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] Jika Terjadi Error Anda Wajib melakukan ini: "
        sleep 1
        echo ""
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] 1. apt update -y"
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] 2. apt upgrade -y"
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] 3. apt dist-upgrade -y"
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] 4. reboot"
        sleep 1
        echo ""
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] Setelah Reboot"
        sleep 1
        echo -e "[ ${tyblue}NOTES${NC} ] Kemudian Jalankan Ulang script instalasi ini Lagi"
        echo -e "[ ${tyblue}NOTES${NC} ] Jika Kamu mengerti, Silakan Tekan enter Sekarang"
        read
    else
        echo -e "[ ${green}INFO${NC} ] Oke paket yang dibutuhkan Sudah terinstal"
        echo -e "[ ${tyblue}NOTES${NC} ] tap enter untuk melanjutkan"
        read
    fi
    if ! dpkg -s ${PAKET_YANG_DIPERLUKAN} >/dev/null 2>&1; then
        rm /root/setup.sh >/dev/null 2>&1
        exit
    else
        clear
    fi
}

pasangpaketygdiperlukan
echo "persiapan selesai.... otomatis reboot dalam 5 detik"
sleep 5
reboot
