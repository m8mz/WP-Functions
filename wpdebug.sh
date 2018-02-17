#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

function wpdebug() {
	if [[ -f wp-config.php ]]; then
		if [[ $# -eq 1 ]]; then
			if [[ $1 == 'on' ]]; then
				sed -i "s,'WP_DEBUG'\, false,'WP_DEBUG'\, true," wp-config.php
				echo -e "WP DEBUG = ${GREEN}ON${SET}"
				elif [[ $1 == 'off' ]]; then
				sed -i "s,'WP_DEBUG'\, true,'WP_DEBUG'\, false," wp-config.php
				echo -e "WP DEBUG = ${RED}OFF${SET}"
			else
				echo -e "${BLINK}${GREEN}USAGE${SET}${UNBLINK}: wpdebug (on|off)"
			fi
		else
			echo -e "${BLINK}${GREEN}USAGE${SET}${UNBLINK}: wpdebug (on|off)"
		fi
	else
		echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
	fi
}
