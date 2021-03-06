WITH
  annual_delays AS (
    SELECT
      Year_,
      count(*) AS num_delays
    FROM ontime
    WHERE DepDelay > 10 GROUP BY Year_
  ),
  annual_flights AS (
    SELECT
      Year_,
      count(*) AS num_flights
    FROM ontime
    GROUP BY Year_
  )
SELECT
  annual_delays.Year_,
  num_delays * 1000 / num_flights AS delays_permille
FROM
  annual_delays
  JOIN
  annual_flights
  ON (annual_delays.Year_ = annual_flights.Year_);
