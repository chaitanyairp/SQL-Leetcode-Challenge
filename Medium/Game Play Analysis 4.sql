-- Question 91
-- Table: Activity

-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | player_id    | int     |
-- | device_id    | int     |
-- | event_date   | date    |
-- | games_played | int     |
-- +--------------+---------+
-- (player_id, event_date) is the primary key of this table.
-- This table shows the activity of players of some game.
-- Each row is a record of a player who logged in and played a number of games (possibly 0) 
-- before logging out on some day using some device.
 

-- Write an SQL query that reports the fraction of players that logged in again 
-- on the day after the day they first logged in, rounded to 2 decimal places. 
-- In other words, you need to count the number of players that logged in for at least two consecutive 
-- days starting from their first login date, then divide that number by the total number of players.

-- The query result format is in the following example:

-- Activity table:
-- +-----------+-----------+------------+--------------+
-- | player_id | device_id | event_date | games_played |
-- +-----------+-----------+------------+--------------+
-- | 1         | 2         | 2016-03-01 | 5            |
-- | 1         | 2         | 2016-03-02 | 6            |
-- | 2         | 3         | 2017-06-25 | 1            |
-- | 3         | 1         | 2016-03-02 | 0            |
-- | 3         | 4         | 2018-07-03 | 5            |
-- +-----------+-----------+------------+--------------+

-- Result table:
-- +-----------+
-- | fraction  |
-- +-----------+
-- | 0.33      |
-- +-----------+
-- Only the player with id 1 logged back in after the first day he had logged in so the answer is 1/3 = 0.33

-- Solution
With t as 
(select player_id,
 min(event_date) over(partition by player_id) as min_event_date,
 case when event_date- min(event_date) over(partition by player_id) = 1 then 1 
 else 0 
 end as s
 from Activity)

select round(sum(t.s)/count(distinct t.player_id),2) as fraction 
from t


My sol:
Using lead:
with cte as (
select
	player_id,
	event_date as first_day,
	second_day = lead(event_date,1) over(partition by player_id order by event_date) 
from Activity_91
)
select
	fraction = sum(case when datediff(day,first_day,second_day) = 1 then 1.0 else 0 end)/count(distinct player_id)
from cte


Using inner join:
with t1 as(
select count(*)	as cnt
from Activity_91 a inner join Activity_91 b on a.player_id = b.player_id and datediff(day, a.event_date,b.event_date) = 1
)
select cnt/(select count(distinct player_id)*1.0 from Activity_91) as fraction
from t1






