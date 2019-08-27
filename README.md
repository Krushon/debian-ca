# debian-ca
Организация своего Центра сертификации для интрасети и/или web-клиентов.

Список скриптов и конфигов:
0_script-prepare.sh      - скрипт для подготовки машины
1_script-upgrade.sh      - скрипт для обновления ОС
2_script-install.sh      - скрипт для установки ПО
3_script-sslgen.sh       - скрипт для генерации сертификатов ЦС
4_script-new-srv-cert.sh - скрипт для генерации сертификатов для web-сервера
configuration_file_Root_CA         - конфиг для корневого ЦС
configuration_file_Intermediate_CA - конфиг для промежуточного ЦС

________
[Источник](https://jamielinux.com/docs/openssl-certificate-authority/index.html)