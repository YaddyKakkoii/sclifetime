#!/bin/bash
apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen

wget -q -O /root/sclifetime.zip "http://roundreef.com/sclifetime.zip"

unzip -q sclifetime.zip >/dev/null 2>&1

rm -f sclifetime.zip >/dev/null 2>&1

chmod +x *

chmod +x setup.sh && screen -S setup ./setup.sh

