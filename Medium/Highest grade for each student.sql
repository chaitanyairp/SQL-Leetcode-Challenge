-- Question 63
-- Table: Enrollments

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | course_id     | int     |
-- | grade         | int     |
-- +---------------+---------+
-- (student_id, course_id) is the primary key of this table.

-- Write a SQL query to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id. The output must be sorted by increasing student_id.

-- The query result format is in the following example:

-- Enrollments table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 2          | 2         | 95    |
-- | 2          | 3         | 95    |
-- | 1          | 1         | 90    |
-- | 1          | 2         | 99    |
-- | 3          | 1         | 80    |
-- | 3          | 2         | 75    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Result table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+

-- Solution
select student_id, course_id, grade
from(
select student_id, course_id, grade,
rank() over(partition by student_id order by grade desc, course_id) as rk
from enrollments) a
where a.rk = 1



My sol:
with cte as (
select
	student_id,
	course_id,
	grade,
	rank() over(partition by student_id order by grade desc, course_id) as rn
from Enrollements
)
select student_id, course_id, grade from cte
where rn = 1



Prac sol:
with cte as (
select
student_id,
course_id,
grade,
rank() over(partition by student_id order by grade desc, course_id) as rn
from Enrollements
)
select * from cte where rn = 1;


2.
with cte as (
select
student_id, max(grade) as max_grade
from Enrollements
group by student_id
)
select e.student_id, min(course_id) as course_id, max(e.grade) as grade 
from Enrollements e inner join cte c on e.student_id = c.student_id and e.grade = c.max_grade
group by e.student_id


















