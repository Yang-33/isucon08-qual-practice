#!/bin/bash

if [[ ! -e /etc/nginx/nginx.conf.backup ]]; then
  sudo cp /etc/nginx/nginx.conf /etc/uginx/nginx.conf.backup
fi
sudo cp ./etc/nginx/nginx.conf /etc/nginx/nginx.conf
sudo service nginx reload

if [[ ! -e /etc/mysql/mysql.conf.d/mysqld.cnf.backup ]]; then
  sudo cp /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.backup
fi
sudo cp ./etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf
sudo service mysql restart 