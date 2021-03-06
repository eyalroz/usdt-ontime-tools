# 'usdt-ontime' benchmark tools

This project facilitates the use of on-time and delayed flight data, available from the [US Department of Transport](https://www.transportation.gov/)'s [Bureau of Transportation Statistics](https://www.bts.gov/), for DBMS testing and benchmarking.

Specifically, it comprises:

* A script for automating the tasks of downloading the zipped tabular data (available through [here](http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time)), mildly cleaning it, and loading it into a database with a (mostly) proper schema.
* A set of queries are used as the benchmark, to be executed on all data for years 2000-2008, with correct query result files included as well, as reference.
* Miscellaneous additional potentially useful scripts and SQL queries\.

This work is inspired (or rather, necessitated) by a [post](https://www.percona.com/blog/2009/10/02/analyzing-air-traffic-performance-with-infobright-and-monetdb/) from several years ago on Percona's [performance blog](https://www.percona.com/blog), comparing MonetDB with InfoBright on the set of queries included here. They are perhaps not the most thorough or insightful benchmark queries one could device for this data, but that's what we're starting with.

Currently, only [MonetDB](https://www.monetdb.org/) is supported as the DBMS into which data is to be loaded.

### Requirements

* Internet connection (specifically HTTP)
* The Bourne Again Shell - bash
* various typical Unix-ish command-line tools: unzip, wget, sed, echo and so on.
* MonetDB installed and running
* Enough disk space for the data you want

### Getting started

1. Set up a MonetDB 'Database Farm' (see the [MonetDB tutorial](https://www.monetdb.org/Documentation/UserGuide/Tutorial) if you're not sure how to do that).
2. Make sure you have your MonetDB credentials (username and password) in `~/.monetdb` (otherwise you will be prompted for credentials for each of dozens of files when loading the date).
3. Invoke `scripts/setup-usdt-ontime-db` to create and populate DB with data from 2000 through 2008; the script's command-line options are as follows:
```
Options:
  -r, --recreate           If the benchmark database exists, recreate it, dropping all
                           existing data. (If neither recreate nor append are set, the 
                           database be missing.)
  -a, --append             If the benchmark database exists, append to it rather than
                           recreating it. (If neither recreate nor append are set, the 
                           database be missing.)
  -d, --db-name NAME       Name of the database holding on-time performance data
  -f, --db-farm PATH       Filesystem path for the root directory of the MonetDB
                           database farm in which to place the database
  -p, --port NUMBER        IP port on which to connect to the database
  -k, --keep-downloads     Keep the zipped CSV files downloaded from the US department
                           of transport's website after loading them into the DB
  -s, --fix-sort-order    The order of appearance of records in the CSV files is not-uniform;
                           With this option (on by default) the CSVs will be resorted,
                           all by the same fixed order.
  -i, --ignore-sort-order  The order of appearance of records in the CSV files is not-uniform;
                           With this option, ) the CSVs will be loaded as-is
  -v, --verbose            Be verbose about actions taken and current status
  -h, --help               Print usage information
  -D, --download-dir       Directory into which individual monthly data file will be
                           downloaded and decompressed before being loaded into the DB
                           (default: /export/scratch1/home/eyalroz/src/usdt-ontime-tools/usdt-ontime-downloads)
  --first-year YEAR        First year for which to download data
  --first-month MONTH      First month in first year for which to download data
  --last-year YEAR         Last year for which to download data
  --last-month MONTH       Last month in last year for which to download data
```

4. Execute `scripts/run_benchmark_queries.sh -v` as a sanity check, to make sure you get results that look like the expected answer (you can also diff-compare the results you get with  `scripts/run_benchmark_queries.sh -w` to the reference results in `expected_results/`).

### Questions? Requests? Feedback? Bugs?

Feel free to [open an issue](https://github.com/eyalroz/usdt-ontime-tools/issues) or [write me](mailto:E.Rozenberg@cwi.nl).
