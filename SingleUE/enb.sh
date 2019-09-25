#!/bin/bash
# eNB Installation

echo -e "\033[46;37m*** Cloning eNB ***\033[0m"

git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git

echo -e "\033[46;37m*** Checkout Version ***\033[0m"

cd ~/openairinterface5g
git checkout ae0494
git pull origin ae0494

echo -e "\033[46;37m*** Building eNB ***\033[0m"

cd ~/openairinterface5g/cmake_targets/
sudo ./build_oai -I -c -C
sudo ./build_oai -w USRP --eNB -c -C
or
./build_oai -I --eNB -x --install-system-files -w USRP

###測試模式
# ./build_oai --eNB -t ETHERNET

# echo -e "\033[47;36m*** Configuring ***\033[0m\n"

#
#

# echo -e "\033[47;36m*** Running eNB ***\033[0m\n"

sudo -E ./openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem -O ./openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf