SELECT * FROM hr_employee LIMIT 10;

-- the average salary by department
SELECT Department, AVG(salary) AS Average_Salary
FROM HR_Employee
GROUP BY Department
ORDER BY Average_Salary DESC;

-- Number of employees who came from a diversity recruitment event
SELECT COUNT(emp_id)
FROM hr_employee
WHERE from_diversity_job_fair_id = 1;


-- Average salary by department
SELECT department,
       AVG(salary) AS average_salary
FROM hr_employee
GROUP BY department
ORDER BY average_salary DESC;


-- List employees who were hired in 2012
SELECT employee_name,
       date_of_hire
FROM hr_employee
WHERE EXTRACT(YEAR FROM date_of_hire) = 2012;


-- Number of employees in each race/ethnicity category
SELECT race_desc,
       COUNT(emp_id) AS number_of_employees
FROM hr_employee
GROUP BY race_desc;


-- Count of male and female employees
SELECT sex,
       COUNT(emp_id) AS number_of_employees
FROM hr_employee
GROUP BY sex;


-- Number of employees by performance score
SELECT performance_score,
       COUNT(emp_id) AS number_of_employees
FROM hr_employee
GROUP BY performance_score;


-- Employees with a performance score of 'Needs Improvement' or 'PIP'
SELECT emp_id,
       employee_name,
       performance_score
FROM hr_employee
WHERE performance_score IN ('Needs Improvement', 'PIP');


-- Top 5 active employees with the highest absences and poor performance
SELECT emp_id,
       employee_name,
       absences
FROM hr_employee
WHERE performance_score IN ('Needs Improvement', 'PIP')
  AND employment_status = 'Active'
ORDER BY absences DESC
LIMIT 5;


-- Top 3 highest-paid employees in each department
WITH rank_emp AS (
    SELECT department,
           emp_id,
           employee_name,
           sex,
           marital_desc,
           position,
           salary,
           DENSE_RANK() OVER (
               PARTITION BY department
               ORDER BY salary DESC
           ) AS rnk
    FROM hr_employee
)

SELECT department,
       emp_id,
       employee_name,
       sex,
       marital_desc,
       position,
       salary
FROM rank_emp
WHERE rnk <= 3;


-- Count of employees by termination reason and employment status
SELECT UPPER(term_reason) AS term_reason,
       employment_status,
       COUNT(*) AS employee_count
FROM hr_employee
WHERE date_of_termination IS NOT NULL
GROUP BY term_reason,
         employment_status;