--a + b + c + e + f + g + h
CREATE SEQUENCE sec_rs START WITH 400;

CREATE TABLE jh_rs AS SELECT * FROM job_history;
CREATE TABLE emp_rs AS SELECT * FROM employees;

CREATE OR REPLACE PACKAGE pachet_tema_rs AS
    --a
    PROCEDURE adauga_ang(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE,
                         email emp_rs.email%TYPE, tel emp_rs.phone_number%TYPE,
                         dep departments.department_name%TYPE, job jobs.job_title%TYPE,
                         prenM emp_rs.first_name%TYPE, numeM emp_rs.last_name%TYPE);
    --a
    FUNCTION afla_dep(dep departments.department_name%TYPE) RETURN NUMBER;
    --a
    FUNCTION afla_job(job jobs.job_title%TYPE) RETURN VARCHAR2;
    --a
    FUNCTION sal_min(job jobs.job_id%TYPE, dep departments.department_id%TYPE) RETURN NUMBER;
    --a
    FUNCTION get_manager(nume emp_rs.last_name%TYPE, pren emp_rs.first_name%TYPE) RETURN NUMBER;
    --b
    PROCEDURE change_dep(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE,
                        dep departments.department_name%TYPE, job jobs.job_title%TYPE,
                        prenM emp_rs.first_name%TYPE, numeM emp_rs.last_name%TYPE);
    --c
    FUNCTION nr_subalt(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE) RETURN NUMBER;
    --e
    PROCEDURE act_sal(nume emp_rs.last_name%TYPE, salnou emp_rs.salary%TYPE);
    --f
    CURSOR c (parametru  jobs.job_id%TYPE) RETURN emp_rs%ROWTYPE;
    --g
    CURSOR c2 RETURN jobs%ROWTYPE;
    --h
    PROCEDURE lista_ang_job;
