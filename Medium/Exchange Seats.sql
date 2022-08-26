-- Question 56
-- Mary is a teacher in a middle school and she has a table seat storing students' names and their corresponding seat ids.

-- The column id is continuous increment.
 

-- Mary wants to change seats for the adjacent students.
 

-- Can you write a SQL query to output the result for Mary?
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Abbot   |
-- |    2    | Doris   |
-- |    3    | Emerson |
-- |    4    | Green   |
-- |    5    | Jeames  |
-- +---------+---------+
-- For the sample input, the output is:
 

-- +---------+---------+
-- |    id   | student |
-- +---------+---------+
-- |    1    | Doris   |
-- |    2    | Abbot   |
-- |    3    | Green   |
-- |    4    | Emerson |
-- |    5    | Jeames  |
-- +---------+---------+

-- Solution
select row_number() over (order by (if(id%2=1,id+1,id-1))) as id, student
from seat


My sol:

with cte as (
select
	id,
	student,
	lag(id,1) over(order by id) as id1,
	lead(id, 1) over(order by id) as id2
from seats
)
select
	id = (case when id % 2 = 1 and id2 is not null then id + 1
		 when id % 2 = 1 and id2 is null then id
		 when id % 2 = 0 and id1 is not null then id - 1
		 when id % 2 = 0 and id1 is null then id
	end),
	student
from cte
order by id

