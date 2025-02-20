-- Question 113
-- Table: Spending

-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | spend_date  | date    |
-- | platform    | enum    | 
-- | amount      | int     |
-- +-------------+---------+
-- The table logs the spendings history of users that make purchases from an online shopping website which has a desktop and a mobile application.
-- (user_id, spend_date, platform) is the primary key of this table.
-- The platform column is an ENUM type of ('desktop', 'mobile').
-- Write an SQL query to find the total number of users and the total amount spent using mobile only, desktop only and both mobile and desktop together for each date.

-- The query result format is in the following example:

-- Spending table:
-- +---------+------------+----------+--------+
-- | user_id | spend_date | platform | amount |
-- +---------+------------+----------+--------+
-- | 1       | 2019-07-01 | mobile   | 100    |
-- | 1       | 2019-07-01 | desktop  | 100    |
-- | 2       | 2019-07-01 | mobile   | 100    |
-- | 2       | 2019-07-02 | mobile   | 100    |
-- | 3       | 2019-07-01 | desktop  | 100    |
-- | 3       | 2019-07-02 | desktop  | 100    |
-- +---------+------------+----------+--------+

-- Result table:
-- +------------+----------+--------------+-------------+
-- | spend_date | platform | total_amount | total_users |
-- +------------+----------+--------------+-------------+
-- | 2019-07-01 | desktop  | 100          | 1           |
-- | 2019-07-01 | mobile   | 100          | 1           |
-- | 2019-07-01 | both     | 200          | 1           |
-- | 2019-07-02 | desktop  | 100          | 1           |
-- | 2019-07-02 | mobile   | 100          | 1           |
-- | 2019-07-02 | both     | 0            | 0           |
-- +------------+----------+--------------+-------------+ 
-- On 2019-07-01, user 1 purchased using both desktop and mobile, user 2 purchased using mobile only and user 3 purchased using desktop only.
-- On 2019-07-02, user 2 purchased using mobile only, user 3 purchased using desktop only and no one purchased using both platforms.

-- Solution
SELECT p.spend_date, p.platform, IFNULL(SUM(amount), 0) total_amount, COUNT(DISTINCT u.user_id) total_users
FROM
(
SELECT DISTINCT(spend_date), 'desktop' platform FROM Spending
UNION
SELECT DISTINCT(spend_date), 'mobile' platform FROM Spending
UNION
SELECT DISTINCT(spend_date), 'both' platform FROM Spending
) p LEFT JOIN

(SELECT user_id, spend_date, SUM(amount) amount, (CASE WHEN COUNT(DISTINCT platform)>1 THEN "both" ELSE platform END) platform
FROM Spending
GROUP BY spend_date, user_id) u

ON p.platform = u.platform AND p.spend_date=u.spend_date

GROUP BY p.spend_date, p.platform




My sol:
1.
with t1 as (
select
user_id,
spend_date,
mobile_amnt = sum(case when platform = 'mobile' then amount else 0 end),
desktop_amnt = sum(case when platform = 'desktop' then amount else 0 end),
mobile_cnt = sum(case when platform = 'mobile' then 1 else 0 end),
desktop_cnt = sum(case when platform = 'desktop' then 1 else 0 end)
from Spending
group by spend_date, user_id
), t2 as (
select spend_date, 'mobile' as platform, sum(mobile_amnt) as total_amount, count(distinct user_id) as total_users 
from t1 where mobile_cnt = 1 and desktop_cnt = 0
group by spend_date
union all
select spend_date, 'desktop' as platform, sum(desktop_amnt) as total_amount, count(distinct user_id) as total_users 
from t1 where mobile_cnt = 0 and desktop_cnt = 1
group by spend_date
), t3 as (
select distinct spend_date from Spending
), t4 as (
select *
from t1 where desktop_cnt > 0 and mobile_cnt > 0
), t5 as (
select t3.spend_date,'both' as platform, 
sum(coalesce(mobile_amnt, 0)) + sum(coalesce(desktop_amnt, 0)) as total_amount,
count(distinct user_id) as total_users
from t3 left join t4 on t3.spend_date = t4.spend_date
group by t3.spend_date
union all
select * from t2
)
select * from t5 order by spend_date, platform





