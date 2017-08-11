SELECT
  DestCityName AS destination_city,
  count(DISTINCT OriginCityName) AS num_origins_of_flights
FROM ontime
WHERE Year_ BETWEEN 2003 AND 2007
GROUP BY DestCityName
ORDER BY 2 DESC
LIMIT 10;

