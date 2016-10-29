#!/bin/bash

[[ $# == 1 ]] || ( echo "Usage: $0 <path-to-query> >&2; exit 1;" )

query_file=$1

sed -r 's/--.*$//;' $query_file | paste -s --delimiters=\  | sed -r 's/\s+/ /g; s/^\s//;'
