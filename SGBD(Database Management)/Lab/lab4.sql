--7
SET VERIFY OFF
DECLARE
    v_cod employees.employee_id%TYPE := &p_cod;
    v_salariu_anual NUMBER;
    v_bonus NUMBER;
BEGIN
    SELECT salary*12 INTO v_salariu_anual 
    FROM employees 
    WHERE employee_id = v_cod;
    
    IF v_salariu_anual >= 200001 THEN
        v_bonus := 20000;
    ELSIF v_salariu_anual BETWEEN 100001 AND 200000 THEN
        v_bonus := 10000;
    ELSIF v_salariu_anual <= 100000 THEN
        v_bonus := 5000;
    END IF;
    
    dbms_output.put_line('Bonusul este ' || v_bonus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista niciun angajat cu codul ' || v_cod);
END;
/

--8
SET VERIFY OFF
DECLARE
    v_cod employees.employee_id%TYPE := &p_cod;
    v_salariu_anual NUMBER;
    v_bonus NUMBER;
BEGIN
    SELECT salary*12 INTO v_salariu_anual 
    FROM employees 
    WHERE employee_id = v_cod;
    
    CASE
    WHEN v_salariu_anual >= 200001 THEN
        v_bonus := 20000;
    WHEN v_salariu_anual >= 100001 THEN
        v_bonus := 10000;
    ELSE v_bonus := 5000;
    END CASE;
    
    dbms_output.put_line('Bonusul este ' || v_bonus);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista niciun angajat cu codul ' || v_cod);
END;
/

--9
DEFINE p_cod_sal = 1
DEFINE p_cod_dep = 80
DEFINE p_procent = 20
DECLARE
        v_cod_sal  emp_rs.employee_id%TYPE := &p_cod_sal;
        v_cod_dep emp_rs.department_id%TYPE := &p_cod_dep;
        v_procent NUMBER := &p_procent;
BEGIN
    UPDATE emp_rs
    SET department_id = v_cod_dep, salary = salary + (salary*v_procent/100)
    WHERE employee_id = v_cod_sal;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    ELSE
        dbms_output.put_line('Actualizare realizata');
    END IF;
END;
/
ROLLBACK;

--10
CREATE TABLE zile_rs(
    id NUMBER PRIMARY KEY,
    data DATE,
    nume_zi VARCHAR2(20)
);

DECLARE
    contor NUMBER := 1;
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_rs
        VALUES(contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
        EXIT WHEN contor > maxim;
    END LOOP;
END;
/

select * from zile_rs;

rollback;

alter session
set nls_language = 'ENGLISH'; 

--11
DECLARE
    contor NUMBER := 1;
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    WHILE contor <= maxim LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_rs
        VALUES(contor, v_data, to_char(v_data, 'Day'));
        contor := contor + 1;
    END LOOP;
END;
/

select * from zile_rs;
rollback;

--12
DECLARE
    v_data DATE;
    maxim NUMBER := last_day(sysdate) - sysdate;
BEGIN
    FOR contor IN 1..maxim LOOP
        v_data := sysdate + contor;
        INSERT INTO zile_rs
        VALUES(contor, v_data, to_char(v_data, 'Day'));
    END LOOP;
END;
/

select * from zile_rs;
rollback;

--13
DECLARE 
    i POSITIVE := 1;
    max_loop CONSTANT POSITIVE := 10;
BEGIN
    LOOP 
        i := i + 1;
        IF i > max_loop THEN 
            dbms_output.put_line('in loop i=' || i);
            GOTO urmator;
        END IF;
    END LOOP;
    <<urmator>>
    i := 1;
END;
/

DECLARE 
    i POSITIVE := 1;
    max_loop CONSTANT POSITIVE := 10;
BEGIN
    LOOP 
        i := i + 1;
        dbms_output.put_line('in loop i=' || i);
        EXIT WHEN i > max_loop;
    END LOOP;
    i := 1;
END;
/

--1
DECLARE
    x NUMBER := 5;
    y x%TYPE := NULL;
BEGIN
    IF x <> y THEN --rezultatul e null
        dbms_output.put_line('valoare <> null este = true');
    ELSE
        dbms_output.put_line('valoare <> null este != true');
    END IF;
    
    x := NULL;
    
    IF x = y THEN --rezultatul e null
        dbms_output.put_line('null = null este = true');
    ELSE
        dbms_output.put_line('null = null este != true');
    END IF;
END;
/

--2
--a
DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    v_ang.cod := 700;
    v_ang.salariu := 9000;
    v_ang.job := 'SA_MAN';
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    SELECT 700, 9000, 'SA_MAN'
    INTO v_ang.cod, v_ang.salariu, v_ang.job
    FROM dual;
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

--b
DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    SELECT employee_id, salary, job_id
    INTO v_ang.cod, v_ang.salariu, v_ang.job
    FROM employees
    WHERE employee_id = 101;
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    SELECT employee_id, salary, job_id
    INTO v_ang
    FROM employees
    WHERE employee_id = 102;
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/

--c
DECLARE
    TYPE emp_record IS RECORD
        (cod employees.employee_id%TYPE,
         salariu employees.salary%TYPE,
         job employees.job_id%TYPE);
    v_ang emp_record;
BEGIN
    DELETE FROM emp_rs
    WHERE employee_id = 100
    RETURNING employee_id, salary, job_id INTO v_ang;
    dbms_output.put_line('Angajatul cu codul ' || v_ang.cod || ' si jobul ' || v_ang.job || ' are salariul ' || v_ang.salariu);
END;
/
ROLLBACK;

--3
DECLARE
    v_ang1 employees%ROWTYPE;
    v_ang2 employees%ROWTYPE;
BEGIN
    DELETE FROM emp_rs
    WHERE employee_id = 100
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, 
              job_id, salary, commission_pct, manager_id, department_id
    INTO v_ang1;
    
    INSERT INTO emp_rs
    VALUES v_ang1;
    
    DELETE FROM emp_rs
    WHERE employee_id = 101;
    
    SELECT * 
    INTO v_ang2
    FROM employees
    WHERE employee_id = 101;
    
    INSERT INTO emp_rs
    VALUES (1000, 'FN', 'LN', 'E', null, sysdate, 'AD_VP', 1000, null, 100, 90);
    
    UPDATE emp_rs
    SET ROW = v_ang2
    WHERE employee_id = 1000;
END;
/
rollback;