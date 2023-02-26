select e.last_name, j.min_salary, j.max_salary, d.department_name
from employees e, jobs j, departments d
where e.department_id = d.department_id
      and e.job_id = j.job_id;  --106 rezultate
      
select e.last_name, e.salary, j.job_title, l.city, c.country_id
from employees e, jobs j, locations l, departments d, countries c
where e.job_id = j.job_id and e.department_id =  d.department_id
        and d.location_id = l.location_id and l.country_id = c.country_id
        and e.manager_id = 100;

select manager_id --managerul 100 pt departamentul 90
from departments
where department_id = 90;

select last_name
from employees
where hire_date>(select hire_date
                 from employees
                 where lower(last_name) = 'gates');
                 
select e.last_name, e.hire_date
from employees e join employees e2
on(e.hire_date>e2.hire_date)
where e2.last_name = 'Gates';

select e.last_name, to_char(e.hire_date, 'Month') as luna, to_char(e.hire_date, 'YYYY') as anul
from employees e, employees e2
where e2.last_name = 'Gates' and e2.department_id = e.department_id and lower(e.last_name) like '%a%';

select distinct d.department_id, d.department_name
from employees e, departments d
where d.department_id = e.department_id and lower(e.last_name) like '%t%'; --7 rez

select e.employee_id, e.last_name
from employees e
where e.department_id in (select distinct d.department_id
                           from employees e, departments d
                           where d.department_id = e.department_id and lower(e.last_name) like '%t%');
                           
select e.*, d.*
from departments d, employees e
where d.department_id(+) = e.department_id 
order by d.department_id desc; --107

select last_name, department_name
from employees e right outer join departments d
on d.department_id  = e.department_id; --107

select e.*, d.*
from departments d, employees e
where d.department_id = e.department_id(+)
order by d.department_id desc; --122

select last_name, department_name
from departments d left outer join employees e
on d.department_id  = e.department_id; --122

select employee_id, last_name, department_name
from departments d, employees e
where d.department_id = e.department_id(+)
union                       
select employee_id, last_name, department_name
from departments d, employees e
where d.department_id(+) = e.department_id; --123

select last_name, department_name
from employees e full outer join departments d
on d.department_id  = e.department_id; --123

select e.employee_id, d.department_id, l.location_id, c.country_id
from employees e, departments d, locations l, countries c
where l.country_id(+) = c.country_id 
      and d.location_id(+) = l.location_id 
      and e.department_id(+) = d.department_id; --149
      
select department_id
from departments
where lower(department_name) like '%re%'
union
select department_id
from employees 
where upper(job_id) like 'SA_REP'; --9

select department_id
from departments
where lower(department_name) like '%re%'
union all
select department_id
from employees 
where upper(job_id) like 'SA_REP'; --37