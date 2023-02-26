--Ex1. Creati tabela emp_abc3 cu acceasi structura ca si tabela employees, dar fara nicio informatie in ea.
create table emp_rs3(
    cod_emp_rs number(6) constraint pk_emp_rs3 primary key,
    first_name_rs varchar(20),
    last_name_rs varchar(25) constraint name_null_rs3 not null,
    email_rs char(25) constraint null_email_rs3 not null,
    telefon_rs varchar(20),
    hire_date_rs  date constraint null_hire_date_rs3 not null,
    job_rs  varchar2(10) constraint fk_job_emp_rs3 references jobs(job_id),
    salary_rs  number(8, 2)constraint ck_salary_min_rs3 check(salary_rs > 0),
    comision_rs number(2, 2),
    cod_manager_rs  number(6) constraint fk_man_emp_rs3 references emp_rs3(cod_emp_rs),
    cod_dep_rs number(4) constraint null_cod_dep_rs3 not null,
    constraint unq_email_rs3 unique(email_rs),
    constraint fk_depart_emp_rs3 foreign key(cod_dep_rs) references departments(department_id));

select * from emp_rs3;


--Ex2. Inserati in tabela emp_abc3 angajatii care au salariul mai mare ca cel al salariatului cu prenumele Adam.
--Cate informatii au fost inserate? Ce fel de subcereri ati folosit? Dati commit. 
--Ce se intampla daca apoi apelam rollback?
select * from employees;
insert into emp_rs3
select * from employees e
where e.salary > (select e2.salary
                  from employees e2
                  where lower(e2.first_name) like 'adam'); --31 randuri, am folosit subcereri necorelate
    
commit;
rollback; --informatiile nu se mai sterg, deoarece dupa comanda 'commit' 'rollback' nu mai modifica tabela

select * from emp_rs3;



--Ex3. Afisati informatii complete din tabela emp_abc3 despre angajatului al carui numar de telefon incepe cu 
--011 si se termina cu 66.Modificati informatiile din tabela emp_abc3 astfel incat angajatii sa lucreze in 
--departamentul sefului firmei, dar aceste modificari vor fi facute doar pentru salariatii care au salariul mai
--mic decat salariul angajatului al carui numar de telefon incepe cu 011 si se termina cu 66. La acest exercitiu
--va folositi doar de tabela emp_abc3.Cate informatii au fost modificate? Ce fel de subcereri ati folosit? 
--Ce se intampla daca apoi apelam rollback? Permanentizati aceste modificari facute de update-ul vostru.

select *
from emp_rs3
where telefon_rs like ('011%66');

--175	Alyssa	Hutton	AHUTTON     011.44.1644.429266	19-MAR-97	SA_REP	8800	0.25	149	80
    
update emp_rs3
set cod_dep_rs = (select cod_dep_rs
                  from emp_rs3
                  where cod_manager_rs is null)
where salary_rs < (select salary_rs
                   from emp_rs3
                   where telefon_rs like ('011%66'));--3 linii modificate, am folosit subcereri necorelate
 
rollback;  --se pierd ultimile modificari facute              
commit; --se permanentizeaza modificarile


--Ex4. Sa se stearga din tabela emp_abc3 toti salariatii angajati dupa salariatul angajat inaintea lui Kochhar
--(acesta este numele de familie). La acest exercitiu va folositi doar de tabela emp_abc3.
--Cate informatii au fost sterse? Ce fel de subcereri ati folosit?

delete from emp_rs3
where hire_date_rs > (select hire_date_rs
                      from emp_rs3
                      where hire_date_rs < (select hire_date_rs
                                         from emp_rs3
                                         where lower(last_name_rs) like 'kochhar')); 
--30 de randuri sterse, am folosit subcereri necorelate


                                    
--Ex5. Afisati informatiile ramase in tabela emp_abc3. In final stergeti tabla emp_abc3.  
select * from emp_rs3;
--100	Steven	King	SKING          	515.123.4567	17-JUN-87	AD_PRES	24000			90
    
drop table emp_rs3;

select department_id, count(*) nr_ang, sum(salary) sum_sal_dept
from employees
group by department_id;

select d.department_id, department_name, count(*) nr_ang, sum(salary) sum_sal_dept
from employees e, departments d
where e.department_id = d.department_id(+)
group by d.department_id, department_name;

select sum(salary) sum_sal_dept
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id;

select max(sum(salary))
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id;

select d.department_id, department_name, sum(salary)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, department_name 
having sum(salary) = (select max(sum(salary))
                      from employees e, departments d
                      where e.department_id = d.department_id
                      group by d.department_id);
                      
select d.department_id, department_name, round(avg(salary))
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, department_name 
having round(avg(salary)) = (select max(round(avg(salary)))
                             from employees e, departments d
                             where e.department_id = d.department_id
                             group by d.department_id);
                             
select d.department_id, department_name, count(employee_id)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, department_name
having count(employee_id) < 4;

select d.department_id, department_name, count(employee_id)
from employees e, departments d
where e.department_id(+) = d.department_id
group by d.department_id, department_name
having count(employee_id) < 4;

select d.department_id, department_name, count(employee_id)
from employees e, departments d
where e.department_id = d.department_id
group by d.department_id, department_name
having count(employee_id) = (select max(count(employee_id))
                             from employees e, departments d
                             where e.department_id = d.department_id
                             group by d.department_id, department_name);
                             
select department_id, department_name, (select count(employee_id)
                                        from employees e
                                        where e.department_id = d.department_id) as nr_ang
from departments d;

select aux.department_id, aux.department_name, aux.nr_ang
from(select department_id, department_name, (select count(employee_id)
                                             from employees e
                                             where e.department_id = d.department_id) as nr_ang
     from departments d)aux
where nr_ang < 4;

with aux as (select department_id, department_name, (select count(employee_id)
                                                     from employees e
                                                     where e.department_id = d.department_id) as nr_ang
             from departments d)
select * 
from aux
where aux.nr_ang < 4;

select e.*
from employees e
where e.department_id in (select d.department_id
                          from employees e, departments d
                          where e.department_id = d.department_id
                          group by d.department_id
                          having count(*) = (select min(count(*))
                                             from employees e, departments d
                                             where e.department_id = d.department_id
                                             group by d.department_id));

select to_char(hire_date, 'DD'), count(*), hire_date
from employees
group by to_char(hire_date, 'DD')
having count(*) = (select max(count(*))
                    from employees 
                    group by to_char(hire_date, 'DD'));
                    
select *
from employees
where to_char(hire_date, 'DD') in (select to_char(hire_date, 'DD')
                                   from employees
                                   group by to_char(hire_date, 'DD')
                                    having count(*) = (select max(count(*))
                                                       from employees 
                                                       group by to_char(hire_date, 'DD')));
                                                       
select job_title, (min_salary + max_salary) / 2, max_salary-min_salary, nvl(to_char(aux.media_reala), 'nu lucreaza nimeni')
from jobs j, (select job_id, avg(salary) media_reala
              from employees
              group by job_id)aux
where j.job_id = aux.job_id(+);

select d.department_name, e.last_name, e.salary
from employees e, departments d
where e.department_id = d.department_id and e.salary = (select min(salary)
                                                        from employees
                                                        where e.department_id = department_id);
                                    
