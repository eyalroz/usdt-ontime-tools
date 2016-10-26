SELECT DestCityName AS destination, COUNT(DISTINCT OriginCityName) as num_origins_of_flights FROM ontime WHERE Year_ BETWEEN 2003 and 2007 GROUP BY DestCityName ORDER BY 2 DESC LIMIT 10;
