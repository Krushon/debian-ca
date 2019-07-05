#!/bin/bash
SECONDS=0
printf "\033c"

# Устанавливаем ПО
apt-get update
apt-get install mc ntpdate ntp net-tools -y
apt-get autoclean && apt-get clean

# вместо pool.ntp.org можно указать свой сервер точного времени
/etc/init.d/ntp stop && ntpdate pool.ntp.org && /etc/init.d/ntp start

# Изменяем временную зону
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

# Готовимся к генерации сертификатов
ROOTCAPATH=/root/ca
INTERCAPATH=/root/ca/intermediate

mkdir /root/ca
cd $ROOTCAPATH
mkdir certs crl newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
mv /root/configuration_file_Root_CA /root/ca/openssl.cnf


mkdir /root/ca/intermediate
cd $INTERCAPATH
mkdir certs crl csr newcerts private
chmod 700 private
touch index.txt
echo 1000 > serial
echo 1000 > crlnumber
mv /root/configuration_file_Intermediate_CA /root/ca/intermediate/openssl.cnf

echo
echo -e "***** Script \033[33;1m2\033[0m of \033[33;1m3\033[0m COMPLETED in $SECONDS seconds *****"
echo
