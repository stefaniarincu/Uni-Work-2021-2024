--4
DECLARE
    TYPE tab_idx IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    t tab_idx;
BEGIN
    FOR i IN 1..10 LOOP
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    FOR i IN 1..10 LOOP
        IF i MOD 2 = 1 THEN
            t(i) := NULL;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE(t.FIRST);
    t.DELETE(5, 7);
    t.DELETE(t.LAST);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.FIRST || '-' || nvl(t(t.FIRST), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.LAST || '-' || nvl(t(t.LAST), 0));
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE;
    dbms_output.put_line(t.COUNT || ' elemente');
END;
/

--5
DECLARE
    TYPE tab_idx IS TABLE OF emp_rs%ROWTYPE INDEX BY PLS_INTEGER;
    t tab_idx;
BEGIN
    DELETE FROM emp_rs
    WHERE rownum <= 2
    RETURNING employee_id, first_name, last_name, email, phone_number, hire_date, 
              job_id, salary, commission_pct, manager_id, department_id
    BULK COLLECT INTO t;
    
    FOR i IN t.FIRST..t.LAST LOOP
       dbms_output.put_line(t(i).employee_id ||' ' || t(i).first_name ||' ' || t(i).last_name ||' ' || t(i).email 
                    ||' ' || t(i).phone_number ||' ' || t(i).hire_date ||' ' || t(i).job_id ||' ' || t(i).salary 
                    ||' ' || t(i).commission_pct ||' ' || t(i).manager_id ||' ' || t(i).department_id);
    END LOOP;
    
    INSERT INTO emp_rs VALUES t(1);
    INSERT INTO emp_rs VALUES t(2);
END;
/

--6
DECLARE
    TYPE tab_imb IS TABLE OF NUMBER;
    t tab_imb := tab_imb();
BEGIN
    FOR i IN 1..10 LOOP
        t.EXTEND;
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    FOR i IN 1..10 LOOP
        IF i MOD 2 = 1 THEN
            t(i) := NULL;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE(t.FIRST);
    t.DELETE(5, 7);
    t.DELETE(t.LAST);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.FIRST || '-' || nvl(t(t.FIRST), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.LAST || '-' || nvl(t(t.LAST), 0));
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE;
    dbms_output.put_line(t.COUNT || ' elemente');
END;
/

--7
DECLARE
    TYPE tab_imb IS TABLE OF CHAR;
    t tab_imb := tab_imb('m', 'i', 'n', 'i', 'm');
    i NUMBER;
BEGIN
    i := t.FIRST;
    WHILE i <= t.LAST LOOP
        dbms_output.put(t(i) || ' ');
        i := t.NEXT(i);
    END LOOP;
    dbms_output.new_line();
    
    i := t.LAST;
    WHILE i >= t.FIRST LOOP
        dbms_output.put(t(i) || ' ');
        i := t.PRIOR(i);
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE(2);
    t.DELETE(4);
    
    i := t.FIRST;
    WHILE i <= t.LAST LOOP
        dbms_output.put(t(i) || ' ');
        i := t.NEXT(i);
    END LOOP;
    dbms_output.new_line();
END;
/

--8
DECLARE
    TYPE vector IS VARRAY(20) OF NUMBER;
    t vector := vector();
BEGIN
    FOR i IN 1..10 LOOP
        t.EXTEND;
        t(i) := i;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(t(i) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    FOR i IN 1..10 LOOP
        IF i MOD 2 = 1 THEN
            t(i) := NULL;
        END IF;
    END LOOP;
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        dbms_output.put(nvl(t(i), 0) || ' ');
    END LOOP;
    dbms_output.new_line();
    
    t.TRIM(3);
    
    dbms_output.put_line('Prima pereche cheie-valoare: ' || t.FIRST || '-' || nvl(t(t.FIRST), 0));
    dbms_output.put_line('Ultima pereche cheie-valoare: ' || t.LAST || '-' || nvl(t(t.LAST), 0));
    
    dbms_output.put(t.COUNT || ': ');
    FOR i IN t.FIRST..t.LAST LOOP
        IF t.EXISTS(i) THEN
            dbms_output.put(nvl(t(i), 0) || ' ');
        END IF;
    END LOOP;
    dbms_output.new_line();
    
    t.DELETE;
    dbms_output.put_line(t.COUNT || ' elemente');
END;
/

--9
CREATE OR REPLACE TYPE subordonati_rs IS VARRAY(10) OF NUMBER;
/
CREATE TABLE manageri_rs (cod_mgr NUMBER(10), 
                          nume VARCHAR2(20),
                          lista subordonati_rs);
/
INSERT INTO manageri_rs
VALUES (1, 'Mgr 1', subordonati_rs(100, 200, 300));

INSERT INTO manageri_rs
VALUES (2, 'Mgr 2', null);

INSERT INTO manageri_rs
VALUES (3, 'Mgr 3', subordonati_rs(400, 500));

SELECT * FROM manageri_rs;

DROP TABLE manageri_rs;

DROP TYPE subordonati_rs;

--10
CREATE TABLE emp_test_rs AS SELECT employee_id, last_name FROM employees;
CREATE OR REPLACE TYPE tip_tel_rs IS TABLE OF VARCHAR2(12);
/

ALTER TABLE emp_test_rs ADD 
telefon tip_tel_rs
NESTED TABLE telefon STORE AS tabel_telefon_rs;

SELECT * FROM emp_test_rs;

INSERT INTO emp_test_rs
VALUES (500, 'XYZ', tip_tel_rs('073XXX', '0213XXX', '037XXX'));

SELECT * FROM emp_test_rs WHERE employee_id = 500;

UPDATE emp_test_rs
SET telefon = tip_tel_rs('072XXX', '0214XXX')
WHERE employee_id = 500;

SELECT a.employee_id, a.last_name, b.*
FROM emp_test_rs a, TABLE (a.telefon) b;

--11
--Varianta 1
DECLARE
    TYPE vect IS VARRAY(10) OF NUMBER;
    t vect := vect(100, 101, 102);
BEGIN
    FOR i IN t.FIRST..t.LAST LOOP
        DELETE FROM emp_rs
        WHERE employee_id = t(i);
    END LOOP;
END;
/

--Varianta 2
DECLARE
    TYPE vect IS VARRAY(10) OF NUMBER;
    t vect := vect(100, 101, 102);
BEGIN
    FORALL i IN t.FIRST..t.LAST
        DELETE FROM emp_rs
        WHERE employee_id = t(i);
END;
/
DROP TABLE emp_test_rs;
DROP TYPE tip_tel_rs;