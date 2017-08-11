WITH
  carrier_delays AS (
    SELECT
      carrier,
      count(*) AS num_delays
    FROM ontime
    WHERE
      DepDelay > 10
      AND
      Year_ = 2007
    GROUP BY carrier
  ),
  carrier_flights AS (
    SELECT
      carrier,
      count(*) AS num_flights
    FROM ontime
    WHERE Year_ = 2007
    GROUP BY carrier
  )
SELECT
  carrier_delays.carrier,
  num_delays,
  num_flights,
  num_delays * 1000 / num_flights AS delays_permille
FROM
  carrier_delays
  JOIN
  carrier_flights
  ON (carrier_delays.Carrier = carrier_flights.Carrier)
ORDER BY delays_permille DESC;
