-- How many flights do carriers fly per day? Full table: ...
SELECT count(distinct flightnum) FROM ontime GROUP BY year_, month_, dayofmonth, carrier ORDER BY year_, month_, dayofmonth;
-- ... and some statistics on that:
WITH carrier_nflights AS (SELECT year_, month_, dayofmonth, carrier, count(distinct flightnum) AS cnt FROM ontime GROUP BY year_, month_, dayofmonth, carrier) SELECT year_, month_, dayofmonth, carrier, cnt FROM carrier_nflights WHERE cnt = (SELECT max(cnt) FROM carrier_nflights);
SELECT origin, dest, crsdeptime, count(distinct flightnum) AS cnt FROM ontime WHERE tailnum IS NOT NULL AND tailnum <> 'UNKNOW' AND Year_=2000 AND month_=9 AND dayofmonth=1 AND carrier='AA' GROUP BY year_, month_, dayofmonth, carrier, origin, dest, crsdeptime ORDER BY cnt DESC LIMIT 10;
-- Monthly average number of flight records (= flights?)
WITH t AS (SELECT year_,month_,count(*) AS c1 FROM ontime GROUP BY year_,month_) select round(AVG(c1),1) AS monthly_average_num_flight_records FROM t;
-- Duplicate flights by "flight key"
SELECT year_, month_, dayofmonth, carrier, origin, dest, crsdeptime, tailnum, count(distinct flightnum) AS num_flight_records FROM ontime WHERE tailnum IS NOT NULL AND tailnum <> 'UNKNOW' AND crsdeptime <> 0 AND crsdeptime is not null AND depdelay is not null GROUP BY year_, month_, dayofmonth, carrier, origin, dest, crsdeptime, tailnum HAVING COUNT(*) > 1 ORDER BY num_flight_records DESC;
