-- Question 11
-- Write a SQL query to find all duplicate emails in a table named Person.

-- +----+---------+
-- | Id | Email   |
-- +----+---------+
-- | 1  | a@b.com |
-- | 2  | c@d.com |
-- | 3  | a@b.com |
-- +----+---------+
-- For example, your query should return the following for the above table:

-- +---------+
-- | Email   |
-- +---------+
-- | a@b.com |
-- +---------+


-- Solution
Select Email
from
(Select Email, count(Email)
from person
group by Email
having count(Email)>1) a


My sol:

with cte as (
select
id, email, rn = row_number() over(partition by email order by id)
from Person
)
select distinct email
from cte
where rn > 1







