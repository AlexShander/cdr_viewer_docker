#!/bin/sh
set -e

echo $ADMIN:$(echo $ADMIN_PASS | mkpasswd -m sha-512) >> /secret_nginx/nginx.passwd
