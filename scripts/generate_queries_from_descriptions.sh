#!/bin/bash

num_queries=9
query_number_length=${#num_queries}

for ((i=1;i<=$num_queries;i++)); do 
        formatted_query_number=$(printf "%${query_number_length}d" $i)
	filename="benchmark_queries/${formatted_query_number}.sql"
	cat queries_with_descriptions.txt | grep SELECT | head -$i | tail -1 > $filename 
done
