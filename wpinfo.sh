#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

function wpinfo() {
if [[ -f wp-config.php ]]; then
        wpconn=( $(awk -F "'" "/^define\('DB_[NUPH]/{print \$4}" wp-config.php) )
        DB_NAME=${wpconn[0]}
        DB_USER=${wpconn[1]}
        DB_PASSWORD=${wpconn[2]}
        DB_HOST=${wpconn[3]}
        prefix=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)
        version=$(grep -i "wp_version =" wp-includes/version.php | cut -d"'" -f2)
        echo -e "${GREEN}Database${SET}: ${DB_NAME}"
        echo -e "${GREEN}User${SET}: ${DB_USER}"
        echo -e "${GREEN}Password${SET}: ${DB_PASSWORD}"
        echo -e "${GREEN}Host${SET}: ${DB_HOST}"
        echo -e "${GREEN}TablePrefix${SET}: $prefix"
        echo -e "${GREEN}WP Version${SET}: $version"
else
        echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
fi
}
