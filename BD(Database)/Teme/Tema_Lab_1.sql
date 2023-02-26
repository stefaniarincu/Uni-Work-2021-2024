describe employees;
describe departments;
describe jobs;
describe job_history;
describe locations;
describe countries;
describe regions;

select * from employees;
select * from departments;
select * from jobs;
select * from job_history;
select * from locations;
select * from countries;
select * from regions;

select employee_id, last_name || ' ' || first_name as name, job_id, hire_date
from employees; --este operatie de selectie

select employee_id as "cod", last_name || ' ' || first_name as "nume", job_id as "cod job", hire_date as "data angajarii"
from employees;

select job_id
from employees; --cu duplicate
select distinct job_id
from employees; --fara duplicate

select last_name || ' ' || first_name || ', ' || job_id as "Angajat si titlu"
from employees;

select employee_id || ' ' || first_name || ' ' || last_name || ' ' || email || ' ' || phone_number || ' ' || hire_date || ' ' || job_id || ' ' || salary || ' ' || commission_pct || ' ' || manager_id || ' ' || department_id as "Informatii complete"
from employees;

select last_name || ' ' || first_name as name, salary
from employees
where salary > 2850;

select last_name || ' ' || first_name as name, job_id
from employees
where employee_id = 104;

select last_name || ' ' || first_name as name, salary
from employees
where salary not between 1500 and 2850;

select last_name || ' ' || first_name as name, job_id, hire_date
from employees
where hire_date between '20-FEB-1987' and '1-MAY-1989'
order by hire_date;

select last_name || ' ' || first_name as name, department_id
from employees
where department_id in (10, 30, 50)
order by name;

select last_name || ' ' || first_name as "Angajat", salary as "Salariu lunar"
from employees
where department_id in (10, 30, 50) and salary > 1500;

select sysdate
from dual;


select last_name || ' ' || first_name as name, hire_date
from employees
where hire_date like ('%87%');

select last_name || ' ' || first_name as name, hire_date
from employees
where to_char (hire_date,'YYYY') = '1987';

select last_name || ' ' || first_name as name, hire_date
from employees
where extract (year from hire_date) = 1987;


select last_name || ' ' || first_name as name, hire_date
from employees
where to_char (hire_date, 'MON') = to_char(sysdate, 'MON');

select last_name || ' ' || first_name as name, job_id
from employees
where manager_id is NULL;


select last_name || ' ' || first_name as name, salary, commission_pct
from employees
where commission_pct is not NULL
order by salary desc;

select last_name || ' ' || first_name as name, salary, commission_pct
from employees
where commission_pct is not NULL
order by commission_pct desc;


select last_name || ' ' || first_name as name, salary, commission_pct
from employees
order by commission_pct desc; --la inceputul listei

select first_name
from employees
where first_name like ('__a%');

select first_name
from employees
where first_name like ('%l%l%') or first_name like ('%L%l%') and (department_id = 30 or manager_id = 102);

select last_name || ' ' || first_name as name, job_id, salary
from employees
where (lower(job_id) like lower('%CLERK%') or lower(job_id) like lower('%REP%')) and salary not in (3200, 2700, 2500, 3100, 6200);

select department_name
from departments
where manager_id is NULL;