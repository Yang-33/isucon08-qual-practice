#!/bin/bash
LIMIT_NUM=5
DATABASE="torb"

# modify |LIMIT_NUM|
if [ $# = 1 ]; then
  LIMIT_NUM=$1
fi

for table in `sudo mysql -e "show tables in ${DATABASE}"`;
do
  echo -e "\n\n^^^^^^^^^^^[TABLE NAME : ${table}]^^^^^^^^^^^";
  sudo mysql -t -e "use ${DATABASE}; \
                    select COUNT(*) from ${table}; \
                    show COLUMNS from ${table}; \
                    select * from ${table} LIMIT ${LIMIT_NUM}; \
                    show index from ${table};"
done
