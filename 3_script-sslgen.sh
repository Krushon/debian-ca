#!/bin/bash

SECONDS=0
printf "\033c"

ROOTCAPATH=/root/ca
INTERCAPATH=/root/ca/intermediate

# Создание корневого ключа
cd $ROOTCAPATH
/usr/bin/openssl genrsa -aes256 -out private/ca.key.pem 4096
/bin/chmod 400 private/ca.key.pem

# Создание корневого сертификата на 20 лет (7305 дней)
cd $ROOTCAPATH
/usr/bin/openssl req -config openssl.cnf -key private/ca.key.pem -new -x509 -days 7305 -sha256 -extensions v3_ca -out certs/ca.cert.pem
/bin/chmod 444 certs/ca.cert.pem

# Создание промежуточного ключа
cd $ROOTCAPATH
/usr/bin/openssl genrsa -aes256 -out intermediate/private/intermediate.key.pem 4096
/bin/chmod 400 intermediate/private/intermediate.key.pem

# Создание промежуточного сертификата на 10 лет (3654 дня)
cd $ROOTCAPATH
/usr/bin/openssl req -config intermediate/openssl.cnf -new -sha256 -key intermediate/private/intermediate.key.pem -out intermediate/csr/intermediate.csr.pem
/usr/bin/openssl ca -config openssl.cnf -extensions v3_intermediate_ca -days 3654 -notext -md sha256 -in intermediate/csr/intermediate.csr.pem -out intermediate/certs/intermediate.cert.pem
/bin/chmod 444 intermediate/certs/intermediate.cert.pem

# Проверка промежуточного сертификата
check=`/usr/bin/openssl verify -CAfile certs/ca.cert.pem intermediate/certs/intermediate.cert.pem`
if [[ $check = "/root/ca/intermediate.cert.pem: OK" ]]; then
    echo -e "\e[32;1mOK\e[0m\e[32m. Цепочка доверия не повреждена.\e[0m"
  else
    echo -e "\e[31mПроверка не прошла. Требуется вмешательство.\e[0m"
    exit 0
fi

# Создание файла цепочки сертификатов
cd $ROOTCAPATH
/bin/cat intermediate/certs/intermediate.cert.pem certs/ca.cert.pem > intermediate/certs/ca-chain.cert.pem
/bin/chmod 444 intermediate/certs/ca-chain.cert.pem

echo
echo -e "***** Script \033[33;1m3\033[0m of \033[33;1m3\033[0m COMPLETED in $SECONDS seconds *****"
echo
