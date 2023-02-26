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

insert into emp_rs(job_id, hire_date, email, last_name, employee_id, department_id)
values('Prog', To_date('03/03/2022', 'DD/MM/YYYY'), 'pestisor@gmail.com', 'Stefania', 333, 300);

select * from emp_rs where employee_id = 333;
commit;

delete from emp_rs
where employee_id = 333;