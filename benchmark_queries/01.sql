SELECT DayOfWeek, count(*) AS n FROM ontime WHERE YearD BETWEEN 2000 AND 2008 GROUP BY DayOfWeek ORDER BY c DESC;
