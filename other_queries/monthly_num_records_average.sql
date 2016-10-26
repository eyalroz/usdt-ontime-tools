with t as (select year_,month_,count(*) as c1 from ontime group by year_,month_) select AVG(c1) FROM t;
