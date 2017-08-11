SELECT
  Origin,
  count(*) AS num_departures
FROM ontime
WHERE
  DepDelay > 10
  AND
  Year_ BETWEEN 2000 AND 2008
GROUP BY Origin
ORDER BY num_departures DESC
LIMIT 10;

