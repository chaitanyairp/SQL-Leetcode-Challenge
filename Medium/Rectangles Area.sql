-- Question 79
-- Table: Points

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | id            | int     |
-- | x_value       | int     |
-- | y_value       | int     |
-- +---------------+---------+
-- id is the primary key for this table.
-- Each point is represented as a 2D Dimensional (x_value, y_value).
-- Write an SQL query to report of all possible rectangles which can be formed by any two points of the table. 

-- Each row in the result contains three columns (p1, p2, area) where:

-- p1 and p2 are the id of two opposite corners of a rectangle and p1 < p2.
-- Area of this rectangle is represented by the column area.
-- Report the query in descending order by area in case of tie in ascending order by p1 and p2.

-- Points table:
-- +----------+-------------+-------------+
-- | id       | x_value     | y_value     |
-- +----------+-------------+-------------+
-- | 1        | 2           | 8           |
-- | 2        | 4           | 7           |
-- | 3        | 2           | 10          |
-- +----------+-------------+-------------+

-- Result table:
-- +----------+-------------+-------------+
-- | p1       | p2          | area        |
-- +----------+-------------+-------------+
-- | 2        | 3           | 6           |
-- | 1        | 2           | 2           |
-- +----------+-------------+-------------+

-- p1 should be less than p2 and area greater than 0.
-- p1 = 1 and p2 = 2, has an area equal to |2-4| * |8-7| = 2.
-- p1 = 2 and p2 = 3, has an area equal to |4-2| * |7-10| = 6.
-- p1 = 1 and p2 = 3 It's not possible because the rectangle has an area equal to 0.

-- Solution
select p1.id as p1, p2.id as p2, abs(p1.x_value-p2.x_value)*abs(p1.y_value-p2.y_value) as area
from points p1 cross join points p2
where p1.x_value!=p2.x_value and p1.y_value!=p2.y_value and p1.id<p2.id
order by area desc, p1, p2




My sol:
with cte as (
select p1.id as 'p1', p1.x_value as 'x1', p1.y_value as 'y1', p2.id as 'p2', p2.x_value as 'x2', p2.y_value as 'y2'
from points p1 cross join points p2
where p1.x_value != p2.x_value and p1.y_value != p2.y_value and p1.id < p2.id
)
select p1, p2, abs(x1-x2) * abs(y1-y2) as area 
from cte
order by area desc, p1, p2;

Prac sol:
select a.id as p1, b.id as p2, abs(a.x_value - b.x_value) * abs(a.y_value - b.y_value) as area
from points a cross join points b
where a.id < b.id and a.x_value != b.x_value and a.y_value != b.y_value
order by 3 desc, 1, 2









