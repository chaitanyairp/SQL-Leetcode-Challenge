-- Question 12
-- Given a Weather table, write a SQL query to find all dates' Ids with higher temperature compared to its previous (yesterday's) dates.

-- +---------+------------------+------------------+
-- | Id(INT) | RecordDate(DATE) | Temperature(INT) |
-- +---------+------------------+------------------+
-- |       1 |       2015-01-01 |               10 |
-- |       2 |       2015-01-02 |               25 |
-- |       3 |       2015-01-03 |               20 |
-- |       4 |       2015-01-04 |               30 |
-- +---------+------------------+------------------+
-- For example, return the following Ids for the above Weather table:

-- +----+
-- | Id |
-- +----+
-- |  2 |
-- |  4 |
-- +----+

-- Solution
select a.Id
from weather a, weather b
where a.Temperature>b.Temperature and  datediff(a.recorddate,b.recorddate)=1



My sol:

1.
with cte as (
select
id as id1,
recordDate as rd1,
temperature as t1,
rd0 = lag(recordDate) over(order by id),
t0 = lag(temperature) over(order by id)
from Weather_12
)
select id1
from cte
where datediff(day, rd0, rd1) = 1 and t1 > t0

2.
select a.id
from Weather_12 a inner join Weather_12 b on a.temperature > b.temperature
and datediff(day, b.recorddate, a.recorddate) = 1


























