-- The ontime table _should_ have the following unique key:
--
--   year_, month_, dayofmonth, uniquecarrier, flightnum, origin
--
-- (the origin is necessary since the same flight can have several hops and each hop has a record).
-- Unfortunately, there are some duplicate entries with all fields exactly the same, as well asm
-- some erroneous entries with these key fields being the same but other fields differring. This
-- obtains all records in such groups of records.

SELECT * FROM ontime AS t1, (SELECT *, count(*) AS flights FROM ontime GROUP BY year_, month_, uniquecarrier, flightnum, dayofmonth, origin) as t2 WHERE t2.flights > 1 AND t1.year_ = t2.year_ AND t1.month_ = t2.month_ AND t1.uniquecarrier = t2.uniquecarrier AND t1.flightnum = t2.flightnum AND t1.dayofmonth = t2.dayofmonth AND t1.origin = t2.origin;
