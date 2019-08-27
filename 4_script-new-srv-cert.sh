#!/bin/bash
# Создание криптографической пары для web-сервера
SECONDS=0
printf "\033c"

echo "Enter the \"webservername\" (for example: www.example.com)"
read webservername

ROOTCAPATH=/root/ca

# Создание ключа
cd $ROOTCAPATH
/usr/bin/openssl genrsa -aes256 -out intermediate/private/$webservername.key.pem 2048
/bin/chmod 400 intermediate/private/$webservername.key.pem

# Создание сертификата
## Для серверных сертификатов, Общее Имя (Common Name) должно быть полным доменным именем ##(fully qualified domain name — FQDN)
## (к примеру, www.example.com), в то время как для клиентского сертификата оно должно быть любым уникальным идентификатором
## (к примеру, e-mail адресом). Common Name не может быть таким же, как любой корневой или промежуточный сертификат.
cd $ROOTCAPATH
/usr/bin/openssl req -config intermediate/openssl.cnf -key intermediate/private/$webservername.key.pem -new -sha256 -out intermediate/csr/$webservername.csr.pem
/usr/bin/openssl ca -config intermediate/openssl.cnf -extensions server_cert -days 375 -notext -md sha256 -in intermediate/csr/$webservername.csr.pem -out intermediate/certs/$webservername.cert.pem
/bin/chmod 444 intermediate/certs/$webservername.cert.pem

# Проверка цепочки сертификатов
cd $ROOTCAPATH
check=`/usr/bin/openssl verify -CAfile intermediate/certs/ca-chain.cert.pem intermediate/certs/$webservername.cert.pem`
if [[ $check = "intermediate/certs/$webservername.cert.pem: OK" ]]; then
    echo -e "\e[32;1mOK\e[0m\e[32m. Сертификат имеет действенную цепочку доверия.\e[0m"
  else
    echo -e "\e[31mПроверка не прошла. Требуется вмешательство.\e[0m"
    exit 0
fi

# Подготовка комплекта сертификатов и ключа для копирования на web-сервер
cd $ROOTCAPATH
/bin/cp -p /root/ca/intermediate/certs/ca-chain.cert.pem /root
/bin/cp -p /root/ca/intermediate/certs/$webservername.cert.pem /root
/bin/cp -p /root/ca/intermediate/private/$webservername.key.pem /root
/bin/tar -cpf $webservername.tar /root/*.pem
/bin/rm /root/*.pem
echo
echo "Сертификаты для $webservername подготовлены и упакованы в архив /root/ca/$webservername.tar."
echo

echo
echo -e "***** Script \033[33;1m3\033[0m of \033[33;1m3\033[0m COMPLETED in $SECONDS seconds *****"
echo
