-- Question 86
-- Get the highest answer rate question from a table survey_log with these columns: id, action, question_id, answer_id, q_num, timestamp.

-- id means user id; action has these kind of values: "show", "answer", "skip"; answer_id is not null when action column is "answer", 
-- while is null for "show" and "skip"; q_num is the numeral order of the question in current session.

-- Write a sql query to identify the question which has the highest answer rate.

-- Example:

-- Input:
-- +------+-----------+--------------+------------+-----------+------------+
-- | id   | action    | question_id  | answer_id  | q_num     | timestamp  |
-- +------+-----------+--------------+------------+-----------+------------+
-- | 5    | show      | 285          | null       | 1         | 123        |
-- | 5    | answer    | 285          | 124124     | 1         | 124        |
-- | 5    | show      | 369          | null       | 2         | 125        |
-- | 5    | skip      | 369          | null       | 2         | 126        |
-- +------+-----------+--------------+------------+-----------+------------+
-- Output:
-- +-------------+
-- | survey_log  |
-- +-------------+
-- |    285      |
-- +-------------+
-- Explanation:
-- question 285 has answer rate 1/1, while question 369 has 0/1 answer rate, so output 285.
 

-- Note: The highest answer rate meaning is: answer number's ratio in show number in the same question.

-- Solution
with t1 as(
select a.question_id, coalesce(b.answer/a.show_1,0) as rate
from 
(select question_id, coalesce(count(*),0) as show_1
from survey_log
where action != 'answer'
group by question_id) a
left join
(select question_id, coalesce(count(*),0) as answer
from survey_log
where action = 'answer'
group by question_id) b
on a.question_id = b.question_id)

select a.question_id as survey_log
from 
( select t1.question_id,
rank() over(order by rate desc) as rk
from t1) a
where a.rk = 1


My sol:

with t1 as (
select 
	question_id, 
	sum(case when action = 'show' then 1 else 0 end) as show_cnt,
	sum(case when action = 'answer' then 1 else 0 end) as ans_cnt
from survery_log
group by question_id
), t2 as (
	select
		question_id,
		round(ans_cnt*1.0/show_cnt,2) as rate,
		rank() over(order by round(ans_cnt*1.0/show_cnt,2) desc) as rn
	from t1
)
select question_id from t2 where rn = 1;

Prac sol:


with cte as (
select
question_id,
show_count = sum(case when action = 'show' then 1 else 0 end),
answer_count = sum(case when action = 'answer' then 1 else 0 end)
from survery_log
group by question_id
), t2 as (
select
question_id, rank() over(order by (1.0*answer_count/show_count) desc) as rn
from cte
)
select * from t2
where rn = 1


