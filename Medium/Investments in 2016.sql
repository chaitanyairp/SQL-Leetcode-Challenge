-- Question 96
-- Write a query to print the sum of all total investment values in 2016 (TIV_2016), to a scale of 2 decimal places, for all policy holders who meet the following criteria:

-- Have the same TIV_2015 value as one or more other policyholders.
-- Are not located in the same city as any other policyholder (i.e.: the (latitude, longitude) attribute pairs must be unique).
-- Input Format:
-- The insurance table is described as follows:

-- | Column Name | Type          |
-- |-------------|---------------|
-- | PID         | INTEGER(11)   |
-- | TIV_2015    | NUMERIC(15,2) |
-- | TIV_2016    | NUMERIC(15,2) |
-- | LAT         | NUMERIC(5,2)  |
-- | LON         | NUMERIC(5,2)  |
-- where PID is the policyholder's policy ID, TIV_2015 is the total investment value in 2015, TIV_2016 is the total investment value in 2016, LAT is the latitude of the policy holder's city, and LON is the longitude of the policy holder's city.

-- Sample Input

-- | PID | TIV_2015 | TIV_2016 | LAT | LON |
-- |-----|----------|----------|-----|-----|
-- | 1   | 10       | 5        | 10  | 10  |
-- | 2   | 20       | 20       | 20  | 20  |
-- | 3   | 10       | 30       | 20  | 20  |
-- | 4   | 10       | 40       | 40  | 40  |
-- Sample Output

-- | TIV_2016 |
-- |----------|
-- | 45.00    |
-- Explanation

-- The first record in the table, like the last record, meets both of the two criteria.
-- The TIV_2015 value '10' is as the same as the third and forth record, and its location unique.

-- The second record does not meet any of the two criteria. Its TIV_2015 is not like any other policyholders.

-- And its location is the same with the third record, which makes the third record fail, too.

-- So, the result is the sum of TIV_2016 of the first and last record, which is 45.

-- Solution
select sum(TIV_2016) TIV_2016
from 
(select *, count(*) over (partition by TIV_2015) as c1, count(*) over (partition by LAT, LON) as c2
from insurance ) t
where c1 > 1 and c2 = 1; 



My sol:
Too many subqueries. needs improvement


with t1 as (
	select tiv_2015
	from insurance
	group by tiv_2015
	having count(tiv_2015) > 1
), t2 as (
	select lat
	from insurance
	group by lat
	having count(lat) = 1
), t3 as (
	select LON
	from insurance
	group by lon
	having count(lon) = 1
)
select round(sum(tiv_2016),2) as TIV_2016
from insurance where tiv_2015 in (select tiv_2015 from t1)
and lat in (select lat from t2)
and lon in (select lon from t3);




Prac sol:
1.
select sum(tiv_2016)
from insurance a
where tiv_2015  in (select tiv_2015 from insurance b where a.oid != b.oid)
and concat(lat, lon) not in (select concat(lat,lon) from insurance b where a.oid != b.oid)

2.
with t1 as (
select tiv_2015 from insurance
group by tiv_2015
having count(tiv_2015) > 1
), t2 as (
select concat(lat,lon) as lat from insurance a
group by concat(lat, lon)
having count(*) = 1
)
select sum(tiv_2016) as tot
from insurance
where tiv_2015 in (select tiv_2015 from t1)
and concat(lat,lon) in (select lat from t2)

3. 
with cte as (
select
*, count(tiv_2015) over(partition by tiv_2015) as cnt_2015,
count(*) over(partition by concat(lat,lon)) as cnt_lat_lon
from insurance
)
select sum(tiv_2016) as tot
from cte
where cnt_2015 > 1 and cnt_lat_lon = 1

























