--Question 94
-- Table Accounts:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+
-- the id is the primary key for this table.
-- This table contains the account id and the user name of each account.
 

-- Table Logins:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | login_date    | date    |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- This table contains the account id of the user who logged in and the login date. A user may log in multiple times in the day.
 

-- Write an SQL query to find the id and the name of active users.

-- Active users are those who logged in to their accounts for 5 or more consecutive days.

-- Return the result table ordered by the id.

-- The query result format is in the following example:

-- Accounts table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 1  | Winston  |
-- | 7  | Jonathan |
-- +----+----------+

-- Logins table:
-- +----+------------+
-- | id | login_date |
-- +----+------------+
-- | 7  | 2020-05-30 |
-- | 1  | 2020-05-30 |
-- | 7  | 2020-05-31 |
-- | 7  | 2020-06-01 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-02 |
-- | 7  | 2020-06-03 |
-- | 1  | 2020-06-07 |
-- | 7  | 2020-06-10 |
-- +----+------------+

-- Result table:
-- +----+----------+
-- | id | name     |
-- +----+----------+
-- | 7  | Jonathan |
-- +----+----------+
-- User Winston with id = 1 logged in 2 times only in 2 different days, so, Winston is not an active user.
-- User Jonathan with id = 7 logged in 7 times in 6 different days, five of them were consecutive days, so, Jonathan is an active user.

-- Solution
with t1 as (
select id,login_date,
lead(login_date,4) over(partition by id order by login_date) date_5
from (select distinct * from Logins) b
)

select distinct a.id, a.name from t1
inner join accounts a 
on t1.id = a.id
where datediff(t1.date_5,login_date) = 4
order by id


My sol:
-- Join 5 times : poor sol
select distinct a.id, ac.name
from Logins a inner join Logins b on a.id = b.id and datediff(day,a.login_date,b.login_date) = 1
inner join Logins c on b.id = c.id and datediff(day,b.login_date,c.login_date) = 1
inner join Logins d on c.id = d.id and datediff(day,c.login_date,d.login_date) = 1
inner join Logins e on d.id = e.id and datediff(day,d.login_date,e.login_date) = 1
inner join Accounts ac on e.id = ac.id

Prac: -- Too many joins or leads.. No need to do 5 joins. Just do a distinct and get 4 day
with cte as (
select distinct id, login_date from Logins
), t2 as (
select
 id,
 login_date as day1,
 lead(login_date,1) over(partition by id order by login_date) as day2,
 lead(login_date,2) over(partition by id order by login_date) as day3,
 lead(login_date,3) over(partition by id order by login_date) as day4,
 lead(login_date,4) over(partition by id order by login_date) as day5
from cte
)
select distinct id
from t2
where datediff(day, day1,day2) = 1 
and   datediff(day, day2,day3) = 1 
and   datediff(day, day3,day4) = 1 
and   datediff(day, day4,day5) = 1


select distinct a.id
from Logins a inner join Logins b on a.id = b.id and datediff(day,a.login_date, b.login_date) = 1
inner join Logins c on b.id = c.id and datediff(day,b.login_date, c.login_date) = 1
inner join Logins d on c.id = d.id and datediff(day,c.login_date, d.login_date) = 1
inner join Logins e on d.id = e.id and datediff(day,d.login_date, e.login_date) = 1

--
Good::
with cte as (
select distinct id, login_date
from Logins
), t2 as (
select
	id,
	login_date as day1,
	lead(login_date,4) over(partition by id order by login_date) as day5
from cte
)
select distinct id
from t2
where datediff(day,day1,day5) >= 4


