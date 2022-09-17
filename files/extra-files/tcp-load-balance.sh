cd /opt/
mkdir /opt/balance-tool
cd /opt/balance-tool
wget https://download.inlab.net/Balance/3.57/balance-3.57.tar
wget https://download.inlab.net/Balance/3.57/balance.pdf
tar -xvf balance-3.57.tar
cd -
cd /opt/balance-tool/balance-3.57
make
make install 2>/dev/null
cd -

