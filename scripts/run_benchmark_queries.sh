#!/bin/bash
#
# Note: This is _not_ the proper way to perform the benchmark - some queries will be run with cold data, some with hot data,
# there are no repetitions etc. Use it to check you're getting sane results for all of the queries


for ((i=1;i<=9;i++)); do 
	formatted_query_number=$(printf "%02d" $i);
	echo "Query $formatted_query_number:" 
	cat benchmark_queries/$formatted_query_number.sql
	cat benchmark_queries/$formatted_query_number.sql | mclient -d ontime-bkp; 
	echo
done

