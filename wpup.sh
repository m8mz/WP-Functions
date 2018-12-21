#!/bin/bash
# Description: This function will update the targeted field with new information inside the wp-config.php file.
# This script will be able to quickly update the db credentials and the table prefix.
# Use:
# -h) wpup -h localhost - This will update the host field.
# -u) wpup -u cpanel_user - This will update the database user field.
# -d) wpup -d cpanel_database - This will update the database field.
# -p) wpup -p password - This will update the password field.
# -f) wpup -f wp_ - This will update the table prefix field.
# Author: Marcus Hancock-Gaillard

function wpup() {
	wpconn=( $(awk -F "'" "/^define\( ?'DB_[NUPH]/{print \$4}" wp-config.php) )
	DB_NAME=${wpconn[0]}
	DB_USER=${wpconn[1]}
	DB_PASSWORD=${wpconn[2]}
	DB_HOST=${wpconn[3]}
	PREFIX=$(grep -i 'table_prefix' wp-config.php | cut -d"'" -f2)

	while [ $# -gt 0 ]
	  do
			case "$1" in
				-h)
					sed -ie "s,^define\(\"DB_HOST'\, '${DB_HOST}',^define\(\"DB_HOST'\, '${2}'," wp-config.php
					echo -e "${RED}OLD HOST${SET}: ${DB_HOST}"
					echo -e "${GREEN}NEW HOST${SET}: $2"
					break
				;;
				-u)
					sed -ie "s,^define\(\"DB_USER'\, '${DB_USER}',^define\(\"DB_USER'\, '${2}'," wp-config.php
					echo -e "${RED}OLD USER${SET}: ${DB_USER}"
					echo -e "${GREEN}NEW USER${SET}: $2"
					break
				;;
				-d)
					sed -ie "s,^define\(\"DB_NAME'\, '${DB_NAME}',^define\(\"DB_NAME'\, '${2}'," wp-config.php
					echo -e "${RED}OLD DATABASE${SET}: ${DB_NAME}"
					echo -e "${GREEN}NEW DATABASE${SET}: $2"
					break
				;;
				-p)
					sed -ie "s,^define\(\"DB_PASSWORD'\, '${DB_PASSWORD}',^define\(\"DB_PASSWORD'\, '${2}'," wp-config.php
					echo -e "${RED}OLD PASSWORD${SET}: ${DB_PASSWORD}"
					echo -e "${GREEN}NEW PASSWORD${SET}: $2"
					break
				;;
				-f)
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
}
