#!/bin/sh

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# <= 2 )) || die "Usage: $0 [ database_name [ table_name ] ]"


db_name="${1:-usdt-ontime}"
table_name="${2:-ontime}"

string_columns=$(echo "\\d $table_name" | mclient -i -f csv -d "$db_name" | grep CHAR | cut -d\" -f2)

echo "column_name,min_length,max_length,average_length"
for col in $string_columns; do mclient -f csv -d "$db_name" -s \
	"SELECT '$col' AS column_name, min(length($col)) AS min_length, max(length($col)) AS max_length, round(avg(length($col)),1) AS average_length FROM ontime;"; done