END pachet_tema_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet_tema_rs AS
    CURSOR c (parametru  jobs.job_id%TYPE) RETURN emp_rs%ROWTYPE IS 
           SELECT *
           FROM emp_rs e
           WHERE e.job_id = LOWER(parametru);
    
    CURSOR c2 RETURN jobs%ROWTYPE IS
            SELECT * 
            FROM jobs;
           
    FUNCTION afla_dep(dep departments.department_name%TYPE) 
        RETURN NUMBER
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM departments
        WHERE LOWER(department_name) = LOWER(dep);    
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un departament cu numele dat');
            RETURN -1;
        ELSE
            SELECT department_id INTO cnt
            FROM departments
            WHERE LOWER(department_name) = LOWER(dep);
            RETURN cnt;
        END IF;     
    END afla_dep;
    
    FUNCTION afla_job(job jobs.job_title%TYPE) 
        RETURN VARCHAR2
    IS
        cnt NUMBER;
        f_jobId jobs.job_id%TYPE := '-';
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM jobs
        WHERE LOWER(job_title) = LOWER(job);    
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un job cu titlul dat');
        ELSE
            SELECT job_id INTO f_jobId
            FROM jobs
            WHERE LOWER(job_title) = LOWER(job);
        END IF;     
        RETURN f_jobId;
    END afla_job;
    
    FUNCTION sal_min(job jobs.job_id%TYPE, dep departments.department_id%TYPE) 
        RETURN NUMBER
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM emp_rs
        WHERE department_id = dep AND job_id = job;
        
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista nicun angajat pe departamentul si pe jobul dat');
            SELECT min_salary INTO cnt
            FROM jobs 
            WHERE job_id = job;
            RETURN cnt;
        ELSE
            SELECT MIN(salary) INTO cnt
            FROM emp_rs
            WHERE department_id = dep AND job_id = job;
            RETURN cnt;
        END IF; 
    END sal_min;
    
    FUNCTION get_manager(nume emp_rs.last_name%TYPE, pren emp_rs.first_name%TYPE) 
        RETURN NUMBER
    IS
        cnt NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM emp_rs
        WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren);    
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un angajat cu numele si prenumele dat pentru manager');
            RETURN -1;
        ELSE
            SELECT employee_id INTO cnt
            FROM emp_rs
            WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren);
            RETURN cnt;
        END IF;     
    END get_manager;
        
    PROCEDURE adauga_ang(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE,
                         email emp_rs.email%TYPE, tel emp_rs.phone_number%TYPE,
                         dep departments.department_name%TYPE, job jobs.job_title%TYPE,
                         prenM emp_rs.first_name%TYPE, numeM emp_rs.last_name%TYPE)
    IS
        id_dep NUMBER;
        id_job jobs.job_id%TYPE;
        sal NUMBER;
        id_man NUMBER;
        cnt NUMBER;
    BEGIN
        id_dep := afla_dep(dep);
        IF (id_dep != -1) THEN
            id_job := afla_job(job);
            IF (id_job NOT LIKE '-') THEN
                sal := sal_min(id_job, id_dep);
                id_man := get_manager(numeM, prenM);
                IF (id_man != -1) THEN
                    SELECT COUNT(*) INTO cnt
                    FROM emp_rs
                    WHERE employee_id = id_man AND department_id = id_dep;
                    IF cnt = 0 THEN
                        dbms_output.put_line('Angajatul dat ca si manager nu lucreaza in departamentul ales');
                    ELSE
                        INSERT INTO emp_rs(employee_id, first_name, last_name, email, phone_number,
                                            hire_date, job_id, salary, manager_id, department_id)
                        VALUES(sec_rs.NEXTVAL, pren, nume, email, tel, SYSDATE, id_job, sal, id_man, id_dep);
                    END IF;
                END IF;
            END IF;
        END IF;                
    END adauga_ang;
    
    PROCEDURE change_dep(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE,
                         dep departments.department_name%TYPE, job jobs.job_title%TYPE,
                         prenM emp_rs.first_name%TYPE, numeM emp_rs.last_name%TYPE)
    IS
        id_dep NUMBER;
        id_job jobs.job_id%TYPE;
        id_emp emp_rs.employee_id%TYPE;
        email emp_rs.email%TYPE;
        tel emp_rs.phone_number%TYPE;
        data_ang DATE;
        j_vechi jobs.job_id%TYPE;
        d_vechi NUMBER;
        salnou NUMBER;
        salvechi NUMBER;
        id_man NUMBER;
        cnt NUMBER;
        com emp_rs.commission_pct%TYPE;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM emp_rs
        WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren);    
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un angajat cu numele si prenumele dat');
        ELSE
            SELECT employee_id, email, phone_number, salary, hire_date, job_id, department_id
            INTO id_emp, email, tel, salvechi, data_ang, j_vechi, d_vechi
            FROM emp_rs
            WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren); 
            id_dep := afla_dep(dep);
            IF (id_dep != -1) THEN
                id_job := afla_job(job);
                IF (id_job NOT LIKE '-') THEN
                    salnou := sal_min(id_job, id_dep);
                    IF salnou < salvechi THEN
                        salnou := salvechi;
                    END IF;
                    id_man := get_manager(numeM, prenM);
                    IF (id_man != -1) THEN
                        SELECT COUNT(*) INTO cnt
                        FROM emp_rs
                        WHERE employee_id = id_man AND department_id = id_dep;
                        IF cnt = 0 THEN
                            dbms_output.put_line('Angajatul dat ca si manager nu lucreaza in departamentul ales');
                        ELSE
                            SELECT MIN(commission_pct) INTO com
                            FROM emp_rs
                            WHERE department_id = dep AND job_id = job;
                            UPDATE emp_rs
                            SET job_id = id_job, department_id = id_dep, 
                                manager_id = id_man, salary = salnou,
                                commission_pct = com, hire_date = SYSDATE
                            WHERE employee_id = id_emp;
                            SELECT COUNT(*) INTO cnt
                            FROM jh_rs
                            WHERE employee_id = id_emp;
                            IF cnt = 0 THEN
                                INSERT INTO jh_rs VALUES(id_emp, data_ang, SYSDATE, id_job, id_dep);
                            ELSE
                                SELECT MAX(end_date) INTO data_ang
                                FROM jh_rs
                                WHERE employee_id = id_emp;
                                INSERT INTO jh_rs VALUES(id_emp, data_ang, SYSDATE, id_job, id_dep);
                            END IF;
                        END IF;
                    END IF;
                END IF;
            END IF; 
        END IF;
    END change_dep;
    
    FUNCTION nr_subalt(pren emp_rs.first_name%TYPE, nume emp_rs.last_name%TYPE) 
        RETURN NUMBER
    IS
        cnt NUMBER;
        id_emp emp_rs.employee_id%TYPE;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM emp_rs
        WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren);
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un angajat cu numele dat');
            RETURN -1;
        ELSE
            SELECT employee_id INTO id_emp
            FROM emp_rs
            WHERE LOWER(last_name) = LOWER(nume) AND LOWER(first_name) = LOWER(pren);
            
            SELECT COUNT(DISTINCT(employee_id)) INTO cnt
            FROM employees
            START WITH manager_id = id_emp
            CONNECT BY PRIOR employee_id = manager_id;
            
            RETURN cnt;
        END IF;
    END nr_subalt;
    
    PROCEDURE act_sal(nume emp_rs.last_name%TYPE, salnou emp_rs.salary%TYPE)
    IS
        cnt NUMBER;
        TYPE tab_ang IS TABLE OF emp_rs%ROWTYPE;
        ang tab_ang := tab_ang();
        job emp_rs.job_id%TYPE;
        salmin NUMBER;
        salmax NUMBER;
    BEGIN
        SELECT COUNT(*) INTO cnt
        FROM emp_rs
        WHERE LOWER(last_name) = LOWER(nume);
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista un angajat cu numele dat');
        ELSIF cnt > 1 THEN
            dbms_output.put_line('Exista ' || cnt || ' angajati cu numele dat');
            SELECT * BULK COLLECT INTO ang
            FROM emp_rs
            WHERE LOWER(last_name) = LOWER(nume);
            FOR i IN ang.FIRST..ang.LAST LOOP
                dbms_output.put_line('Angajatul ' || ang(i).last_name || ' ' || ang(i).first_name);
            END LOOP;
        ELSE
            SELECT job_id INTO job
            FROM emp_rs
            WHERE LOWER(last_name) = LOWER(nume);
            SELECT min_salary, max_salary INTO salmin, salmax
            FROM jobs
            WHERE job_id = job;
            IF salnou > salmin AND salnou < salmax THEN
                UPDATE emp_rs
                SET salary = salnou
                WHERE LOWER(last_name) = LOWER(nume);
            ELSE
                dbms_output.put_line('Salariul dat nu respecta limitele jobului');
            END IF;
        END IF;
    END act_sal; 
    
    PROCEDURE lista_ang_job
    IS
        cnt NUMBER;
    BEGIN
        FOR i IN pachet_tema_rs.c2 LOOP
            dbms_output.new_line();
            dbms_output.put_line('    ' || i.job_title);
            SELECT COUNT(employee_id) INTO cnt
            FROM emp_rs e, jobs j
            WHERE LOWER(j.job_id) = LOWER(i.job_id) AND e.job_id = j.job_id;
            IF cnt = 0 THEN
                dbms_output.put_line('Nu exista niciun angajat care sa lucreaze pe acest job');
            ELSE
                FOR j IN pachet_tema_rs.c(i.job_id) LOOP
                    dbms_output.put(j.last_name||' '||j.first_name);
                    SELECT COUNT(*) INTO cnt
                    FROM jh_rs jh
                    WHERE jh.employee_id = j.employee_id AND jh.job_id = i.job_id;
                    IF cnt = 0 THEN
                        dbms_output.put_line('         NU a mai lucrat in trecut pe acest job');
                    ELSE
                        dbms_output.put_line('         A mai lucrat in trecut pe acest job');
                    END IF;
                END LOOP;
            END IF;
        END LOOP;
    END lista_ang_job;
