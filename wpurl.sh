#!/bin/bash
# Description: This will interact with the database fields for home and siteurl in WordPress databases.
# Use:
# wpurl 	- Running this script with no arguments will print out the current home and siteurl fields from the database.
# -n) wpurl -n https://www.wordpress.org - This will update both the home and siteurl fields.
# -h) wpurl -h https://www.wordpress.org - This will only update the home field.
# -s) wpurl -s https://www.wordpress.org - This will only update the site field.
# Author: Marcus Hancock-Gaillard

function wpurl() {
	if [ -f wp-config.php ]; then
	  PREFIX=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)
	  wpconn=( $(awk -F "'" "/^define\( ?'DB_[NUPH]/{print \$4}" wp-config.php) )
	  DB_NAME=${wpconn[0]}
	  DB_USER=${wpconn[1]}
	  DB_PASSWORD=${wpconn[2]}
	  DB_HOST=${wpconn[3]}
    if [[ $1 == '-n' ]]; then
      mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -e "UPDATE ${PREFIX}options SET option_value = '$2' WHERE option_name = 'siteurl' OR option_name = 'home';"
    elif [[ $1 == '-h' ]]; then
      mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -e "UPDATE ${PREFIX}options SET option_value = '$2' WHERE option_name = 'home';"
    elif [[ $1 == '-s' ]]; then
      mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -e "UPDATE ${PREFIX}options SET option_value = '$2' WHERE option_name = 'siteurl';"
    fi
	  SITE_URL=$(mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -se "SELECT option_value FROM ${PREFIX}options WHERE option_name = 'siteurl';" | cut -f2)
	  HOME_URL=$(mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -se "SELECT option_value FROM ${PREFIX}options WHERE option_name = 'home';" | cut -f2)
	  echo -e "${BLUESH}Database${SETSH}: ${DB_NAME}"
	  echo -e "${GREEN}Home URL${SET}: $HOME_URL"
	  echo -e "${GREEN}Site URL${SET}: ${SITE_URL}"
	else
	  echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
	fi
}
