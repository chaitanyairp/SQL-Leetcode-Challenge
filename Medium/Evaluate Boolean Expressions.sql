-- Question 78
-- Table Variables:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- name is the primary key for this table.
-- This table contains the stored variables and their values.
 

-- Table Expressions:

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
 

-- Write an SQL query to evaluate the boolean expressions in Expressions table.

-- Return the result table in any order.

-- The query result format is in the following example.

-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+

-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+

-- Result table:
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- As shown, you need find the value of each boolean exprssion in the table using the variables table.

-- Solution
with t1 as(
select e.left_operand, e.operator, e.right_operand, v.value as left_val, v_1.value as right_val
from expressions e
join variables v
on v.name = e.left_operand 
join variables v_1
on v_1.name = e.right_operand)

select t1.left_operand, t1.operator, t1.right_operand,
case when t1.operator = '<' then (select t1.left_val< t1.right_val)
when t1.operator = '>' then (select t1.left_val > t1.right_val)
when t1.operator = '=' then (select t1.left_val = t1.right_val)
else FALSE
END AS VALUE
from t1


My sol:

with t1 as (
select
	left_operand,
	left_value = (select value from Variables v where e.left_operand = v.name),
	right_operand,
	right_value = (select value from Variables v where e.right_operand = v.name),
	operator
from Expressions e)
select
	left_operand,
	operator,
	right_operand,
	value = (case 
				when operator = '<' then IIF (left_value < right_value, 'TRUE', 'FALSE') 
				when operator = '=' then IIF (left_value = right_value, 'TRUE','FALSE')
				when operator = '>' then IIF (left_value > right_value, 'TRUE','FALSE')
			end)
from t1


Prac sol:
1.
with cte as (
select 
left_operand,
operator,
right_operand,
val1 = (select value from variables v where v.name = e.left_operand),
val2 = (select value from variables v where v.name = e.right_operand)
from expressions e
)
select
left_operand,
operator,
right_operand,
value = (case
		when operator = '<' then IIF(left_operand < right_operand,'TRUE','FALSE')
		when operator = '>' then IIF(left_operand > right_operand,'TRUE','FALSE')
		else IIF(left_operand = right_operand, 'TRUE','FALSE')
	   end)
from cte


2.
with cte as (
select e.left_operand,e.operator,e.right_operand,a.value as avalue,b.value as bvalue
from expressions e inner join variables a on e.left_operand = a.name
inner join variables b on e.right_operand = b.name
)
select * from cte
