END pachet_tema_rs;
/

EXECUTE pachet_tema_rs.adauga_ang('fifi','floricica', 'fifi@gmail', '0741745747', 'IT', 'Programmer', 'Bruce', 'Ernst');
SELECT * FROM emp_rs;

EXECUTE pachet_tema_rs.adauga_ang('fifi','floricica', 'fifi@gmail', '0741745747', 'IT', 'Programmer', 'Steven', 'King');
EXECUTE pachet_tema_rs.adauga_ang('fifi','floricica', 'fifi@gmail', '0741745747', 'ITUL', 'Programmer', 'Steven', 'King');
EXECUTE pachet_tema_rs.adauga_ang('fifi','floricica', 'fifi@gmail', '0741745747', 'IT', 'Prog', 'Steven', 'King');
EXECUTE pachet_tema_rs.adauga_ang('fifi','floricica', 'fifi@gmail', '0741745747', 'IT', 'Programmer', 'Stefan', 'Rege');

EXECUTE pachet_tema_rs.change_dep('fifi','floricica', 'Sales', 'Sales Representative', 'Oliver', 'Tuvault');
SELECT * FROM emp_rs;
SELECT * FROM jh_rs;

EXECUTE pachet_tema_rs.change_dep('fifi','floricica', 'Sales', 'Sales Representative', 'Steven', 'King');
EXECUTE pachet_tema_rs.change_dep('fifi','floricica', 'Sale', 'Sales Representative', 'Steven', 'King');
EXECUTE pachet_tema_rs.change_dep('fifi','floricica', 'Sales', 'Sales Repre', 'Steven', 'King');
EXECUTE pachet_tema_rs.change_dep('fifi','floricica', 'Sales', 'Sales Repre', 'EU', 'EU');

SELECT pachet_tema_rs.nr_subalt('Steven', 'King')
FROM dual;

BEGIN
    IF pachet_tema_rs.nr_subalt('Steven', 'King') != -1 THEN
        dbms_output.put_line('numarul de subalterni este ' || pachet_tema_rs.nr_subalt('Steven', 'King'));
    END IF;
END;
/

EXECUTE pachet_tema_rs.act_sal('floricica', 8000);
SELECT * FROM emp_rs;

EXECUTE pachet_tema_rs.act_sal('floricica', 100000000);
EXECUTE pachet_tema_rs.act_sal('eu', 100000000);
EXECUTE pachet_tema_rs.act_sal('Cambrault', 100000000);

DECLARE  
    job jobs.job_id%TYPE := '&id_job';
    cnt NUMBER;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM jobs 
    WHERE LOWER(job_id) = LOWER(job);
    IF cnt = 0 THEN
        dbms_output.put_line('Nu exista jobul cu id-ul dat');
    ELSE
        SELECT COUNT(employee_id) INTO cnt
        FROM emp_rs e, jobs j
        WHERE LOWER(j.job_id) = LOWER(job) AND e.job_id = j.job_id;
        IF cnt = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat care sa lucreaze pe job-ul dat');
        ELSE
            dbms_output.put_line('Angajati de pe job-ul ' || job);
            FOR i IN pachet_tema_rs.c(job) LOOP
                dbms_output.put_line(i.last_name||' '||i.first_name);
            END LOOP;
        END IF;
    END IF;
END;
/
  
BEGIN
    dbms_output.put_line('Detalii job-uri companie');
    dbms_output.new_line();
    FOR i IN pachet_tema_rs.c2 LOOP
        dbms_output.put_line(i.job_id || ' ' || i.job_title || ' ' || i.min_salary || ' ' || i.max_salary);
    END LOOP;
END;
/

EXECUTE pachet_tema_rs.lista_ang_job;

ROLLBACK;
SELECT * FROM emp_rs;
SELECT * FROM jh_rs;
SELECT * FROM departments;
SELECT * FROM jobs;
DROP TABLE emp_rs;
DROP TABLE jh_rs;
DROP SEQUENCE sec_rs;
DROP PACKAGE pachet_tema_rs;