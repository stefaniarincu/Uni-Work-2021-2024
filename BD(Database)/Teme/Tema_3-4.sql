--Ex1. Cati angajati lucreaza in fiecare locatie? Afisati orasul si numarul de angajati din fiecare oras.

select l.city as oras_rs, (select count(employee_id)
                from employees e, departments d
                where e.department_id = d.department_id and d.location_id = l.location_id) as nr_ang_rs
from locations l; --23 rezultate


--Ex2. Pentru fiecare locatie, care este salariul maxim al angajatilor care lucreaza in acele locatii.

select l.city as oras_rs, (select max(salary)
                           from employees e, departments d
                           where e.department_id = d.department_id 
                                 and d.location_id = l.location_id) as salariu_max_rs
from locations l
order by 2; --23 rezultate


--Ex3. Pentru fiecare locatie, care este numele angajatilor care au salariul maxim si lucreaza in acele locatii.

select l.city as oras_rs, e1.last_name as nume_ang_rs, 
       (select max(salary)
        from employees e, departments d
        where e.department_id = d.department_id  
              and d.location_id = l.location_id)as salariu_max_rs
from locations l, employees e1
where e1.salary = (select max(salary)
                   from employees e, departments d
                   where e.department_id = d.department_id  
                         and d.location_id = l.location_id); -- 15 rezultate

--Ex4. Sa se obtina numele salariatilor, numele departamentului si orasul pentru angajatii care lucreaza într-un 
--departament în care exista cel putin un angajat cu salariul egal cu salariul maxim din unul dintre 
--departamentele in care lucreaza un salariat care continul sirul "er" in prenume.
with aux as (select max(salary) as sal_max
             from employees e
             where department_id in (select distinct department_id 
                                     from employees
                                     where lower(first_name) like '%er%')
             group by department_id)
select e.last_name as nume_ang_rs, d.department_name as nume_dep_rs, l.city as oras_rs
from employees e, departments d, locations l
where e.department_id = d.department_id and d.location_id = l.location_id
      and e.department_id in (select distinct e3.department_id
                              from employees e3
                              where e3.salary in (select sal_max from aux)); -- 98 rezultate
 
--Ex4.a) In ce departamente lucreaza salaritii care continul sirul "er" in prenume.                             
select distinct department_id as dep_rs 
from employees
where lower(first_name) like '%er%'; -- 7 rezultate

--Ex4.b) Care sunt salariile maxime din aceste departamente obtinute la subpunctul a)?
select department_id as dep_rs, max(salary) as sal_max_rs
from employees
where department_id in (select distinct department_id 
                        from employees
                        where lower(first_name) like '%er%')
group by department_id
order by 1; -- 6 rezultate

--Ex4.c) In ce departamente lucreaza angajatii care au salariul egal cu unul dintre salariile maxime obtinute 
--la subpunctul b)?
select distinct department_id as dep_rs
from employees
where salary in (select max(salary)
                 from employees
                 where department_id in (select department_id 
                                         from employees
                                         where lower(first_name) like '%er%')
                 group by department_id)
order by 1; -- 7 rezultate

