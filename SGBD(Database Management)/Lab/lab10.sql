--1
CREATE OR REPLACE PACKAGE pachet1_rs AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
    FUNCTION f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER;
END pachet1_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet1_rs AS
    FUNCTION f_numar(v_dept departments.department_id%TYPE) 
        RETURN NUMBER
    IS 
        nr NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nr
        FROM employees
        WHERE department_id = v_dept;
        
        RETURN nr;
    END f_numar;
    FUNCTION f_suma(v_dept departments.department_id%TYPE) 
        RETURN NUMBER
    IS 
        suma NUMBER;
    BEGIN
        SELECT SUM(salary + (salary * nvl(commission_pct, 0))) INTO suma
        FROM employees
        WHERE department_id = v_dept;
        
        RETURN suma;
    END f_suma;
END pachet1_rs;
/

SELECT pachet1_rs.f_numar(80)
FROM dual;

SELECT pachet1_rs.f_suma(80)
FROM dual;

SELECT pachet1_rs.f_numar(80), pachet1_rs.f_suma(80)
FROM dual;

BEGIN
    dbms_output.put_line('numarul de salariati este ' || pachet1_rs.f_numar(80));
    dbms_output.put_line('suma alocata este ' || pachet1_rs.f_suma(80));
END;
/

--2
CREATE SEQUENCE seq_rs 
START WITH 207
INCREMENT BY 1;

CREATE OR REPLACE PACKAGE pachet2_rs AS
    PROCEDURE insert_dep(id departments.department_id%TYPE, nume departments.department_name%TYPE,
                         man departments.manager_id%TYPE, loc departments.location_id%TYPE);
    PROCEDURE insert_ang(prenume employees.first_name%TYPE, nume employees.last_name%TYPE,
                         em employees.email%TYPE, hd employees.hire_date%TYPE, j employees.job_id%TYPE,
                         man employees.manager_id%TYPE, dep employees.department_id%TYPE);
END pachet2_rs;
/

CREATE OR REPLACE PACKAGE BODY pachet2_rs AS
    PROCEDURE insert_dep(id departments.department_id%TYPE, nume departments.department_name%TYPE,
                         man departments.manager_id%TYPE, loc departments.location_id%TYPE)
    AS
        nr NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nr
        FROM employees
        WHERE employee_id = man;
        
        IF nr = 0 THEN
            dbms_output.put_line('Nu exista managerul ca angajat');
        ELSE 
            SELECT COUNT(*) INTO nr
            FROM locations
            WHERE location_id = loc;
            
            IF nr = 0 THEN
                dbms_output.put_line('Nu exista locatia data');
            ELSE
                INSERT INTO dept_rs VALUES(id, nume, man, loc);
            END IF;
        END IF;
    END insert_dep;
    PROCEDURE insert_ang(prenume employees.first_name%TYPE, nume employees.last_name%TYPE, 
                         em employees.email%TYPE, hd employees.hire_date%TYPE, j employees.job_id%TYPE,
                         man employees.manager_id%TYPE, dep employees.department_id%TYPE)
    AS
        nr NUMBER;
    BEGIN
        SELECT COUNT(*) INTO nr
        FROM employees
        WHERE employee_id = man;
        
        IF nr = 0 THEN
            dbms_output.put_line('Nu exista managerul dat');
        ELSE 
            SELECT COUNT(*) INTO nr
            FROM dept_rs
            WHERE department_id = dep;
            
            IF nr = 0 THEN
                dbms_output.put_line('Nu exista departamentul dat');
            ELSE
                SELECT COUNT(*) INTO nr
                FROM jobs
                WHERE job_id = j;
            
                IF nr = 0 THEN
                    dbms_output.put_line('Nu exista jobul dat');
                ELSE
                    INSERT INTO emp_rs(employee_id, first_name, last_name, email, hire_date, job_id, manager_id, department_id)
                    VALUES(seq_rs.nextval, prenume, nume, em, hd, j, man, dep);
                END IF;
            END IF;
        END IF;
    END insert_ang;
END pachet2_rs;
/

EXECUTE pachet2_rs.insert_dep(1231, 'DEPAAAAAARTAMEEEEENNNNT', 200, 2000);

EXECUTE pachet2_rs.insert_ang('f', 'l', 'e', sysdate, 'AD_PRES', 200, 1231);

drop table dept_rs;
drop table emp_rs;
