#!/bin/sh

function die {
        echo $1 >&2   # error message to stderr 
        exit ${2:-1}  # default exit code is -1 but you can specify something else
}

(( $# == 1 )) || die "Usage: $0 <schema_creation_query>"

echo "column_name,data_type,nullable"
sed '/^--/d; s/CREATE\sTABLE\s*[A-Za-z]\+\s*(//; s/^\s*//; /^\s*$/d; /^[^A-Z]/d; s/\s\s\+/,/g; s/NOT NULL/0/; s/DEFAULT NULL/1/; s/--.*$//; s/,\s*$//;' "$1"
