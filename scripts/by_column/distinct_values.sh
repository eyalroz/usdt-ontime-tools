#!/bin/bash 

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# == 2 )) || die "Usage: $0 <database_name> <table_name>"


db_name="$1"
table_name="$2"

columns=$(mclient -d "$db_name" -f csv -s "select name from sys.columns where table_id = (select id from sys.tables where name='$table_name');")
#echo "columns is $columns"
for col in $columns; do
	query="SELECT '$col', count(DISTINCT $col) FROM $table_name;"
	mclient -d "$db_name" -f csv -s "$query"
done
