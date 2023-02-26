select last_name, nvl(to_char(commission_pct), 'fara comision')
from employees;

select last_name, nvl2(to_char(commission_pct), '0'||to_char(commission_pct), 'fara comision')
from employees;

select last_name, nvl2(commission_pct, '0'||commission_pct, 'fara comision')
from employees; --conversie implicita a lui commission_pct din number la string

select last_name, salary, commission_pct
from employees
where salary + salary * nvl(commission_pct, 0) > 10000
order by employee_id;

select *
from employees;

select last_name, job_id, salary, 
    case job_id
    when 'IT_PROG' then salary*1.2
    when 'SA_REP' then salary*1.25
    when 'SA_MAN' then salary*1.35
    else salary
    end
    as "salariu negociat"
from employees;

select last_name, job_id, salary, 
    decode(upper(job_id),
           'IT_PROG', salary*1.2, 
           'SA_REP', salary*1.25, 
           'SA_MAN', salary*1.35, 
           salary) 
    as "salariu negociat"
from employees
order by 4;

select department_id, city
from departments, locations; --cross join

select department_id, city
from departments, locations
where departments.location_id = locations.location_id;

select departments.department_id, locations.city
from departments, locations
where departments.location_id = locations.location_id;

select department_id, city
from departments d, locations l
where d.location_id = l.location_id;

select department_id, city
from departments d join locations l
on d.location_id = l.location_id;

select department_id, city, d.location_id "din dept", l.location_id "in loc"
from departments d, locations l
where d.location_id = l.location_id;

select last_name, d.department_id, d.department_name
from employees e, departments d
where e.department_id = d.department_id;

select *
from employees 
where department_id is null;

select e.*, d.*
from employees e, departments d
where e.department_id = d.department_id;

select j.job_id, j.job_title
from jobs j, employees e
where j.job_id = e.job_id
order by employee_id; --107

select distinct j.job_id, j.job_title
from jobs j, employees e
where j.job_id = e.job_id; --19

select distinct j.job_id, j.job_title
from jobs j, employees e
where j.job_id = e.job_id
and e.department_id = 30; --2

select e.last_name, e.job_id, e.department_id, d.department_name
from employees e, departments d, locations l
where lower(l.city) = lower('Oxford')
and d.department_id = e.department_id
and d.location_id = l.location_id;