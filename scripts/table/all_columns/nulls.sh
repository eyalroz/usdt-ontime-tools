#!/bin/bash

function die {
	echo $1 >&2   # error message to stderr 
	exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"

db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name,\"null\" from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,nullable,has_nulls,mode_is_null,null_multiplicity,null_frequency"
num_rows=$(mclient -d "$db_name" -f csv -s "select count(*) from $table_name")
for col_and_nullable in $columns; do
    IFS=',' tokens=( $col_and_nullable )
    col=${tokens[0]}
    nullable=${tokens[1]}
	query="SELECT (SELECT count(*) FROM $table_name WHERE $col IS NULL) > 0 AS has_nulls, (v IS NULL) AS mode_is_null, (SELECT count(*) FROM $table_name WHERE $col IS NULL) AS null_multiplicity, round((SELECT count(*) FROM $table_name WHERE $col IS NULL)/cast($num_rows AS double),4) AS null_frequency FROM (SELECT count(*) AS CNT, $col as v from $table_name GROUP BY $col) AS t ORDER BY cnt DESC LIMIT 1;"
	query_result=$(mclient -d "$db_name" -f csv -s "$query" | sed -r 's/([^,])0+$/\1/;')
	echo "$col,$nullable,${query_result:-,,}"
done

