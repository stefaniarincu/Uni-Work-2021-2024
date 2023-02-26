--4
DESC departments;
CREATE TABLE info_dept_rs(
    id NUMBER(4) PRIMARY KEY,
    nume_dept VARCHAR2(30),
    plati NUMBER);

INSERT INTO info_dept_rs
SELECT d.department_id, department_name, sum(salary)
FROM departments d, employees e
WHERE d.department_id = e.department_id(+)
GROUP BY d.department_id, department_name;

COMMIT;

SELECT * FROM info_dept_rs;

CREATE OR REPLACE PROCEDURE modific_plati_rs
    (v_cod info_dept_rs.id%TYPE,
     v_plati info_dept_rs.plati%TYPE)
IS
BEGIN
    UPDATE info_dept_rs
    SET plati = NVL(plati, 0) + v_plati
    WHERE id = v_cod;
END;
/

CREATE OR REPLACE TRIGGER trig4_rs
    AFTER DELETE OR INSERT OR UPDATE OF salary ON emp_rs
    FOR EACH ROW
BEGIN
    IF DELETING THEN
        modific_plati_rs(:OLD.department_id, -1 * :OLD.salary);
    ELSIF UPDATING THEN
        modific_plati_rs(:OLD.department_id, :NEW.salary - :OLD.salary);
    ELSE
        modific_plati_rs(:NEW.department_id, :NEW.salary);
    END IF;
END;
/

SELECT * FROM info_dept_rs
WHERE id = 90;

INSERT INTO emp_rs(employee_id, last_name, first_name, email, hire_date, job_id, salary, department_id)
VALUES(300, 'N1', 'P1', 'n1@g.com', sysdate, 'SA_REP', 2000, 90);

UPDATE emp_rs
SET salary = salary + 1000
WHERE employee_id = 300;

DELETE FROM emp_rs
WHERE employee_id = 300;

DROP TRIGGER trig4_rs;

--5
DESC employees;

CREATE TABLE info_emp_rs(
    id NUMBEr(6) PRIMARY KEY,
    nume VARCHAR2(25),
    prenume VARCHAR2(20),
    salariu NUMBER,
    id_dept NUMBER(4) REFERENCES info_dept_rs(id)
);

INSERT INTO info_emp_rs
SELECT employee_id, last_name, first_name, salary, department_id
FROM emp_rs;

COMMIT;

CREATE OR REPLACE VIEW v_info_rs AS
    SELECT e.id, e.nume, e.prenume, e.salariu, e.id_dept, d.nume_dept, d.plati
    FROM info_emp_rs e, info_dept_rs d
    WHERE e.id_dept = d.id;
    
SELECT * FROM v_info_rs;

SELECT * 
FROM user_updatable_columns
WHERE table_name = UPPER('v_info_rs');

CREATE OR REPLACE TRIGGER trig5_rs
    INSTEAD OF INSERT OR DELETE OR UPDATE ON v_info_rs
    FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO info_emp_rs
        VALUES (:NEW.id, :NEW.nume, :NEW.prenume, :NEW.salariu, :NEW.id_dept);
        
        UPDATE info_dept_rs
        SET plati = NVL(plati, 0) + :NEW.salariu
        WHERE id = :NEW.id_dept;
    ELSIF DELETING THEN
        DELETE FROM info_emp_rs
        WHERE id = :OLD.id;
        
        UPDATE info_dept_rs
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('salariu') THEN
        UPDATE info_emp_rs
        SET salariu = :NEW.salariu
        WHERE id = :OLD.id;
        
        UPDATE info_dept_rs
        SET plati = plati - :OLD.salariu + :NEW.salariu
        WHERE id = :OLD.id_dept;
    END IF;
    IF UPDATING('id_dept') THEN
        UPDATE info_emp_rs
        SET id_dept = :NEW.id_dept
        WHERE id = :OLD.id;
        
        UPDATE info_dept_rs
        SET plati = plati - :OLD.salariu
        WHERE id = :OLD.id_dept;
        
        UPDATE info_dept_rs
        SET plati = plati + :NEW.salariu
        WHERE id = :NEW.id_dept;
    END IF;
END;
/

SELECT * FROM info_dept_rs 
WHERE id = 10;

INSERT INTO v_info_rs 
VALUES (400, 'N1', 'P1', 3000, 10, 'Nume dept', 0);

SELECT * FROM info_emp_rs
WHERE id = 400;
SELECT * FROM info_dept_rs
WHERE id = 10;

UPDATE v_info_rs
SET salariu = salariu + 1000
WHERE id = 400;

SELECT * FROM info_dept_rs
WHERE id = 90;

UPDATE v_info_rs
SET id_dept = 90
WHERE id = 400;

DELETE FROM v_info_rs
WHERE id = 400;

DROP TRIGGER trig5_rs;

--6
CREATE OR REPLACE TRIGGER trigg6_rs
    BEFORE DELETE ON emp_rs
BEGIN
    IF USER = UPPER('grupa232') THEN
        RAISE_APPLICATION_ERROR(-20900, 'Nu este permisa stergerea');
    END IF;
END;
/

DELETE FROM emp_rs;

DROP TRIGGER trig6_rs;

--7
CREATE TABLE audit_rs
    (utilizator VARCHAR2(30),
     nume_bd VARCHAR2(50),
     eveniment VARCHAR2(30),
     nume_obiect VARCHAR2(30),
     data DATE);
     
CREATE OR REPLACE TRIGGER trig7_rs
    AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO audit_rs
    VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, SYS.SYSEVENT, SYS.DICTIONARY_OBJ_NAME, SYSDATE);
END;
/

CREATE INDEX ind_rs ON info_emp_rs(nume);
DROP INDEX ind_rs;

DROP TRIGGER trig7_rs;

--8
CREATE OR REPLACE PACKAGE pachet_rs
AS
    min_sal NUMBER;
    max_sal NUMBER;
    med_sal NUMBER;
END pachet_rs;
/

CREATE OR REPLACE TRIGGER trig81_rs
    BEFORE UPDATE OF salary ON emp_rs
BEGIN
    SELECT MIN(salary), MAX(salary), AVG(salary)
    INTO pachet_rs.min_sal, pachet_rs.max_sal, pachet_rs.med_sal
    FROM emp_rs;
END;
/
    

CREATE OR REPLACE TRIGGER trig8_rs
    BEFORE UPDATE OF salary ON emp_rs
    FOR EACH ROW
BEGIN
    IF :OLD.salary = pachet_rs.max_sal AND :NEW.salary < pachet_rs.med_sal THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu este sub valoarea medie');
    ELSIF :OLD.salary = pachet_rs.min_sal AND :NEW.salary > pachet_rs.med_sal THEN
        RAISE_APPLICATION_ERROR(-20001, 'Acest salariu depaseste valoarea medie');
    END IF;
END;
/

UPDATE emp_rs 
SET salary = 10000
WHERE salary = (SELECT MIN(salary)
                FROM emp_rs);
                
UPDATE emp_rs 
SET salary = 10
WHERE salary = (SELECT MAX(salary)
                FROM emp_rs);
                
UPDATE emp_rs 
SET salary = 1000
WHERE salary = (SELECT MIN(salary)
                FROM emp_rs);
ROLLBACK;         
DROP TRIGGER trig81_rs;
DROP TRIGGER trig8_rs;