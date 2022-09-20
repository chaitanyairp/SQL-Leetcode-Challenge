-- Question 72
-- Table: Customers

-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the primary key for this table.
-- customer_name is the name of the customer.
 

-- Table: Orders

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the primary key for this table.
-- customer_id is the id of the customer who bought the product "product_name".
 

-- Write an SQL query to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them buy this product.

-- Return the result table ordered by customer_id.

-- The query result format is in the following example.

 

-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+

-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+

-- Result table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Only the customer_id with id 3 bought the product A and B but not the product C.

-- Solution
with t1 as
(
select customer_id
from orders
where product_name = 'B' and
customer_id in (select customer_id
from orders
where product_name = 'A'))

Select t1.customer_id, c.customer_name
from t1 join customers c
on t1.customer_id = c.customer_id
where t1.customer_id != all(select customer_id
from orders
where product_name = 'C')



My sol:

SELECT
	min(o.customer_id) as customer_id,
	c.customer_name as customer_name
FROM ORDERS_72 O INNER JOIN CUSTOMERS_72 C ON C.CUSTOMER_ID = O.CUSTOMER_ID
group by c.customer_name
having sum(case when o.product_name = 'A' then 1 else 0 end) >= 1
   and sum(case when o.product_name = 'B' then 1 else 0 end) >= 1
   and sum(case when o.product_name = 'C' then 1 else 0 end) = 0


select
	distinct o.customer_id,
	c.customer_name
from orders_72 o inner join customers_72 c on c.customer_id = o.customer_id 
where o.customer_id in (select distinct customer_id from orders_72 where product_name = 'A')
and o.customer_id in (select distinct customer_id from orders_72 where product_name = 'B')
and o.customer_id not in (select distinct customer_id from orders_72 where product_name = 'C')



with cte as (
select
	o.customer_id, min(c.customer_name) as customer_name,
	a_count = sum(case when product_name = 'A' then 1 else 0 end),
	b_count = sum(case when product_name = 'B' then 1 else 0 end),
	c_count = sum(case when product_name = 'C' then 1 else 0 end)
from orders_72 o inner join customers_72 c on o.customer_id = c.customer_id
group by o.customer_id)
select customer_id, customer_name from cte where a_count >= 1 and b_count >= 1 and c_count = 0


Prac sol:
with cte as (
select 
customer_id,
a_count = sum(case when product_name = 'A' then 1 else 0 end),
b_count = sum(case when product_name = 'B' then 1 else 0 end),
c_count = sum(case when product_name = 'C' then 1 else 0 end)
from orders_72
group by customer_id
)
select a.customer_id, b.customer_name
from cte a inner join customers_72 b on a.customer_id = b.customer_id
where a_count >= 1 and b_count >= 1 and c_count = 0



















