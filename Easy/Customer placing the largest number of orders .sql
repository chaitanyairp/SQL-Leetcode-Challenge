-- Question 8
-- Query the customer_number from the orders table for the customer who has placed the largest number of orders.

-- It is guaranteed that exactly one customer will have placed more orders than any other customer.

-- The orders table is defined as follows:

-- | Column            | Type      |
-- |-------------------|-----------|
-- | order_number (PK) | int       |
-- | customer_number   | int       |
-- | order_date        | date      |
-- | required_date     | date      |
-- | shipped_date      | date      |
-- | status            | char(15)  |
-- | comment           | char(200) |
-- Sample Input

-- | order_number | customer_number | order_date | required_date | shipped_date | status | comment |
-- |--------------|-----------------|------------|---------------|--------------|--------|---------|
-- | 1            | 1               | 2017-04-09 | 2017-04-13    | 2017-04-12   | Closed |         |
-- | 2            | 2               | 2017-04-15 | 2017-04-20    | 2017-04-18   | Closed |         |
-- | 3            | 3               | 2017-04-16 | 2017-04-25    | 2017-04-20   | Closed |         |
-- | 4            | 3               | 2017-04-18 | 2017-04-28    | 2017-04-25   | Closed |         |
-- Sample Output

-- | customer_number |
-- |-----------------|
-- | 3               |
-- Explanation

-- The customer with number '3' has two orders, 
-- which is greater than either customer '1' or '2' because each of them  only has one order. 
-- So the result is customer_number '3'.


Practice:
select customer_number from
  (select customer_number, count(*) as tot from orders1
   group by customer_number
   order by tot desc	
) t
limit 1


-- Solution
-- Ranking them according to the number of orders to have same rank for 
-- customers with same number of orders
With t1 as 
(
  Select customer_number, 
  Rank() over(order by count(customer_number) desc) as rk
  from orders
  group by customer_number
) 

Select t1.customer_number
from t1
where t1.rk=1

My sol:
with cte as (
select 
customer_number,
rank() over(order by count(order_number) desc) as rn
from orders
group by customer_number
)
select customer_number from cte where rn = 1






