#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

if [[ -f wp-config.php ]]; then
        wpconn=( $(awk -F "'" '/DB_NAME|DB_USER|DB_PASSWORD|DB_HOST/{print $4,$8,$12,$16}' wp-config.php) )
        DB_NAME=${wpconn[0]}
        DB_USER=${wpconn[1]}
        DB_PASSWORD=${wpconn[2]}
        DB_HOST=${wpconn[3]}
        prefix=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)
        version=$(grep -i "wp_version =" wp-includes/version.php | cut -d"'" -f2)
        echo "${GREEN}Database${SET}: ${DB_NAME}"
        echo "${GREEN}User${SET}: ${DB_USER}"
        echo "${GREEN}Password${SET}: ${DB_PASSWORD}"
        echo "${GREEN}Host${SET}: ${DB_HOST}"
        echo "${GREEN}TablePrefix${SET}: $prefix"
        echo "${GREEN}WP Version${SET}: $version"
else
        echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
fi
