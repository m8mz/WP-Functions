#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

while [ $# -gt 0 ]
do
  case "$1" in
    -i|--import)
      sqlfile=$2
      if [[ -f wp-config.php ]]
      then
        wpconn=( $(awk -F "'" '/DB_NAME|DB_USER|DB_PASSWORD|DB_HOST/{print $4,$8,$12,$16}' wp-config.php) )
        DB_NAME=${wpconn[0]}
        DB_USER=${wpconn[1]}
        DB_PASSWORD=${wpconn[2]}
        DB_HOST=${wpconn[3]}
        echo -e "${BLUESH}Command${SETSH}: mysql -h ${DB_HOST} -u ${DB_USER} -p'${DB_PASSWORD}' ${DB_NAME} < ${sqlfile}"
        echo "Importing ${sqlfile} To $dbname"
        mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} < ${sqlfile}
        chk_mysql=$?
        if [[ $chk_mysql -eq 0 ]]
          then
            echo "Import Successful"
            echo -e "${GREEN}${BLINK}Filename${UNBLINK}${SET}: ${sqlfile}"
          else
            echo -e "${RED}${BLINK}MySQL${UNBLINK}${SET}: Import Error"
        fi
      else
        echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
      fi
    break
    ;;
    -x|--export)
      if [[ -f wp-config.php ]]
        then
          wpconn=( $(awk -F "'" '/DB_NAME|DB_USER|DB_PASSWORD|DB_HOST/{print $4,$8,$12,$16}' wp-config.php) )
          DB_NAME=${wpconn[0]}
          DB_USER=${wpconn[1]}
          DB_PASSWORD=${wpconn[2]}
          DB_HOST=${wpconn[3]}
          echo -e "${BLUESH}Command${SETSH}: mysqldump -h ${DB_HOST} -u ${DB_USER} -p'${DB_PASSWORD}' ${DB_NAME} > ${DB_NAME}_${today}.sql"
          echo "Dumping ${DB_NAME}"
          mysqldump -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} ${DB_NAME} > ${DB_NAME}_${today}.sql
          if [[ mysqldump -eq 0 ]]
            then
              chmod 600 ${DB_NAME}_${today}.sql
              echo "Dump Successful"
              echo -e "${GREEN}${BLINK}File${UNBLINK}${SET}: ${DB_NAME}_${today}.sql"
            else
              echo -e "${RED}${BLINK}MySQL${UNBLINK}${SET}: Export Error"
          fi
        else
          echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
      fi
    break
    ;;
  esac
done
