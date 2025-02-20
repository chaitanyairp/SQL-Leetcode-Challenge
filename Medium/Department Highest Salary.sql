-- Question 57
-- The Employee table holds all employees. Every employee has an Id, a salary, and there is also a column for the department Id.

-- +----+-------+--------+--------------+
-- | Id | Name  | Salary | DepartmentId |
-- +----+-------+--------+--------------+
-- | 1  | Joe   | 70000  | 1            |
-- | 2  | Jim   | 90000  | 1            |
-- | 3  | Henry | 80000  | 2            |
-- | 4  | Sam   | 60000  | 2            |
-- | 5  | Max   | 90000  | 1            |
-- +----+-------+--------+--------------+
-- The Department table holds all departments of the company.

-- +----+----------+
-- | Id | Name     |
-- +----+----------+
-- | 1  | IT       |
-- | 2  | Sales    |
-- +----+----------+
-- Write a SQL query to find employees who have the highest salary in each of the departments. 
-- For the above tables, your SQL query should return the following rows (order of rows does not matter).

-- +------------+----------+--------+
-- | Department | Employee | Salary |
-- +------------+----------+--------+
-- | IT         | Max      | 90000  |
-- | IT         | Jim      | 90000  |
-- | Sales      | Henry    | 80000  |
-- +------------+----------+--------+
-- Explanation:

-- Max and Jim both have the highest salary in the IT department and Henry has the highest salary in the Sales department.

-- Solution
select a.Department, a.Employee, a.Salary
from(
select d.name as Department, e.name as Employee, Salary,
rank() over(partition by d.name order by salary desc) as rk
from employee e
join department d
on e.departmentid = d.id) a
where a.rk=1




My sol:
select Department, Employee, Salary from (
select 
	d.name as Department, 
	e.name as Employee, 
	e.salary as Salary,
	rank() over(partition by e.departmentid order by salary desc) as rn
from employees e inner join department d on e.departmentid = d.id) t
where rn = 1



Prac sol:
with cte as (
select
departmentid,
name,
salary,
rank() over(partition by departmentid order by salary desc) as rn
from employees
)
select departmentid, name, coalesce(salary, 0) as max_sal 
from department d left join cte c on d.id = c.departmentid
where rn = 1




