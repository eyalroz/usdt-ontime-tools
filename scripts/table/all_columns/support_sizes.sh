#!/bin/bash 

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"


db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name,\"null\" from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
num_rows=$(mclient -d "$db_name" -f csv -s "select count(*) from $table_name")
echo "column_name,support_size,non_null_support_size,has_nulls,is_nullable"
for col_and_nullable in $columns; do
    IFS=',' tokens=( $col_and_nullable )
    col=${tokens[0]}
    nullable=${tokens[1]}
	query="SELECT '$col', (SELECT count(*) FROM (SELECT 0 from $table_name group by $col) AS t) AS support_size, (select count(distinct $col) from $table_name) AS non_null_support_size, (SELECT count(*) FROM $table_name WHERE $col IS NULL) > 0 AS has_nulls, '$nullable' AS nullable;"
	mclient -d "$db_name" -f csv -s "$query"
done
