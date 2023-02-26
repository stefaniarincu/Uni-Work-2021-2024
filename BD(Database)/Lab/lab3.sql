select * from project;
select * from employees order by 2;

select distinct employee_id
from works_on w
where not exists(select project_id 
                 from project p1
                 where start_date < to_date('1-July-2006') 
                       and to_date('1-January-2006') < start_date
                       and not exists(select project_id
                                      from works_on w2
                                      where w.employee_id = w2.employee_id
                                            and w2.project_id = p1.project_id));
                                            
select employee_id
from works_on 
where project_id in (select project_id
                     from project
                     where start_date < to_date('1-July-2006') 
                            and to_date('1-January-2006') < start_date)
group by employee_id
having count(project_id) = (select count(*)
                            from project
                            where start_date < to_date('1-July-2006') 
                                  and to_date('1-January-2006') < start_date);
 
with
aux as (select employee_id as cod, count(*) as nr_jb
        from job_history
        group by employee_id)
select distinct project_id
from works_on w
where not exists(select employee_id 
                 from job_history j1
                 where (select nr_jb
                        from aux
                        where aux.cod = j1.employee_id) >= 2
                       and not exists(select employee_id
                                      from works_on w2
                                      where w2.employee_id = j1.employee_id
                                            and w.project_id = w2.project_id));


select distinct employee_id
from works_on w1
where not exists ((select project_id
                   from project p
                   where start_date < to_date('1-July-2006') 
                            and to_date('1-January-2006') < start_date)
                   minus
                   (select w2.project_id
                    from works_on w2
                    where w2.employee_id = w1.employee_id));
                    
