-- Question 15
-- Write a SQL query to get the second highest salary from the Employee table.

-- +----+--------+
-- | Id | Salary |
-- +----+--------+
-- | 1  | 100    |
-- | 2  | 200    |
-- | 3  | 300    |
-- +----+--------+
-- For example, given the above Employee table, the query should return 200 as the second highest salary. 
-- If there is no second highest salary, then the query should return null.

-- +---------------------+
-- | SecondHighestSalary |
-- +---------------------+
-- | 200                 |
-- +---------------------+


-- Solution
select max(salary) as SecondHighestSalary
from employee
where salary ! = (Select max(salary)
                   from employee)
                   
                   
                   
My sol:

1.
with cte as (
select
salary,
dense_rank() over(order by salary) desc as rn
from Employee
)
select salary from cte where rn = 2

                   
2.
Select max(salary) from Empployee where salary < (select max(salary) from Employee)
                   
                   
                   
                   
                   
