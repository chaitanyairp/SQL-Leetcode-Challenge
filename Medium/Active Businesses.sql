-- Question 65
-- Table: Events

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | business_id   | int     |
-- | event_type    | varchar |
-- | occurences    | int     | 
-- +---------------+---------+
-- (business_id, event_type) is the primary key of this table.
-- Each row in the table logs the info that an event of some type occured at some business for a number of times.
 

-- Write an SQL query to find all active businesses.

-- An active business is a business that has more than one event type with occurences greater than the average occurences of that event type among all businesses.

-- The query result format is in the following example:

-- Events table:
-- +-------------+------------+------------+
-- | business_id | event_type | occurences |
-- +-------------+------------+------------+
-- | 1           | reviews    | 7          |
-- | 3           | reviews    | 3          |
-- | 1           | ads        | 11         |
-- | 2           | ads        | 7          |
-- | 3           | ads        | 6          |
-- | 1           | page views | 3          |
-- | 2           | page views | 12         |
-- +-------------+------------+------------+

-- Result table:
-- +-------------+
-- | business_id |
-- +-------------+
-- | 1           |
-- +-------------+ 
-- Average for 'reviews', 'ads' and 'page views' are (7+3)/2=5, (11+7+6)/3=8, (3+12)/2=7.5 respectively.
-- Business with id 1 has 7 'reviews' events (more than 5) and 11 'ads' events (more than 8) so it is an active business.

-- Solution
select c.business_id
from(
select *
from events e
join
(select event_type as event, round(avg(occurences),2) as average from events group by event_type) b
on e.event_type = b.event) c
where c.occurences>c.average
group by c.business_id
having count(*) > 1


My sol: 
select distinct business_id from (
select
	business_id,
	event_type,
	occurences,
	average_occ = (avg(occurences) over(partition by event_type))
from events) e
where occurences > average_occ
group by business_id
having count(business_id) > 1

with cte as (
select event_type, avg(occurences) as avg_all
from events
group by event_type
)
select business_id
from events e
where occurences > (select avg_all from cte where cte.event_type = e.event_type)
group by business_id
having count(*) > 1




Prac:

1.
with cte as (
select
business_id,
occurences,
avg(occurences) over(partition by event_type) as tot_avg
from Events
)
select business_id 
from cte
where occurences > tot_avg
group by business_id
having count(*) > 1

2.
with cte as (
select event_type, avg(occurences) as tot_avg
from Events
group by event_type
)
select business_id
from Events e inner join cte c on e.event_type = c.event_type
where e.occurences > c.tot_avg
group by e.business_id
having count(*) > 1














