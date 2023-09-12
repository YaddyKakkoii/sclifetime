#!/bin/bash
function addtema() {
if [ -f "/etc/yudhynetwork/theme/blue" ]; then
#echo "sudah ada tema, mulai proses over write"
rm -rf /etc/yudhynetwork/theme
mkdir -p /etc/yudhynetwork
mkdir -p /etc/yudhynetwork/theme
else
#echo "belum ada tema njuk create folder tema"
mkdir -p /etc/yudhynetwork
mkdir -p /etc/yudhynetwork/theme
fi
#THEME RED
cat <<EOF>> /etc/yudhynetwork/theme/red
BG : \E[40;1;41m
TEXT : \033[0;31m
EOF
#THEME BLUE
cat <<EOF>> /etc/yudhynetwork/theme/blue
BG : \E[40;1;44m
TEXT : \033[0;34m
EOF
#THEME GREEN
cat <<EOF>> /etc/yudhynetwork/theme/green
BG : \E[40;1;42m
TEXT : \033[0;32m
EOF
#THEME YELLOW
cat <<EOF>> /etc/yudhynetwork/theme/yellow
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME MAGENTA
cat <<EOF>> /etc/yudhynetwork/theme/magenta
BG : \E[40;1;43m
TEXT : \033[0;33m
EOF
#THEME CYAN
cat <<EOF>> /etc/yudhynetwork/theme/cyan
BG : \E[40;1;46m
TEXT : \033[0;36m
EOF
#THEME CONFIG
cat <<EOF>> /etc/yudhynetwork/theme/color.conf
blue
EOF
}
function fixtema(){
    addtema
    if [ -f "/etc/yudhynetwork/theme/blue" ]; then
        #echo ada tema Yudhi default
        rm -rf /etc/yaddykakkoii

        if [ -f "/etc/yaddykakkoii/tema/blue" ]; then
            clear
            #echo ada tema yaddy.....
        else
            #echo ga ada tema yaddy...
            mkdir -p /etc/ssnvpn

            mkdir -p /etc/yaddykakkoii
            mkdir -p /etc/yaddykakkoii/theme
            mkdir -p /etc/yaddykakkoii/tema
            cp -fr /etc/yudhynetwork/theme/* /etc/yaddykakkoii/theme
        fi
    else
        #echo ga ada tema Yudhy default....
        clear
    fi
}
#hapus pagar bila tema error
fixtema
