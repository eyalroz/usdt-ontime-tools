#!/bin/bash 

function die {
	echo $1 >&2   # error message to stderr 
	exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"

db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,min_value,max_value,average_value,standard_deviation,relative_standard_deviation,median_value"
for col in $columns; do
query1="SELECT min($col), max($col), round(avg($col),1), round(stddev_pop($col),1) AS standard_deviation, round(stddev_pop($col)/((max($col)-min($col))/2),3) AS relative_standard_deviation FROM $table_name;"
query2="\
START TRANSACTION; \
CREATE TEMPORARY TABLE counts AS SELECT $col AS col, count(*) AS cnt FROM $table_name GROUP BY $col;
CREATE TEMPORARY TABLE relative_orders AS SELECT t1.col, SUM(t1.cnt * ABS(SIGN(t1.col-t2.col)) * SIGN(SIGN(t1.col - t2.col) + 1) * 1.0) / SUM(t1.cnt) AS normalized_relative_order FROM counts AS t1, counts AS t2 GROUP BY t1.col  ORDER BY normalized_relative_order; \
SELECT col FROM relative_orders WHERE normalized_relative_order>=0.5 LIMIT 1; \
ROLLBACK; \
"
	query1_result=$(mclient -d "$db_name" -f csv -s "$query1" 2>/dev/null)
	query2_result=$(mclient -d "$db_name" -f csv -s "$query2" 2>/dev/null)
	echo "$col,${query1_result:-,,,,},$query2_result"
done

