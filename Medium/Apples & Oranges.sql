-- Question 66
-- Table: Sales

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | sale_date     | date    |
-- | fruit         | enum    | 
-- | sold_num      | int     | 
-- +---------------+---------+
-- (sale_date,fruit) is the primary key for this table.
-- This table contains the sales of "apples" and "oranges" sold each day.
 

-- Write an SQL query to report the difference between number of apples and oranges sold each day.

-- Return the result table ordered by sale_date in format ('YYYY-MM-DD').

-- The query result format is in the following example:

 

-- Sales table:
-- +------------+------------+-------------+
-- | sale_date  | fruit      | sold_num    |
-- +------------+------------+-------------+
-- | 2020-05-01 | apples     | 10          |
-- | 2020-05-01 | oranges    | 8           |
-- | 2020-05-02 | apples     | 15          |
-- | 2020-05-02 | oranges    | 15          |
-- | 2020-05-03 | apples     | 20          |
-- | 2020-05-03 | oranges    | 0           |
-- | 2020-05-04 | apples     | 15          |
-- | 2020-05-04 | oranges    | 16          |
-- +------------+------------+-------------+

-- Result table:
-- +------------+--------------+
-- | sale_date  | diff         |
-- +------------+--------------+
-- | 2020-05-01 | 2            |
-- | 2020-05-02 | 0            |
-- | 2020-05-03 | 20           |
-- | 2020-05-04 | -1           |
-- +------------+--------------+

-- Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
-- Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
-- Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
-- Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).

-- Solution
Select sale_date, sold_num-sold as diff
from 
((select *
from sales
where fruit = 'apples') a
join 
(select sale_date as sale, fruit, sold_num as sold
from sales
where fruit = 'oranges') b
on a.sale_date = b.sale) 


My sol:
with t1 as (
select
	sale_date,
	sum(case when fruit = 'apples' then sold_num else 0 end) as apples_sold,
	sum(case when fruit = 'oranges' then sold_num else 0 end) as oranges_sold
from sales_66
group by sale_date
)
select sale_date, apples_sold - oranges_sold as diff from t1;

2.
select 
a.sale_date, 
diff = (a.sold_num - b.sold_num)
from sales_66 a inner join sales_66 b on a.sale_date = b.sale_date and a.fruit = 'apples' and b.fruit = 'oranges'


















