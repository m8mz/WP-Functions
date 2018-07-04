#!/bin/bash
# Author: Marcus Hancock-Gaillard


cpuser=$(pwd | cut -d'/' -f3)
dbname="$(echo $cpuser | head -c8)_$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c5)"
dbuser="$(echo $cpuser | head -c8)_$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c5)"
dbpass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c15)
regex="\/home\/[A-Za-z0-9]+\/public_html.*"
num_of_files=$(find . -maxdepth 1 -type f ! -iname "*.htaccess*" | wc -l)
prefix=$(< /dev/urandom tr -dc A-Z-a-z-0-9 | head -c3)
creation_query="\
CREATE DATABASE $dbname;
CREATE USER '${dbuser}'@'localhost' IDENTIFIED BY '${dbpass}';
GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbuser}'@'localhost';
FLUSH PRIVILEGES;"

if [[ $(pwd) =~ $regex ]] && [[ $num_of_files < 1 ]] && [[ ! -d "wp-content" ]]; then
        wget -q https://wordpress.org/latest.tar.gz
        tar -xf latest.tar.gz --strip-components=1 wordpress/
        rm -f latest.tar.gz
        if [[ $(whoami) == "root" ]]; then
                sed -n '1,48p' wp-config-sample.php > wp-config.php
                wget -qO - https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
                sed -n '57,89p' wp-config-sample.php >> wp-config.php
                sed -ie "s,database_name_here,$dbname,;s,username_here,$dbuser,;s,password_here,$dbpass,;s,wp_,wp_${prefix}_,;" wp-config.php
                echo $creation_query | mysql
                if [[ $? == 0 ]]; then
                        echo "Database Creation Successful."
                        /usr/local/cpanel/bin/dbmaptool $cpuser --type 'mysql' --dbs ${dbname} --dbusers ${dbuser}
                        echo "Wordpress installed."
                else
                        echo "Error: Database Creation Failed."
                        echo -e "[Optional Creds] Database: ${dbname}\tUser: ${dbuser}\tPassword: ${dbpass}"
                fi
        else
                echo "Create the Database."
                echo -e "[Optional Creds] Database: ${dbname}\tUser: ${dbuser}\tPassword: ${dbpass}"
        fi
else
        echo "Error: Can't install Wordpress here."
fi
