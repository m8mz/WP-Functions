#!/bin/bash
# Marcus H.
RED="\e[31m"
GREEN="\e[32m"
SET="\e[0m"
BLINK="\e[5m"
UNBLINK="\e[25m"
BLUESH="\e[44m"
SETSH="\e[49m"

wpconn=( $(awk -F "'" '/DB_NAME|DB_USER|DB_PASSWORD|DB_HOST/{print $4,$8,$12,$16}' wp-config.php) )
DB_NAME=${wpconn[0]}
DB_USER=${wpconn[1]}
DB_PASSWORD=${wpconn[2]}
DB_HOST=${wpconn[3]}
PREFIX=$(grep -i 'table_PREFIX' wp-config.php | cut -d"'" -f2)
randnum=$(< /dev/urandom tr -dc 0-9 | head -c3)
user="supportadmin_${randnum}"
pass=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c12)
while [ $# -gt 0 ]
do
case "$1" in
-n)
  mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} <<EOF
  INSERT INTO ${PREFIX}users (user_login, user_pass, user_nicename, user_email, user_status)
  VALUES ('$user',MD5('$pass'), 'firstname lastname', 'email@example.com', '0');
  INSERT INTO ${PREFIX}usermeta (umeta_id, user_id, meta_key, meta_value)
  VALUES (NULL, (Select max(id) FROM ${PREFIX}users), '${PREFIX}capabilities', 'a:1:{s:13:"administrator";s:1:"1";}');
  INSERT INTO ${PREFIX}usermeta (umeta_id, user_id, meta_key, meta_value)
  VALUES (NULL, (Select max(id) FROM ${PREFIX}users), '${PREFIX}user_level', '10');
EOF
echo -e "          ${GREEN}${BLINK}User Credentials${UNBLINK}${SET}"
echo "          Username: $user"
echo "          Password: $pass"
break
;;
-l)
mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} <<EOF
SELECT * FROM ${PREFIX}users\G
EOF
break
;;
-u)
mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} <<EOF
UPDATE ${DB_NAME}.${PREFIX}users SET user_pass = MD5('$pass') WHERE user_login = '$2'
EOF
echo -e "          ${GREEN}${BLINK}User Credentials${UNBLINK}${SET}"
echo "          Username: $user"
echo "          Password: $pass"
break
;;
-f)
mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} <<EOF
SELECT * FROM ${DB_NAME}.${PREFIX}users WHERE user_login LIKE '%${2}%'\G
EOF
break
;;
-d)
userid=$(mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} -e "SELECT ID FROM ${DB_NAME}.${PREFIX}users WHERE user_login = '$2'\G" | cut -d":" -f2 | cut -d" " -f2 | cut -d"." -f2 | sed '/^$/d')
echo -n "Confirm [y/yes]: "
read user_confirmation
if [[ $user_confirmation == 'yes' ]] || [[ $user_confirmation == 'y' ]]; then
mysql -h ${DB_HOST} -u ${DB_USER} -p${DB_PASSWORD} -D ${DB_NAME} <<EOF
DELETE FROM ${PREFIX}usermeta WHERE user_id = '$userid' AND meta_key = '${PREFIX}capabilities';
DELETE FROM ${PREFIX}usermeta WHERE user_id = '$userid' AND meta_key = '${PREFIX}user_level';
DELETE FROM ${PREFIX}users WHERE user_login = '$2';
EOF
echo "${RED}Deleted${SET}: $2"
else
echo -e "Usage: wpuser [-n] [-l] [-u USER] [-f STRING] [-d USER]"
fi
break
;;
esac
done
