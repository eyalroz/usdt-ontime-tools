#!/bin/bash

function die {
	echo $1 >&2   # error message to stderr 
	exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 3 )) || die "Usage: $0 [ database_name [ table_name [ inverse_coverage_frequency ] ] ]"

db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"
inverse_frequency="${3:-100}"

[[ $(echo "$inverse_frequency > 1" | bc ) == "1" ]] ||  die "Inverse frequency must be higher than 1"

function db_is_up {
    # This assumes the DB exists
    local db_name=$1
    [[ "$be_verbose" ]] && echo monetdb -p $port status $db_name
    status=$(monetdb -p $port status $db_name 2>/dev/null | tail -1 | sed -r 's/^'$db_name'\s*([^ ]*).*$/\1/;')
    [[ "$be_verbose" ]] && echo "Database $db_name is" $(echo $status | sed 's/R/running/; s/S/not running/; s/^$/not running/')
    [[ -n "$status" && $status == "R" ]] && return 0 || return 1
}

function get_db_property {
	local db_name="$1"
	local property_name="$2"
	monetdb get "$property_name" $db_name | tail -1 | sed -r 's/^.*\b([^ ]+)$/\1/'
}

if [[ $(get_db_property $db_name "embedr") != "yes" ]]; then
	db_is_up $db_name && monetdb stop $db_name
	monetdb set embedr=true $db_name
	monetdb start $db_name
fi

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
echo "column_name,support_size,fraction_to_cover,num_elements_necessary,fraction_covered"
num_rows=$(mclient -d "$db_name" -f csv -s "select count(*) from $table_name")
for col in $columns; do
	fraction_to_cover=$(echo "scale = 15; 1 - 1 / $inverse_frequency" | bc | sed -r 's/^\./0./; s/([1-9.])0+$/\1/;' )
	support_size_query="select count(distinct $col) from $table_name;"
	support_size=$(mclient -d "$db_name" -f csv -s "$support_size_query")
	query="START TRANSACTION; "
	# Histogram of number of elements by multiplicity in column $col
	query+="CREATE TEMPORARY TABLE counts AS SELECT cnt, count(*) AS times FROM (SELECT count(*) AS cnt FROM $table_name GROUP BY $col) AS t1 GROUP BY cnt  ORDER BY cnt DESC;"
	# Same as 'counts', but with numbered rows (useful for self-joining)
	query+="CREATE TEMPORARY TABLE rn_counts AS SELECT row_number() OVER () AS rn, cnt, times FROM counts; "
	# The hard part
	query+="CREATE TEMPORARY TABLE sufficing_count AS SELECT min(rn) AS rn, min(covered) AS covered, min(used) AS used FROM (SELECT min(t1.rn) AS rn, sum(t2.cnt * t2.times) AS covered, sum(t2.times) AS used from rn_counts AS t1, rn_counts AS t2 where t1.rn >= t2.rn group by t1.rn) AS t3 WHERE covered > $fraction_to_cover * $num_rows; \
SELECT used - (covered - cast($fraction_to_cover * $num_rows AS int)) / cnt AS final_used, covered - ((covered - cast($fraction_to_cover * $num_rows AS int)) / cnt) * cnt AS final_covered  FROM sufficing_count, rn_counts WHERE rn_counts.rn = sufficing_count.rn; \
ROLLBACK;"
	cover_result=$(mclient -d "$db_name" -f csv -s "$query")
	echo "$col,$support_size,$fraction_to_cover,${cover_result:-,}"
done

