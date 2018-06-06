#!/bin/bash
# Description: This will use the WP-CLI to update the rewrite rules for WordPress in the .htaccess.
# Use:
# wpht	- Simply run the script with a WordPress install in your CWD.
# Author: Marcus Hancock-Gaillard

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
