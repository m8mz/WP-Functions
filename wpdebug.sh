#!/bin/bash
# Author: Marcus Hancock-Gaillard

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
