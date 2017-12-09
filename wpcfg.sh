#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

if [ -e wp-config.php ]
then
  RAND=$(< /dev/urandom tr -dc 0-9 | head -c${1:-7};echo;)
  wpconn=( $(awk -F "'" "/^define\('DB_[NUPH]/{print \$4}" wp-config.php) )
  DB_NAME=${wpconn[0]}
  DB_USER=${wpconn[1]}
  DB_PASSWORD=${wpconn[2]}
  DB_HOST=${wpconn[3]}
    if [ ! -e wp-config.php.bk ]; then
                    cp -f wp-config.php wp-config.php.bk
    fi
  dbname="${USER}_${DB_NAME}"
  dbuser="$USER"_"${RAND}"
  dbpass="${DB_PASSWORD}"
  dbhost='localhost'
  sed -ie "s,DB_NAME'\, '${DB_NAME}',DB_NAME'\, '${dbname}'," wp-config.php
  sed -ie "s,DB_USER'\, '${DB_USER}',DB_USER'\, '${dbuser}'," wp-config.php
  sed -ie "s,DB_PASSWORD'\, '${DB_PASSWORD}',DB_PASSWORD'\, '${dbpass}'," wp-config.php
  sed -ie "s,DB_HOST'\, '${DB_HOST}',DB_HOST'\, '${dbhost}'," wp-config.php
  echo "${RED}Old Config${SET}"
  echo -e "\t${DB_NAME} ${DB_USER} ${DB_PASSWORD} ${DB_HOST}"
  echo "${GREEN}New Config${SET}"
  echo -e "\t$dbname $dbuser $dbpass"
else
  echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
fi
