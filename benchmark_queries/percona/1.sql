SELECT
    DayOfWeek AS day_of_week,
    count(*) AS num_flight_records
FROM ontime
WHERE Year_ BETWEEN 2000 AND 2008
GROUP BY DayOfWeek
ORDER BY num_flight_records DESC;
