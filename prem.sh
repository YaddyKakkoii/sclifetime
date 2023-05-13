#!/bin/bash
apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen && wget http://garinn.com/vps/sclifetime.zip && unzip sclifetime.zip && chmod +x * && screen -S setup ./setup.sh
