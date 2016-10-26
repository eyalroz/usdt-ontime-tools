for ((i=1;i<10;i++)); do filename=$(printf "benchmark_queries/%02d.sql" $i); cat queries_with_descriptions.txt | grep SELECT | head -$i | tail -1 > $filename ; done
