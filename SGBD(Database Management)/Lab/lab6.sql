--1
--Rincu Stefania
WITH aux as (
SELECT department_name as nume, count(employee_id) as nr
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
GROUP BY department_name)
SELECT (CASE WHEN aux.nr = 0 THEN 'Departamentul ' || aux.nume || ' are 0 angajati' 
             WHEN aux.nr = 1 THEN 'Departamentul ' || aux.nume || ' are 1 angajat'
             ELSE 'Departamentul ' || aux.nume || ' are ' || aux.nr || ' angajat' END) as statement
FROM aux;

DECLARE
    CURSOR c IS 
        SELECT department_name, count(employee_id)
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+)
        GROUP BY department_name;
    v_nume departments.department_name%TYPE;
    v_nr NUMBER;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%NOTFOUND;
        IF v_nr = 0 THEN
            dbms_output.put_line('In departamentul ' || v_nume || ' nu lucreaza angajati');
        ELSIF v_nr = 1 THEN
            dbms_output.put_line('In departamentul ' || v_nume || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || v_nume || ' lucreaza ' || v_nr || ' angajati');
        END IF;
    END LOOP;
    IF n_nume IS NULL THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

--2
DECLARE
    CURSOR c IS 
        SELECT department_name, count(employee_id)
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+)
        GROUP BY department_name;
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER;
    t_nume tab_nume;
    t_nr tab_nr;
BEGIN
    OPEN c;
    LOOP
        FETCH c BULK COLLECT INTO t_nume, t_nr LIMIT 5;
        EXIT WHEN c%NOTFOUND;
        FOR i IN t_nr.FIRST..t_nr.LAST LOOP
            IF t_nr(i) = 0 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati');
            ELSIF t_nr(i) = 1 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza 1 angajat');
            ELSE 
                dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati');
            END IF;
        END LOOP;
    END LOOP;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

--Rincu Stefania
DECLARE
    CURSOR c IS 
        SELECT department_name, count(employee_id) as nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+)
        GROUP BY department_name;
    TYPE tab_nume IS TABLE OF c%ROWTYPE;
    t_nume tab_nume;
BEGIN
    OPEN c;
    LOOP
        FETCH c BULK COLLECT INTO t_nume LIMIT 5;
        EXIT WHEN c%NOTFOUND;
        FOR i IN t_nume.FIRST..t_nume.LAST LOOP
            IF t_nume(i).nr = 0 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' nu lucreaza angajati');
            ELSIF t_nume(i).nr = 1 THEN
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' lucreaza 1 angajat');
            ELSE 
                dbms_output.put_line('In departamentul ' || t_nume(i).department_name || ' lucreaza ' || t_nume(i).nr || ' angajati');
            END IF;
        END LOOP;
    END LOOP;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

--Rincu Stefania
DECLARE
    TYPE tab_nume IS TABLE OF departments.department_name%TYPE;
    TYPE tab_nr IS TABLE OF NUMBER;
    t_nume tab_nume;
    t_nr tab_nr;
BEGIN
    SELECT department_name, count(employee_id) BULK COLLECT INTO t_nume, t_nr
    FROM departments d, employees e
    WHERE d.department_id = e.department_id(+)
    GROUP BY department_name;
     
    FOR i IN t_nume.FIRST..t_nume.LAST LOOP
        IF t_nr(i) = 0 THEN
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' nu lucreaza angajati');
        ELSIF t_nr(i) = 1 THEN                
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || t_nume(i) || ' lucreaza ' || t_nr(i) || ' angajati');
        END IF;
    END LOOP;
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/

--3
DECLARE
    CURSOR c IS 
        SELECT department_name as nume, count(employee_id) as nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+)
        GROUP BY department_name;
    nr NUMBER := 0;
BEGIN
    FOR i IN c LOOP
        nr := nr + 1;
        dbms_output.put_line(c%ROWCOUNT);
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;
    IF nr = 0 THEN 
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/

--4
DECLARE
    nr NUMBER := 0;
BEGIN
    FOR i IN (SELECT department_name as nume, count(employee_id) as nr
              FROM departments d, employees e
              WHERE d.department_id = e.department_id(+)
              GROUP BY department_name) LOOP
        nr := nr + 1;
        dbms_output.put_line(nr);
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;
    IF nr = 0 THEN 
        dbms_output.put_line('Nicio linie');
    END IF;
END;
/

--5
SELECT sef.last_name, count(ang.employee_id) nr
FROM employees sef, employees ang
WHERE ang.manager_id = sef.employee_id
GROUP BY sef.last_name
ORDER BY nr DESC;

DECLARE
    CURSOR c IS
        SELECT sef.last_name, count(ang.employee_id) nr
        FROM employees sef, employees ang
        WHERE ang.manager_id = sef.employee_id
        GROUP BY sef.last_name
        ORDER BY nr DESC;
    v_nume employees.last_name%TYPE;
    v_nr NUMBER;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%ROWCOUNT > 3 OR c%NOTFOUND;
        dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_nr || ' angajati');
    END LOOP;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

