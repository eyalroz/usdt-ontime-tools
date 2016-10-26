WITH t AS (SELECT carrier, count(*) AS n FROM ontime WHERE DepDelay>10  AND YearD>=2000 AND YearD<=2008 GROUP BY carrier), t2 AS (SELECT carrier, count(*) AS n2 FROM ontime WHERE YearD>=2000 AND YearD<=2008 GROUP BY carrier) SELECT t.carrier, c, c2, c*1000/c2 as c3 FROM t JOIN t2 ON (t.Carrier=t2.Carrier) ORDER BY c3 DESC;
