--6
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
    v_prec NUMBER;
    v_top NUMBER := 1;
BEGIN
    OPEN c;
    FETCH c INTO v_nume, v_prec;
    dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_prec || ' angajati');
    LOOP
        FETCH c INTO v_nume, v_nr;
        EXIT WHEN c%NOTFOUND;
        IF v_nr <> v_prec THEN
            v_top := v_top + 1;
        END IF;
        EXIT WHEN v_top = 4;
        dbms_output.put_line('Managerul ' || v_nume || ' conduce ' || v_nr || ' angajati');
        v_prec := v_nr;
    END LOOP;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

WITH aux AS
    (SELECT sef.last_name nume, count(ang.employee_id) nr
     FROM employees sef, employees ang
     WHERE ang.manager_id = sef.employee_id
     GROUP BY sef.last_name)
SELECT 'Manager ' || nume || ' conduce ' || nr || ' angajati'
FROM aux a
WHERE 2 >= (SELECT COUNT(DISTINCT nr)
            FROM aux
            WHERE nr > a.nr)
ORDER BY nr DESC;

--6
DECLARE
    CURSOR c IS
        SELECT sef.employee_id cod, MAX(sef.last_name) nume, count(*) nr
        FROM employees sef, employees ang
        WHERE ang.manager_id = sef.employee_id
        GROUP BY sef.employee_id
        ORDER BY nr DESC;
BEGIN
    FOR i IN c LOOP
        EXIT WHEN c%ROWCOUNT>3 OR c%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Managerul '|| i.cod || ' avand numele ' || i.nume || ' conduce '|| i.nr||' angajati');
    END LOOP;
END;
/

--7
DECLARE
    poz NUMBER := 0;
BEGIN
    FOR i IN (SELECT sef.employee_id cod, MAX(sef.last_name) nume, COUNT(*) nr
              FROM employees sef JOIN employees ang ON sef.employee_id = ang.manager_id
              GROUP BY sef.employee_id
              ORDER BY nr DESC) LOOP
        dbms_output.put_line('Managerul '|| i.cod || ' avand numele ' || i.nume || ' conduce ' || i.nr ||' angajati');
        poz := poz + 1;
        EXIT WHEN poz = 3;
    END LOOP;
END;
/

--8
--Rincu Stefania
DECLARE
    v_p NUMBER := &p;
    CURSOR c (parametru  NUMBER) IS 
        SELECT department_name, count(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+) 
        GROUP BY department_name
        HAVING count(employee_id) >= parametru;
    v_nume departments.department_name%TYPE;
    v_nr NUMBER;
BEGIN
    OPEN c(v_p);
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
    IF v_nume IS NULL THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    IF c%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nicio linie');
    END IF;
    CLOSE c;
END;
/

DECLARE
    v_p NUMBER := &p;
    CURSOR c(parametru  NUMBER) IS 
        SELECT department_name nume, count(employee_id) nr
        FROM departments d, employees e
        WHERE d.department_id = e.department_id(+) 
        GROUP BY department_name
        HAVING count(employee_id) >= parametru;
BEGIN
    FOR i IN c(v_p) LOOP
        EXIT WHEN c%NOTFOUND;
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;
END;
/

DECLARE
    v_p NUMBER := &p;
BEGIN
    FOR i IN (SELECT department_name nume, count(employee_id) nr
              FROM departments d, employees e
              WHERE d.department_id = e.department_id(+) 
              GROUP BY department_name
              HAVING count(employee_id) >= v_p) LOOP
        IF i.nr = 0 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' nu lucreaza angajati');
        ELSIF i.nr = 1 THEN
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza 1 angajat');
        ELSE 
            dbms_output.put_line('In departamentul ' || i.nume || ' lucreaza ' || i.nr || ' angajati');
        END IF;
    END LOOP;
END;
/

--9
DECLARE 
    CURSOR c IS SELECT *
                FROM emp_rs
                WHERE to_char(hire_date, 'YYYY') = 2000
                FOR UPDATE;
BEGIN
    FOR i IN c LOOP
        UPDATE emp_rs
        SET salary = salary + 100
        WHERE CURRENT OF c;
    END LOOP;
