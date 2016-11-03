-- The data is loaded into the DB from monthly (zipped) CSV files; this will
-- list the number of flight records in each one of these files
SELECT year_,month_, COUNT(*) AS num_records_in_month_file FROM ontime GROUP BY year_,month_ ORDER BY year_ ASC, month_ ASC;
