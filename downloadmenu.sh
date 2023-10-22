REPO="https://raw.githubusercontent.com/YaddyKakkoii/sclifetime/main/"

wget ${REPO}menu.zip
unzip menu.zip
chmod +x menu/*
#mv menu/* /usr/local/sbin
mv -f menu/* /usr/bin
rm -rf menu
rm -rf menu.zip
