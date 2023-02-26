--1
/*
DECLARE
    v_nume, v_prenume VARCHAR2(35);
BEGIN
    NULL;
END;
/
*/ 
--eroare pt ca nu ai voie sa declari 2 var pe ac linie
DECLARE
    v_nume VARCHAR2(35);
    v_prenume VARCHAR2(35);
BEGIN
    NULL;
END;
/
--PL/SQL procedure successfully completed.

DECLARE
    v_nr NUMBER(4);
BEGIN
    NULL;
END;
/

DECLARE
    v_nr NUMBER(5, 2) := 10;
BEGIN
    NULL;
END;
/

DECLARE
    v_test BOOLEAN := TRUE;
BEGIN
    NULL;
END;
/

DECLARE
    v1 NUMBER(5) := 10;
    v2 NUMBER(5) := 15;
    v3 BOOLEAN := v1 < v2;
BEGIN
    NULL;
END;
/

<<principal>>
DECLARE
    v_client_id NUMBER(4) := 1600;
    v_client_name VARCHAR2(50) := 'N1';
    v_nou_client_id NUMBER(4) := 500;
BEGIN
    <<secundar>>
    DECLARE
        v_client_id NUMBER(4) := 0;
        v_client_name VARCHAR2(50) := 'N2';
        v_nou_client_id NUMBER(4) := 300;
        v_nou_client_name VARCHAR2(50) := 'N3';
    BEGIN
        v_client_id := v_nou_client_id;
        principal.v_client_name := v_client_name || ' ' || v_nou_client_name;
        --pozitia 1
        dbms_output.put_line(v_client_id);
        dbms_output.put_line(v_client_name);
        dbms_output.put_line(v_nou_client_id);
        dbms_output.put_line(v_nou_client_name);
    END;
    v_client_id := (v_client_id * 12) / 10;
    --pozitia 2
    dbms_output.put_line(v_client_id);
    dbms_output.put_line(v_client_name);
END;
/
/*
300
N2
300
N3
1920
N2 N3
*/

--3
--var1
VAR g_mesaj VARCHAR2(50)
BEGIN
    :g_mesaj := 'Invat PL/SQL';
END;
/
PRINT g_mesaj;

--var2
BEGIN
    dbms_output.put_line('Invat PL/SQL');
END;
/

--4
select department_name
from employees e, departments d
where e.department_id = d.department_id
group by department_name
having count(*) = (select max(count(*))
                   from employees 
                   group by department_id);
                   
DECLARE
    v_dep_name departments.department_name%TYPE;
BEGIN
    select department_name
    into v_dep_name
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep_name);
END;
/

--5
VAR rezultat VARCHAR2(50)
BEGIN
    select department_name
    into :rezultat
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul ' || :rezultat);
END;
/
PRINT rezultat;

--6
DECLARE
    v_dep_name departments.department_name%TYPE;
    v_nr_ang NUMBER(4);
BEGIN
    select department_name, count(*) as nr_ind
    into v_dep_name, v_nr_ang
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) = (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep_name || ' are ' || v_nr_ang || ' angajati');
END;
/

DECLARE
    v_dep_name departments.department_name%TYPE;
BEGIN
    select department_name
    into v_dep_name
    from employees e, departments d
    where e.department_id = d.department_id
    group by department_name
    having count(*) <> (select max(count(*))
                       from employees 
                       group by department_id);
    dbms_output.put_line('Departamentul ' || v_dep_name);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Mai multe linii');
END;
/