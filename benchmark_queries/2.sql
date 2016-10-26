SELECT DayOfWeek AS day_of_week, count(*) AS num_departures FROM ontime WHERE DepDelay>10 AND Year_ BETWEEN 2000 AND 2008 GROUP BY DayOfWeek ORDER BY num_departures DESC;
