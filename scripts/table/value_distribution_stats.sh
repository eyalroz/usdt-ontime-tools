#!/bin/bash 

function die {
	echo $1 >&2   # error message to stderr 
	exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"

db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

columns=$(mclient -d "$db_name" -f csv -s "select name,type from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,min_value,max_value,average_value,standard_deviation,relative_standard_deviation,median_value"
num_rows=$(mclient -d "$db_name" -f csv -s "select count(*) from $table_name")
for col_and_type in $columns; do
	IFS=',' tokens=( $col_and_type )
	col=${tokens[0]}
	col_type=${tokens[1]}
	if [[ $col_type == "double" || $col_type == "float" || $col_type == "int" || $col_type == "tinyint" || $col_type == "smallint" || $col_type == "huge" ]]; then
		avg_expr="round(avg($col),4)"
		stddev_part="round(stddev_pop($col),1) AS standard_deviation, case max($col)-min($col) WHEN 0 THEN 0 WHEN NULL THEN NULL ELSE round(stddev_pop($col)/((max($col)-min($col))/2.0),3) END AS relative_standard_deviation"
	else
		avg_expr="''"
		stddev_part="'' AS standard_deviation, '' AS relative_standard_deviation"
	fi
	if [[ $col_type == "char" || $col_type == "varchar" ]]; then
		median_expr="''"
	else
		median_expr="median($col)"
	fi
	query="SELECT '${col}', min($col), max($col), $median_expr AS median_value, $avg_expr AS average, $stddev_part FROM $table_name; "
	query_result=$(mclient -d "$db_name" -f csv -s "$query")
	echo "${query_result:-,,,,,,}"
done

