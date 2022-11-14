-- Question 64
-- Table: Books

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | book_id        | int     |
-- | name           | varchar |
-- | available_from | date    |
-- +----------------+---------+
-- book_id is the primary key of this table.
-- Table: Orders

-- +----------------+---------+
-- | Column Name    | Type    |
-- +----------------+---------+
-- | order_id       | int     |
-- | book_id        | int     |
-- | quantity       | int     |
-- | dispatch_date  | date    |
-- +----------------+---------+
-- order_id is the primary key of this table.
-- book_id is a foreign key to the Books table.
 

-- Write an SQL query that reports the books that have sold less than 10 copies in the last year, excluding books that have been available for less than 1 month from today. Assume today is 2019-06-23.

-- The query result format is in the following example:

-- Books table:
-- +---------+--------------------+----------------+
-- | book_id | name               | available_from |
-- +---------+--------------------+----------------+
-- | 1       | "Kalila And Demna" | 2010-01-01     |
-- | 2       | "28 Letters"       | 2012-05-12     |
-- | 3       | "The Hobbit"       | 2019-06-10     |
-- | 4       | "13 Reasons Why"   | 2019-06-01     |
-- | 5       | "The Hunger Games" | 2008-09-21     |
-- +---------+--------------------+----------------+

-- Orders table:
-- +----------+---------+----------+---------------+
-- | order_id | book_id | quantity | dispatch_date |
-- +----------+---------+----------+---------------+
-- | 1        | 1       | 2        | 2018-07-26    |
-- | 2        | 1       | 1        | 2018-11-05    |
-- | 3        | 3       | 8        | 2019-06-11    |
-- | 4        | 4       | 6        | 2019-06-05    |
-- | 5        | 4       | 5        | 2019-06-20    |
-- | 6        | 5       | 9        | 2009-02-02    |
-- | 7        | 5       | 8        | 2010-04-13    |
-- +----------+---------+----------+---------------+

-- Result table:
-- +-----------+--------------------+
-- | book_id   | name               |
-- +-----------+--------------------+
-- | 1         | "Kalila And Demna" |
-- | 2         | "28 Letters"       |
-- | 5         | "The Hunger Games" |
-- +-----------+--------------------+

-- Solution
select b.book_id, name
from
(select *
from books
where available_from < '2019-05-23') b
left join
(select *
from orders 
where dispatch_date > '2018-06-23') a
on a.book_id = b.book_id
group by b.book_id, name
having coalesce(sum(quantity),0)<10



My Solution:
select b.book_id, min(b.name), sum(case when year(dispatch_date) = 2018 then quantity else 0 end) as qty
from books b left join orders o on o.book_id = b.book_id
where datediff(day, available_from, '2019-06-23') >= 30
group by b.book_id
having(sum(case when year(dispatch_date) = 2018 then quantity else 0 end)) < 10



with t1 as (
select book_id, sum(quantity) as qty
from orders
where year(dispatch_date) = 2018
group by book_id
), t2 as (
select book_id, name
from books
where datediff(day, available_from, '2019-06-23') > 30
)
select t2.book_id, name
from t2 left join t1 on t2.book_id = t1.book_id
group by t2.book_id, name
having sum(coalesce(qty, 0)) < 10
order by 1


with t1 as (
select book_id, name, available_from
from Books
where available_from < dateadd(month, -1, '2019-06-23')
)
select t1.book_id, t1.name
from t1 left join Orders o on t1.book_id = o.book_id
group by t1.book_id, t1.name
having sum(case when year(dispatch_date) = 2018 then 1 else 0 end) < 10



Prac:
with books as (
select book_id, name
from Books
where datediff(day, available_from, '2019-06-23') > 30
), orders as (
select book_id, sum(quantity) as tot
from orders
where year(dispatch_date) = 2018
group by book_id
), agg as (
select book_id, name, coalesce(tot, 0)
from books b left join orders o on b.book_id = o.book_id
)
select book_id, name
from agg
where tot <= 10 


