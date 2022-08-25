-- Question 52
-- Write a SQL query to find all numbers that appear at least three times consecutively.

-- +----+-----+
-- | Id | Num |
-- +----+-----+
-- | 1  |  1  |
-- | 2  |  1  |
-- | 3  |  1  |
-- | 4  |  2  |
-- | 5  |  1  |
-- | 6  |  2  |
-- | 7  |  2  |
-- +----+-----+
-- For example, given the above Logs table, 1 is the only number that appears consecutively for at least three times.

-- +-----------------+
-- | ConsecutiveNums |
-- +-----------------+
-- | 1               |
-- +-----------------+

-- Solution
select distinct a.num as ConsecutiveNums
from(
select *,
lag(num) over() as prev,
lead(num) over() as next
from logs) a
where a.num = a.prev and a.num=a.next

My sol:
with t1 as (
select
	id as id1,
	num as num1,
	lead(id,1) over(order by id) as id2,
	lead(num,1) over(order by id) as num2,
	lead(id,2) over(order by id) as id3,
	lead(num,2) over(order by id) as num3
from logs
)
select num1 as consecutive_nums
from t1
where num1 = num2 and num2 = num3 and id2 - id1 = 1 and id3 - id2 = 1

Using join:
select a.num
from logs a inner join logs b on b.id - a.id = 1 and a.num = b.num
inner join logs c on c.id - b.id = 1 and c.num = b.num




