#!/bin/bash

# Nginx
cat /var/log/nginx/access.log | kataribe > log_summary/nginx_access_log_summary.txt

# MySQL
# sudo mysqldumpslow -s at /var/log/mysql/mysql-slow.log > log_summary/mysql_query_avg_time.txt
# sudo mysqldumpslow -s c /var/log/mysql/mysql-slow.log > log_summary/mysql_query_count.txt
sudo ./percona-toolkit-3.0.5-test/bin/pt-query-digest /var/log/mysql/mysql-slow.log > log_summary/mysql_slow_log_summary.txt
# TODO: もう少しクエリのタイプの分類を増やす