# sclifetime
Fresh install:
Utk Debian:

```
apt update -y && apt upgrade -y && apt dist-upgrade -y && reboot
```

Untuk Ubuntu:

```
apt-get update && apt-get upgrade -y && apt dist-upgrade -y && update-grub && reboot
```


Setelah reboot, eksekusi skrip utama,

```
apt --fix-missing update && apt update && apt upgrade -y && apt install -y wget screen && wget -q "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/setup.sh" && chmod +x setup.sh;./setup.sh && rm setup.sh && echo "berhasil install "
```

Done

Bila nginx off , masuk menu , pilih purge . Selesai






cara lainn :


sebelum install jalankan

```
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/cekdpkg.sh && chmod +x cekdpkg.sh && ./cekdpkg.sh && rm cekdpkg.sh
```

setelah reboot,jalankan

```
apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/setup.sh && chmod +x setup.sh && sed -i -e 's/\r$//' setup.sh && screen -S setup ./setup.sh
```

selesai, selamat menggunakan 
