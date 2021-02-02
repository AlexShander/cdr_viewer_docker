#!/bin/sh
set -e

CONF_FILE_NAME='/var/www/html/inc/config/config.php'

# Default values for configs config.php
DEF_ASTERISK_DB=asteriskcdr
DEF_ASTERISK_HOST=local_host
DEF_ASTERISK_USER=asterisk
DEF_ASTERISK_PASS=password
DEF_ASTERISK_CDR_TABLE=cdr_viewer
DEF_COLUMN_NAME=recordingfile
DEF_MONINTOR_DIR=/recordings/
DEF_STORAGE_FORMAT=5
DEF_ADMIN=admin
# Default values for php.ini
DEF_TIMEZONE='Asia/Almaty'

rm -f $CONF_FILE_NAME
cp -f $CONF_FILE_NAME.sample $CONF_FILE_NAME
if [[ -z "$ASTERISK_DB" ]]; then
  ASTERISK_DB=$DEF_ASTERISK_DB
fi
if [[ -z "$ASTERISK_HOST" ]]; then
  ASTERISK_HOST=$DEF_ASTERISK_HOST 
fi
if [[ -z "$ASTERISK_USER" ]]; then
  ASTERISK_USER=$DEF_ASTERISK_USER
fi
if [[ -z "$ASTERISK_PASS" ]]; then
  ASTERISK_PASS=$DEF_ASTERISK_PASS
fi
if [[ -z "$ASTERISK_CDR_TABLE" ]]; then
  ASTERISK_CDR_TABLE=$DEF_ASTERISK_CDR_TABLE
fi
if [[ -z "$COLUMN_NAME" ]]; then
  COLUMN_NAME=$DEF_COLUMN_NAME
fi
if [[ -z "$MONINTOR_DIR" ]]; then
  MONINTOR_DIR=$(echo $DEF_MONINTOR_DIR | sed 's/\//\\\//g')
else
  MONINTOR_DIR=$(echo $MONINTOR_DIR | sed 's/\//\\\//g')
fi
if [[ -z "$STORAGE_FORMAT" ]]; then
  STORAGE_FORMAT=$DEF_STORAGE_FORMAT
fi
if [[ -z "$ADMIN" ]]; then
  ADMIN=$( echo $DEF_ADMIN | sed "s/$/\\\'/" |sed "s/^/\\\'/")
else
  ADMIN=$( echo $ADMIN | sed "s/,/\\\'\,\\\'/g"| sed "s/$/\\\'/" |sed "s/^/\\\'/")
fi
if [[ -z "$TIMEZONE" ]]; then
  TIMEZONE=$DEF_TIMEZONE
fi

sed -i -E "s/([[:space:]]+)('host')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$ASTERISK_HOST\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('user')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$ASTERISK_USER\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('name')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$ASTERISK_DB\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('pass')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$ASTERISK_PASS\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('table')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$ASTERISK_CDR_TABLE\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('column_name')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$COLUMN_NAME\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('monitor_dir')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$MONINTOR_DIR\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('storage_format')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$STORAGE_FORMAT\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('column_name')([[:space:]]+=>[[:space:]]+')(.*)(',.*$)/\1\2\3$COLUMN_NAME\5/g" $CONF_FILE_NAME
sed -i -E "s/([[:space:]]+)('admins')([[:space:]]+=>[[:space:]]+array\()(.*$)/\1\2\3$ADMIN\4/g" $CONF_FILE_NAME

echo "[Date]" >> /usr/local/etc/php/conf.d/php.ini 
echo "date.timezone = $TIMEZONE" >> /usr/local/etc/php/conf.d/php.ini


exec "/usr/local/bin/docker-php-entrypoint" "$@"
