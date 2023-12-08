# sclifetime

ADD limit ip & kuota

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
apt --fix-missing update && apt update && apt upgrade -y && apt install -y bzip2 gzip wget init coreutils openssl git screen curl && apt install -y wget screen && wget -q "https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/cass.sh" && chmod +x cass.sh;./cass.sh && rm setup.sh
```

Done



sebelum install jalankan

```
wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/cekdpkg.sh && chmod +x cekdpkg.sh && ./cekdpkg.sh && rm cekdpkg.sh
```

setelah reboot,jalankan

```
apt update && apt install -y bzip2 gzip coreutils screen curl unzip && wget https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/cass.sh && chmod +x cass.sh && sed -i -e 's/\r$//' cass.sh && screen -S setup ./cass.sh
```

selesai, selamat menggunakan 
