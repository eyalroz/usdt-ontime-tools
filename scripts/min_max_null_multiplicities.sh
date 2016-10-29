#!/bin/bash 

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# == 2 )) || die "Usage: $0 <database_name> <table_name>"


db_name="$1"
table_name="$2"

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,num_non_null,most_common_value,highest_multiplicity,least_common_value,lowest_multiplicity,max_to_min_multiplicity_ratio,null_multiplicity, total"
for col in $columns; do
query="\
START TRANSACTION;\
        CREATE TEMPORARY TABLE t AS SELECT $col AS c, count(*) AS n FROM $table_name WHERE $col is not null GROUP BY c;\
        SELECT '$col' AS column_name, (SELECT sum(n) FROM t AS t3) AS num_non_null, t1.c AS most_common_value, t1.n AS highest_multiplicity, t2.c AS least_common_value, t2.n AS lowest_multiplicity, t1.n * 1.0 / t2.n AS max_to_min_multiplicity_ratio, (SELECT count(*) FROM $table_name WHERE $col is null) AS null_multiplicity, (SELECT count(*) FROM $table_name) AS total FROM t AS t1, t AS t2 ORDER BY max_to_min_multiplicity_ratio DESC LIMIT 1;\
ROLLBACK;\
"
	mclient -d "$db_name" -f csv -s "$query"
done
