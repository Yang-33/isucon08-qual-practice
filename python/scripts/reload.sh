#!/bin/bash

# Nginx
if [[ ! -e /etc/nginx/nginx.conf.backup ]]; then
  sudo cp /etc/nginx/nginx.conf /etc/uginx/nginx.conf.backup
fi

if [ -f /var/log/nginx/access.log ]; then
  sudo mv /var/log/nginx/access.log /var/log/nginx/access.log.$(date "+%Y%m%d_%H%M%S")
fi

sudo cp ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
sudo service nginx reload

# MySQL
if [[ ! -e /etc/mysql/mysql.conf.d/mysqld.cnf.backup ]]; then
  sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.backup
fi

if [ -f /var/log/mysql/mysql-slow.log ]; then
  sudo mv /var/log/mysql/mysql-slow.log /var/log/mysql/mysql-slow.log.$(date "+%Y%m%d_%H%M%S")
fi

sudo cp ./etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart 