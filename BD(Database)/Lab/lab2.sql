select 1+2
from dual; --valoarea 3

select 1+2
from employees; --107 valori

select sysdate
from dual; --WEDNESDAY//02/TWENTY TWENTY-TWO

select to_char(sysdate, 'DAY//MM/YEAR')
from dual; --WEDNESDAY//02/TWENTY TWENTY-TWO

alter session set nls_language=American;

select to_char(sysdate, 'DD/MM/YEAR')
from dual; --23/02/TWENTY TWENTY-TWO

select to_char(sysdate, 'D/MM/YEAR')
from dual; --4/02/TWENTY TWENTY-TWO

select to_char(hire_date, 'MON'), to_char(hire_date, 'Month')  
from employees;

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY')
from employees
order by 1;

select to_char(hire_date, 'Month') luna ,to_char(hire_date, 'DAY')
from employees
order by luna;

select to_char(hire_date, 'Month'),to_char(hire_date, 'DAY'), to_char(hire_date, 'D'), employee_id
from employees
order by 1 asc, to_char(hire_date, 'D') desc;

select last_name || ' ' || first_name as name, salary, commission_pct
from employees
order by commission_pct;

select to_char(sysdate, 'DD/MON/YYYY/HH24/MI/SS') 
from dual; --23/FEB/2022/15/06/11

select last_name || ' ' || first_name as name, to_char(hire_date, 'DDD') as day, to_char(hire_date, 'MON') as mon, to_char(hire_date, 'YYYY') as year
from employees
order by 4 desc, 2 asc ;

select employee_id, round(sysdate-hire_date,2) dif, to_char(sysdate, ' dd/mm/yyyy hh24:mi') azi, to_char(hire_date, ' dd/mm/yyyy hh24:mi') ang_hire_date
from employees
where round(sysdate-hire_date,2) >10000
order by dif;

select last_name || ' ' || first_name as name, hire_date
from employees
where to_char (hire_date, 'MON') = to_char(sysdate, 'MON');

select last_name || ' ' || first_name name, salary
from employees
where salary > 2850; --86 de rezultate

select last_name || ' ' || first_name as name, job_id, hire_date
from employees
where hire_date between '20-FEB-1987' and '1-MAY-1989'
order by hire_date;

select last_name || ' ' || first_name as name, department_id
from employees
where department_id in (10, 30, 50)
order by name;

select * from employees;

select last_name || ' ' || first_name as name, job_id, salary
from employees
where (lower(job_id) like lower('%CLERK%') or lower(job_id) like lower('%REP%')) 
and salary not in (3200, 2700, 2500, 3100, 6200);

select last_name || ' ' || first_name as name, job_id
from employees
where manager_id is not null;