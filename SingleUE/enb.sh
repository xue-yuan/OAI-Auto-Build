#!/bin/bash
# eNB Installation

# LAC, MCC, MNC
echo "$1 $2 $3"

echo -e "\033[46;37m*** Cloning eNB ***\033[0m"

# git clone https://gitlab.eurecom.fr/oai/openairinterface5g.git ~/openairinterface5g

echo -e "\033[46;37m*** Checkout Version ***\033[0m"

# cd ~/openairinterface5g
# git checkout ae0494
# git pull origin ae0494

echo -e "\033[46;37m*** Building eNB ***\033[0m"

# ~/openairinterface5g/cmake_targets/build_oai -I --eNB -x --install-system-files -w USRP

# echo -e "\033[47;36m*** Configuring ***\033[0m\n"

# sudo sed -i "s/tracking_area_code.*\"1\";/tracking_area_code = \"$1\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/mobile_country_code.*\"208\";/mobile_country_code = \"$2\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/mobile_network_code.*\"93\";/mobile_network_code = \"$3\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf

# sudo sed -i "s/eutra_band.*7;/eutra_band = 3;/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/downlink_frequency.*2685000000L;/downlink_frequency = 1833000000L;/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/uplink_frequency_offset.*-120000000;/uplink_frequency_offset                               = -95000000;/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf

# sudo sed -i "s/ipv4.*\"127.0.0.3\";/ipv4 = \"127.0.1.1\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/ENB_IPV4_ADDRESS_FOR_S1_MME.*\"127.0.0.2\/24\";/ENB_IPV4_ADDRESS_FOR_S1_MME = \"127.0.1.2\/8\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf
# sudo sed -i "s/ENB_IPV4_ADDRESS_FOR_S1U.*\"127.0.0.5\/24\";/ENB_IPV4_ADDRESS_FOR_S1U = \"127.0.2.2\/24\";/g" ~/openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf

echo -e "\033[47;36m*** Running eNB ***\033[0m\n"

sudo -E ~/openairinterface5g/cmake_targets/lte_build_oai/build/lte-softmodem -O ./openairinterface5g/targets/PROJECTS/GENERIC-LTE-EPC/CONF/enb.band7.tm1.50PRB.usrpb210.conf

