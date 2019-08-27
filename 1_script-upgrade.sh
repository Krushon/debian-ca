#!/bin/bash
# Проверяем версию дистрибутива debian.
SECONDS=0
printf "\033c"
ver=`cat /etc/*-release | grep VERSION_ID`
#  Если версия 8, то обновляем до 10
if [ $ver = 'VERSION_ID="8"' ]
  then
    echo "OS version is 8. Upgrading to 10..."
    cp /etc/apt/sources.list /etc/apt/sources.list_backup
    sed -i 's/jessie/buster/g' /etc/apt/sources.list
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt autoremove -y
#  Если версия 9, то обновляем до 10
elif [ $ver = 'VERSION_ID="9"' ]
  then
    echo "OS version is 9. Upgrading to 10..."
    cp /etc/apt/sources.list /etc/apt/sources.list_backup
    sed -i 's/stretch/buster/g' /etc/apt/sources.list
    apt-get update
    apt-get upgrade -y
    apt-get dist-upgrade -y
    apt autoremove -y
#  Если версия 10, то просто всё обновляем.
elif [ $ver = 'VERSION_ID="10"' ]
  then
    echo "Updating system..."
    apt-get update
    apt-get upgrade -y
    apt autoremove -y
# Если версия не 8, не 9, не 10 и не debian, то скрипт завершается и потребуется ручное вмешательство.
  else
    echo -e "\e[31mЧто-то пошло не так. Требуется вмешательство.\e[0m"
    exit 0
fi
echo
echo -e "***** Script \033[33;1m1\033[0m of \033[33;1m3\033[0m COMPLETED in $SECONDS seconds *****"
echo
