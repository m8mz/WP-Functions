#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

function wpht() {
	if [[ -f wp-config.php ]]; then
		wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
		if [[ -e .htaccess ]]; then
			cp .htaccess{,-$(date +%s)}
		fi
		if [[ -f wp-cli.yml ]]; then
			mv wp-cli.yml{,.BAK}
		fi
		echo -e "apache_modules:\n - mod_rewrite" > wp-cli.yml
		php ./wp-cli.phar rewrite flush --hard
		rm -f wp-cli.yml wp-cli.phar
		if [[ -f wp-cli.yml.BAK ]]; then
			mv wp-cli.yml{.BAK,}
		fi
	else
		echo -e "${RED}${BLINK}Issue${UNBLINK}${SET}: No WordPress Config File"
	fi
}
