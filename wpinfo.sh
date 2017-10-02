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
        dbname=$(grep -i 'DB_NAME' wp-config.php | cut -d"'" -f4)
        dbuser=$(grep -i 'DB_USER' wp-config.php | cut -d"'" -f4)
        dbpass=$(grep -i 'DB_PASSWORD' wp-config.php | cut -d"'" -f4)
        dbhost=$(grep -i 'DB_HOST' wp-config.php | cut -d"'" -f4)
        prefix=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)
        version=$(grep -i "wp_version =" wp-includes/version.php | cut -d"'" -f2)
        echo "${GREEN}Database${SET}: $dbname"
        echo "${GREEN}User${SET}: $dbuser"
        echo "${GREEN}Password${SET}: $dbpass"
        echo "${GREEN}Host${SET}: $dbhost"
        echo "${GREEN}TablePrefix${SET}: $prefix"
        echo "${GREEN}WP Version${SET}: $version"
else
        echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
fi
