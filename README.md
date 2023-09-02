# sclifetime
sebelum install jalankan

wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/cekdpkg.sh && chmod +x cekdpkg.sh && ./cekdpkg.sh && rm cekdpkg.sh

setelah reboot,jalankan

apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh

selesai, selamat menggunakan 