END;
/

DECLARE 
    CURSOR c IS SELECT *
                FROM emp_rs
                WHERE to_char(hire_date, 'YYYY') = 2000
                FOR UPDATE NOWAIT;
BEGIN
    FOR i IN c LOOP
        UPDATE emp_rs
        SET salary = salary + 100
        WHERE CURRENT OF c;
    END LOOP;
END;
/

DECLARE 
    CURSOR c IS SELECT *
                FROM emp_rs
                WHERE to_char(hire_date, 'YYYY') = 2000
                FOR UPDATE WAIT 8;
BEGIN
    FOR i IN c LOOP
        UPDATE emp_rs
        SET salary = salary + 100
        WHERE CURRENT OF c;
    END LOOP;
END;
/

--10
--Rincu Stefania
BEGIN
    FOR depart IN (SELECT department_id, department_name
                     FROM departments
                     WHERE department_id IN (10,20,30,40)) LOOP
            DBMS_OUTPUT.PUT_LINE ('Departamentul '||depart.department_name);
            FOR ang IN (SELECT last_name
                        FROM employees
                        WHERE department_id = depart.department_id) LOOP
                DBMS_OUTPUT.PUT_LINE (ang.last_name);
            END LOOP;
    END LOOP;
END;
/

DECLARE
    CURSOR c_dept IS SELECT department_name, 
                            CURSOR (SELECT first_name || ' ' || last_name
                            FROM employees e
                            WHERE e.department_id = d.department_id)
                     FROM departments d
                     WHERE department_id IN (10, 20, 30, 40);
    v_nume_dept departments.department_name%TYPE;
    v_nume_ang VARCHAR2(50);
    TYPE refcursor IS REF CURSOR;
    v_cursor refcursor;
BEGIN
    OPEN c_dept;
    LOOP
        FETCH c_dept INTO v_nume_dept, v_cursor;
        EXIT WHEN c_dept%NOTFOUND;
        dbms_output.put_line('Departament ' || v_nume_dept);
        LOOP
            FETCH v_cursor INTO v_nume_ang;
            EXIT WHEN v_cursor%NOTFOUND;
            dbms_output.put_line(v_nume_ang);
        END LOOP;
        dbms_output.new_line();
    END LOOP;
    CLOSE c_dept;
END;
/

--11
DECLARE
    TYPE emp_tip IS REF CURSOR RETURN employees%ROWTYPE;
    v_emp emp_tip;
    optiune NUMBER := &optiune;
    v_ang employees%ROWTYPE;
BEGIN
    IF optiune = 1 THEN
        OPEN v_emp FOR SELECT * FROM employees;
    ELSIF optiune = 2 THEN
        OPEN v_emp FOR SELECT * FROM employees WHERE salary BETWEEN 10000 AND 20000;
    ELSIF optiune = 3 THEN
        OPEN v_emp FOR SELECT * FROM employees WHERE to_char(hire_date, 'YYYY') = 2000;
    ELSE
        dbms_output.put_line('Optiunea nu e valida');
    END IF;
    IF v_emp%ISOPEN THEN
        LOOP 
            FETCH v_emp INTO v_ang;
            EXIT WHEN v_emp%NOTFOUND;
            dbms_output.put_line(v_emp%ROWCOUNT || '. ' || v_ang.last_name);
        END LOOP;
        CLOSE v_emp;
    END IF;
END;
/

--12
DECLARE
    TYPE empref IS REF CURSOR;
    v_emp empref;
    v_nr NUMBER := &v_nr;
    nume employees.last_name%TYPE;
    sal employees.salary%TYPE;
    comi employees.commission_pct%TYPE;
BEGIN
    OPEN v_emp FOR 
        'SELECT last_name, salary, commission_pct ' ||
        'FROM employees WHERE salary > :bind_var'
        USING v_nr;
    LOOP 
        FETCH v_emp INTO nume, sal, comi;
        EXIT WHEN v_emp%NOTFOUND;
        dbms_output.put_line('Numele ' || nume || ' Salariul ' || sal || ' Comisionul ' || comi || '%');
    END LOOP;
END;
/