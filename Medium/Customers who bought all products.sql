-- Question 93
-- Table: Customer

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | product_key | int     |
-- +-------------+---------+
-- product_key is a foreign key to Product table.
-- Table: Product

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | product_key | int     |
-- +-------------+---------+
-- product_key is the primary key column for this table.
 

-- Write an SQL query for a report that provides the customer ids from the Customer table that bought all the products in the Product table.

-- For example:

-- Customer table:
-- +-------------+-------------+
-- | customer_id | product_key |
-- +-------------+-------------+
-- | 1           | 5           |
-- | 2           | 6           |
-- | 3           | 5           |
-- | 3           | 6           |
-- | 1           | 6           |
-- +-------------+-------------+

-- Product table:
-- +-------------+
-- | product_key |
-- +-------------+
-- | 5           |
-- | 6           |
-- +-------------+

-- Result table:
-- +-------------+
-- | customer_id |
-- +-------------+
-- | 1           |
-- | 3           |
-- +-------------+
-- The customers who bought all the products (5 and 6) are customers with id 1 and 3.

-- Solution
select customer_id
from customer
group by customer_id
having count(distinct product_key) = (select COUNT(distinct product_key) from product)


My sol:
Its a foreign key. No need of join. Read the damm question.
with t1 as (
select customer_id, c.product_key, p.product_key as product
from customer_93 c left join product_93 p on c.product_key = p.product_key
)
select customer_id
from t1
group by customer_id
having count(distinct product) = (select count(product_key) from product_93)


Prac sol:
select customer_id
from (select distinct customer_id, product_key from customer_93) a
group by customer_id
having count(*) = (select count(*) from product_93)
