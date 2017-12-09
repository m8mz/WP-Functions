#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

wpconn=( $(awk -F "'" "/^define\('DB_[NUPH]/{print \$4}" wp-config.php) )
DB_NAME=${wpconn[0]}
DB_USER=${wpconn[1]}
DB_PASSWORD=${wpconn[2]}
DB_HOST=${wpconn[3]}

while [ $# -gt 0 ]
  do
        case "$1" in
        -h)
                        sed -ie "s,DB_HOST'\, '${DB_HOST}',DB_HOST'\, '$2'," wp-config.php
                        echo -e "${RED}OLD HOST${SET}: ${DB_HOST}"
                        echo -e "${GREEN}NEW HOST${SET}: $2"
                        break
      ;;
        -u)
                        sed -ie "s,DB_USER'\, '${DB_USER}',DB_USER'\, '$2'," wp-config.php
                        echo -e "${RED}OLD USER${SET}: ${DB_USER}"
                        echo -e "${GREEN}NEW USER${SET}: $2"
                        break
        ;;
        -d)
                        sed -ie "s,DB_NAME'\, '${DB_NAME}',DB_NAME'\, '$2'," wp-config.php
                        echo -e "${RED}OLD DATABASE${SET}: ${DB_NAME}"
                        echo -e "${GREEN}NEW DATABASE${SET}: $2"
                        break
        ;;
        -p)
                        sed -ie "s,DB_PASSWORD'\, '${DB_PASSWORD}',DB_PASSWORD'\, '$2'," wp-config.php
                        echo -e "${RED}OLD PASSWORD${SET}: ${DB_PASSWORD}"
                        echo -e "${GREEN}NEW PASSWORD${SET}: $2"
                        break
        ;;
        -f)
                        PREFIX=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)
                        sed -i "s,\$table_prefix = '${PREFIX}'\;,$table_prefix = '$2'\;," wp-config.php
                        echo -e "${RED}OLD HOST${SET}: ${PREFIX}"
                        echo -e "${GREEN}NEW HOST${SET}: $2"
                        break
        ;;
        *)
                echo -e "${BLINK}${GREEN}USAGE${SET}${UNBLINK}: $0 [-h HOST] [-u USER] [-p PASS] [-f PREFIX]"
                break
        ;;
    esac
  done
