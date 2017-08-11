SELECT
  Year_,
  count(*) AS num_flight_records
FROM ontime
GROUP BY Year_;
