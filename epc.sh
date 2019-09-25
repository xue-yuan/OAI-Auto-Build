#!/bin/bash

# 網卡名稱, IP
echo "$1" "$2"

xdg-open https://bit.ly/2kqIuJs


echo -e "\033[46;37m*** Installing Prerequisite ***\033[0m"

sudo apt update
sudo apt install vim -y
sudo apt install openssh-server -y
sudo apt install git -y

echo -e "\033[46;37m*** Modifying hosts ***\033[0m"

sudo sed -i 's/127.0.1.1	labuser/127.0.1.1	labuser.openair4G.eur labuser\n127.0.1.1	hss.openair4G.eur hss/g' /etc/hosts

echo -e "\033[46;37m*** Cloning EPC ***\033[0m"

git clone https://gitlab.eurecom.fr/oai/openair-cn.git

echo -e "\033[46;37m*** Checkout Version ***\033[0m"

cd ~/openair-cn

git checkout openair-cn-llmec
git checkout 6cfc00
git fetch

echo -e "\033[46;37m*** Copying File ***\033[0m"

sudo mkdir /usr/local/etc/oai
sudo mkdir /usr/local/etc/oai/freeDiameter

sudo cp ~/openair-cn/etc/mme.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/hss.conf /usr/local/etc/oai
sudo cp ~/openair-cn/etc/spgw.conf /usr/local/etc/oai

sudo cp ~/openair-cn/etc/acl.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/hss_fd.conf /usr/local/etc/oai/freeDiameter
sudo cp ~/openair-cn/etc/mme_fd.conf /usr/local/etc/oai/freeDiameter

cd ~

echo -e "\033[46;37m*** Building HSS ***\033[0m"

~/openair-cn/scripts/build_hss -i

echo -e "\033[46;37m*** Compiling HSS ***\033[0m"

~/openair-cn/scripts/build_hss

echo -e "\033[46;37m*** Building MME ***\033[0m"

~/openair-cn/scripts/build_mme -i

echo -e "\033[46;37m*** Compiling MME  ***\033[0m"

~/openair-cn/scripts/build_mme

echo -e "\033[46;37m*** Building SPGW ***\033[0m"

~/openair-cn/scripts/build_spgw -i

echo -e "\033[46;37m*** Compiling SPGW ***\033[0m"

~/openair-cn/scripts/build_spgw

echo -e "\033[46;37m*** Configuring HSS ***\033[0m"

sudo sed -i 's/@MYSQL_user@/root/g' /usr/local/etc/oai/hss.conf
sudo sed -i 's/@MYSQL_pass@/linux/g' /usr/local/etc/oai/hss.conf
sudo sed -i 's/OPERATOR_key = "10/# OPERATOR_key = "10/g' /usr/local/etc/oai/hss.conf
sudo sed -i 's/#OPERATOR_key/OPERATOR_key/g' /usr/local/etc/oai/hss.conf

echo -e "\033[46;37m*** Configuring MME ***\033[0m"

sudo sed -i 's/MME_INTERFACE_NAME_FOR_S1_MME         = "eth0";/MME_INTERFACE_NAME_FOR_S1_MME         = "lo";/g' /usr/local/etc/oai/mme.conf
sudo sed -i 's/MME_IPV4_ADDRESS_FOR_S1_MME           = "192.168.11.17\/24";/MME_IPV4_ADDRESS_FOR_S1_MME           = "127.0.1.1\/8";/g' /usr/local/etc/oai/mme.conf
sudo sed -i 's/MME_IPV4_ADDRESS_FOR_S11_MME          = "127.0.11.1\/8";/MME_IPV4_ADDRESS_FOR_S11_MME          = "127.0.3.1\/8";/g' /usr/local/etc/oai/mme.conf
sudo sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.3.2\/8";/g' /usr/local/etc/oai/mme.conf

echo -e "\033[46;37m*** Configuring SPGW ***\033[0m"

sudo sed -i 's/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.11.2\/8";/SGW_IPV4_ADDRESS_FOR_S11                = "127.0.3.2\/8";/g' /usr/local/etc/oai/spgw.conf
sudo sed -i 's/SGW_INTERFACE_NAME_FOR_S1U_S12_S4_UP    = "eth0";/SGW_INTERFACE_NAME_FOR_S1U_S12_S4_UP    = "lo";/g' /usr/local/etc/oai/spgw.conf
sudo sed -i 's/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "192.168.11.17\/24";/SGW_IPV4_ADDRESS_FOR_S1U_S12_S4_UP      = "127.0.2.1\/8";/g' /usr/local/etc/oai/spgw.conf
sudo sed -i "s/PGW_INTERFACE_NAME_FOR_SGI            = \"eth3\";/PGW_INTERFACE_NAME_FOR_SGI            = \"$1\";/g" /usr/local/etc/oai/spgw.conf
sudo sed -i 's/PGW_MASQUERADE_SGI                    = "no";/PGW_MASQUERADE_SGI                    = "yes";/g' /usr/local/etc/oai/spgw.conf
sudo sed -i "s/\"172.16.0.0\/12\"/\"10.118.127.0\/24\"/g" /usr/local/etc/oai/spgw.conf

echo -e "\033[46;37m*** Modifying Certificate Argument ***\033[0m"

sudo sed -i 's/yang.openair4G.eur/labuser.openair4G.eur/g' /usr/local/etc/oai/freeDiameter/mme_fd.conf

echo -e "\033[46;37m*** Generating Certificate ***\033[0m"

sudo ~/openair-cn/scripts/check_hss_s6a_certificate /usr/local/etc/oai/freeDiameter hss.openair4G.eur
sudo ~/openair-cn/scripts/check_mme_s6a_certificate /usr/local/etc/oai/freeDiameter labuser.openair4G.eur

echo -e "\033[46;37m*** Setting MYSQL ***\033[0m"

mysql -u root -plinux << EOF
CREATE database oai_db;
quit
EOF

mysql -u root -plinux oai_db < ~/openair-cn/src/oai_hss/db/oai_db.sql

mysql -u root -plinux << EOF
use oai_db;
select * from apn;
insert into apn values ('1', 'oai.ipv4', 'IPv4');

select * from pgw;
update pgw set ipv4="$2" where id="3";

select * from mmeidentity;
update mmeidentity set mmehost="labuser.openair4G.eur" where idmmeidentity="1";
quit
EOF

echo -e "\033[47;36m*** Building Successful ***\nPlease Run the following scripts in separate bash.\033[0m\n"

# sudo ~/openair-cn/scripts/run_hss &
# sleep 1
# sudo ~/openair-cn/scripts/run_mme &
# sleep 1
# sudo ~/openair-cn/scripts/run_spgw &
# sleep 1

echo -e "\033[47;31msudo ~/openair-cn/scripts/run_hss\033[0m"
echo -e "\033[47;31msudo ~/openair-cn/scripts/run_mme\033[0m"
echo -e "\033[47;31msudo ~/openair-cn/scripts/run_spgw\033[0m"

exec bash
