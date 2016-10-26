SELECT carrier, count(*) FROM ontime WHERE DepDelay>10 AND Year_=2007 GROUP BY carrier ORDER BY 2 DESC;
