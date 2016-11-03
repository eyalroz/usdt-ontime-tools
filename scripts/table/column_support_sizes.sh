#!/bin/bash 

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"


db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,num_non_null_values,has_nulls"
for col in $columns; do
	query="SELECT '$col', count(*) AS num_non_null_values, sum(is_null) AS has_nulls FROM (SELECT DISTINCT $col, $col is null AS is_null FROM ontime GROUP BY $col) AS t;"
	mclient -d "$db_name" -f csv -s "$query"
done
