create table EMP_rs as select * from employees;

create table DEPT_rs as select * from departments;

select * from dept_rs;

describe employees;
Name           Null?    Type         
-------------- -------- ------------ 
EMPLOYEE_ID    NOT NULL NUMBER(6)    
FIRST_NAME              VARCHAR2(20) 
LAST_NAME      NOT NULL VARCHAR2(25) 
EMAIL          NOT NULL VARCHAR2(25) 
PHONE_NUMBER            VARCHAR2(20) 
HIRE_DATE      NOT NULL DATE         
JOB_ID         NOT NULL VARCHAR2(10) 
SALARY                  NUMBER(8,2)  
COMMISSION_PCT          NUMBER(2,2)  
MANAGER_ID              NUMBER(6)    
DEPARTMENT_ID           NUMBER(4)

describe emp_rs;
Name           Null?    Type         
-------------- -------- ------------ 
EMPLOYEE_ID             NUMBER(6)    
FIRST_NAME              VARCHAR2(20) 
LAST_NAME      NOT NULL VARCHAR2(25) 
EMAIL          NOT NULL VARCHAR2(25) 
PHONE_NUMBER            VARCHAR2(20) 
HIRE_DATE      NOT NULL DATE         
JOB_ID         NOT NULL VARCHAR2(10) 
SALARY                  NUMBER(8,2)  
COMMISSION_PCT          NUMBER(2,2)  
MANAGER_ID              NUMBER(6)    
DEPARTMENT_ID           NUMBER(4)

alter table emp_rs
add constraint pk_emp_rs primary key(employee_id);

alter table dept_rs
add constraint pk_dept_rs primary key(department_id);

alter table emp_rs
add constraint fk_emp_dept_rs foreign key(department_id)
                    references dept_rs(department_id);
                    
select *
from user_constraints
where lower(table_name) = 'emp_rs';

select *
from user_constraints
where lower(table_name) = 'dept_rs';

insert into dept_rs
values(300, 'Programare'); --"not enough values"

insert into dept_rs
values(300, 'Programare', null, null); --1 row inserted.

select * from dept_rs where department_id = 300;
rollback;

insert into dept_rs(department_id, department_name)
values (300, 'Programare');

rollback;

insert into dept_rs(department_name, department_id)
values('Programare', 300);

rollback;

insert into dept_rs(department_name, department_id, location_id)
values('Programare', 300, null);

select * from dept_rs where department_id = 300;
commit;

insert into emp_rs(employee_id, last_name, hire_date, email, job_id, department_id)
values(252, 'Rincu', sysdate, 'pestisor@gmail.com', 'test_job', 300);

select * from emp_rs;

select * from emp_rs 
where employee_id = 252;
commit;

delete from emp_rs
where employee_id = 252;

select * from emp_ong 
where employee_id = 252;

insert into emp_rs(employee_id, last_name, hire_date, email, job_id, department_id)
values(254, 'Rincu', sysdate, 'pestisor@gmail.com', 'test_job', 300);
commit;

select * from emp_rs 
where employee_id in (252, 254);

select * from emp_ong 
where employee_id in (252, 253, 254);

insert into emp_rs(employee_id, last_name, hire_date, email, job_id, department_id)
values(255, 'Rincu', sysdate, 'pestisor@gmail.com', 'test_job', 301); --integrity constraint (GRUPA32.FK_EMP_DEPT_RS) violated - parent key not found

create table emp1_rs as select * from employees;
select * from emp1_rs;
delete from emp1_rs;
select * from emp1_rs;

insert into emp1_rs
select * from employees
where commission_pct > 0.25;

insert into emp1_rs(employee_id, last_name, email, hire_date, job_id, department_id)
select employee_id, last_name, email, hire_date, job_id, department_id
from employees 
where commission_pct > 0.25;

select * from emp1_rs;

insert into emp1_rs(last_name, email, hire_date, job_id)
select last_name, email, hire_date, job_id
from employees 
where commission_pct > 0.25;

select * from emp1_rs;

rollback;

select * from emp1_rs;

drop table emp1_rs;

update emp_rs
set salary = 10000;

select * from emp_rs;

update emp_rs
set salary = 700
where lower(job_id) like 'test_job';

rollback;

update emp_rs
set salary = nvl(salary * 0.05 + salary, 0);

select * from emp_rs;

update emp_rs
set job_id = 'SA_REP'
where department_id = 80 and commission_pct is not null;

rollback;

select * from dept_rs;


update dept_rs
set manager_id = (select employee_id
                  from employees
                  where lower(first_name) like 'douglas' and lower(last_name) like 'grant')
where department_id = 20;

update emp_rs
set salary = salary + 1000, department_id = 20 
where lower(first_name) like 'douglas' and lower(last_name) like 'grant';

select * from emp_rs;
select * from dept_rs;

delete from dept_rs
where department_id not in (select distinct department_id
                            from emp_rs
                            where department_id is not null);
rollback;
