-- Question 67
-- Table: Products

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | new_price     | int     |
-- | change_date   | date    |
-- +---------------+---------+
-- (product_id, change_date) is the primary key of this table.
-- Each row of this table indicates that the price of some product was changed to a new price at some date.
 

-- Write an SQL query to find the prices of all products on 2019-08-16. Assume the price of all products before any change is 10.

-- The query result format is in the following example:

-- Products table:
-- +------------+-----------+-------------+
-- | product_id | new_price | change_date |
-- +------------+-----------+-------------+
-- | 1          | 20        | 2019-08-14  |
-- | 2          | 50        | 2019-08-14  |
-- | 1          | 30        | 2019-08-15  |
-- | 1          | 35        | 2019-08-16  |
-- | 2          | 65        | 2019-08-17  |
-- | 3          | 20        | 2019-08-18  |
-- +------------+-----------+-------------+

-- Result table:
-- +------------+-------+
-- | product_id | price |
-- +------------+-------+
-- | 2          | 50    |
-- | 1          | 35    |
-- | 3          | 10    |
-- +------------+-------+

-- Solution
with t1 as (
select a.product_id, new_price
from(
Select product_id, max(change_date) as date
from products
where change_date<='2019-08-16'
group by product_id) a
join products p
on a.product_id = p.product_id and a.date = p.change_date),

t2 as (
select distinct product_id
	from products)
	
select t2.product_id, coalesce(new_price,10) as price
from t2 left join t1
on t2.product_id = t1.product_id
order by price desc



My sol:
-- Colud have used left join insted of union. Check this

with products_curr as (
	select product_id, new_price, change_date, row_number() over(partition by product_id order by change_date desc) as rn
	from products 
	where change_date <= '2019-08-16'
	
)
select product_id, new_price as price from products_curr where rn = 1
union
select product_id, 10 as price from products
where product_id not in (select product_id from products_curr);


Prac: Execute this later
with product_dis as (
select distinct product_id from products
), product_rn as (
select product_id, new_price, rank() over(partition by product_id order by change_date) as rn
from products
)
select a.product_id, coalesce(b.new_price, 10) as price
from product_dis a left join product_rn b on a.product_id = b.product_id
where b.rn = 1
