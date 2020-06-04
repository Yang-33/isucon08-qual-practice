#!/bin/bash

set -eu

MYSQL_CONF_DIR=/etc/mysql
NGINX_CONF_DIR=/etc/nginx

##mkdir -p $HOME/$MYSQL_CONF_DIR
##mkdir -p $HOME/$NGINX_CONF_DIR

mkdir -p /home/y3/isucon8-qualify/webapp/python/$MYSQL_CONF_DIR
mkdir -p /home/y3/isucon8-qualify/webapp/python/$NGINX_CONF_DIR

TARGETS=(
        /etc/sysctl.conf
        /etc/mysql/my.cnf
        /etc/mysql/conf.d
        /etc/nginx/nginx.conf
        /etc/nginx/conf.d
        /etc/nginx/sites-enabled
        /etc/nginx/sites-available
)

for target in ${TARGETS[@]}
do
  if [[ ! -e $target.backup ]]; then
    sudo cp -r $target $target.backup
    ##sudo mv $target $HOME/$target
    sudo mv $target /home/y3/isucon8-qualify/webapp/python/$target
    # sudo chmod -R a+rw $HOME/$target
    ##sudo ln -s $HOME/$target $target
    sudo ln -s /home/y3/isucon8-qualify/webapp/python/$target $target
  fi
done
