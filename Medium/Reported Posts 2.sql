-- Question 73
-- Table: Actions

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | user_id       | int     |
-- | post_id       | int     |
-- | action_date   | date    |
-- | action        | enum    |
-- | extra         | varchar |
-- +---------------+---------+
-- There is no primary key for this table, it may have duplicate rows.
-- The action column is an ENUM type of ('view', 'like', 'reaction', 'comment', 'report', 'share').
-- The extra column has optional information about the action such as a reason for report or a type of reaction. 
-- Table: Removals

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | post_id       | int     |
-- | remove_date   | date    | 
-- +---------------+---------+
-- post_id is the primary key of this table.
-- Each row in this table indicates that some post was removed as a result of being reported or as a result of an admin review.
 

-- Write an SQL query to find the average for daily percentage of posts that got removed after being reported as spam, rounded to 2 decimal places.

-- The query result format is in the following example:

-- Actions table:
-- +---------+---------+-------------+--------+--------+
-- | user_id | post_id | action_date | action | extra  |
-- +---------+---------+-------------+--------+--------+
-- | 1       | 1       | 2019-07-01  | view   | null   |
-- | 1       | 1       | 2019-07-01  | like   | null   |
-- | 1       | 1       | 2019-07-01  | share  | null   |
-- | 2       | 2       | 2019-07-04  | view   | null   |
-- | 2       | 2       | 2019-07-04  | report | spam   |
-- | 3       | 4       | 2019-07-04  | view   | null   |
-- | 3       | 4       | 2019-07-04  | report | spam   |
-- | 4       | 3       | 2019-07-02  | view   | null   |
-- | 4       | 3       | 2019-07-02  | report | spam   |
-- | 5       | 2       | 2019-07-03  | view   | null   |
-- | 5       | 2       | 2019-07-03  | report | racism |
-- | 5       | 5       | 2019-07-03  | view   | null   |
-- | 5       | 5       | 2019-07-03  | report | racism |
-- +---------+---------+-------------+--------+--------+

-- Removals table:
-- +---------+-------------+
-- | post_id | remove_date |
-- +---------+-------------+
-- | 2       | 2019-07-20  |
-- | 3       | 2019-07-18  |
-- +---------+-------------+

-- Result table:
-- +-----------------------+
-- | average_daily_percent |
-- +-----------------------+
-- | 75.00                 |
-- +-----------------------+
-- The percentage for 2019-07-04 is 50% because only one post of two spam reported posts was removed.
-- The percentage for 2019-07-02 is 100% because one post was reported as spam and it was removed.
-- The other days had no spam reports so the average is (50 + 100) / 2 = 75%
-- Note that the output is only one number and that we do not care about the remove dates.

-- Solution
with t1 as(
select a.action_date, (count(distinct r.post_id)+0.0)/(count(distinct a.post_id)+0.0) as result
from (select action_date, post_id
from actions
where extra = 'spam' and action = 'report') a
left join
removals r
on a.post_id = r.post_id
group by a.action_date)

select round(avg(t1.result)*100,2) as  average_daily_percent
from t1


My sol:
with temp as (
select action_date, round(count(r.post_id) * 1.0 / count(*),2) * 100 as daily_percent
from actions a left join removals r on a.post_id = r.post_id 
where extra = 'spam'
group by action_date
)
select round(avg(daily_percent),2)
from temp


Prac sol:

with cte as (
select action_date, count(r.post_id) as removed_posts, count(*) as total_posts, (1.0*count(r.post_id)/count(*))*100 as percnt
from actions a left join removals r on a.post_id = r.post_id
where a.extra = 'spam'
group by a.action_date
)
select avg(percnt) as daily_percnt
from cte

Prac:
with cte as (
select a.action_date, count(a.post_id) as rep_cnt, count(r.post_id) as rem_cnt
from actions a left join removals r on a.post_id = r.post_id
where extra = 'spam'
group by a.action_date
)
select avg(100.00*rem_cnt/rep_cnt)
from cte









