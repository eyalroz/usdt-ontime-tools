#!/bin/bash

function die {
	echo $1 >&2   # error message to stderr 
	exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"

db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,mode_value,mode_is_null,mode_multiplicity,mode_frequency,non_null_mode_value,non_null_mode_multiplicity,non_null_mode_frequency"
num_rows=$(mclient -d "$db_name" -f csv -s "select count(*) from $table_name")
for col in $columns; do
	mode_query="select v, (v is null), cnt, cnt / cast($num_rows as double) from (select count(*) as cnt, $col as v from $table_name group by $col) AS t order by cnt desc limit 1;"
	non_null_mode_query="select v, cnt, cnt / cast($num_rows as double) from (select count(*) as cnt, $col as v from $table_name where $col is not null group by $col) AS t order by cnt desc limit 1;"
	mode_query_result=$(mclient -d "$db_name" -f csv -s "$mode_query" 2>/dev/null)
	non_null_mode_query_result=$(mclient -d "$db_name" -f csv -s "$non_null_mode_query" 2>/dev/null)
	echo "$col,${mode_query_result:-,},${non_null_mode_query_result:-,}"
done

