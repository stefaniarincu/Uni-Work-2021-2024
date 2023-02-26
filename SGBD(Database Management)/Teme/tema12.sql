--1. Defini?i un declan?ator care s? permit? ?tergerea informa?iilor din tabelul dept_*** decât dac? 
--utilizatorul este SCOTT.
CREATE OR REPLACE TRIGGER trig1_tema_rs
    BEFORE DELETE ON dept_rs
BEGIN
    IF SYS.LOGIN_USER != 'SCOTT' THEN
        RAISE_APPLICATION_ERROR(-20900, 'Nu este permisa stergerea');
    END IF;
END;
/

--2. Crea?i un declan?ator prin care s? nu se permit? m?rirea comisionului astfel încât s? dep??easc? 
--50% din valoarea salariului.
CREATE OR REPLACE TRIGGER trig2_tema_rs
    BEFORE UPDATE OF commission_pct ON emp_rs
BEGIN   
    IF :OLD.salary * 0.5 <= :NEW.commission_pct THEN
        RAISE_APPLICATION_ERROR(-20901, 'Nu este permisa marirea comisionului');
    END IF;
END;
/

--3. a. Introduce?i în tabelul info_dept_*** coloana numar care va reprezenta pentru fiecare 
--departament num?rul de angaja?i care lucreaz? în departamentul respectiv. Popula?i cu date 
--aceast? coloan? pe baza informa?iilor din schem?.
SELECT * FROM info_dept_rs;

ALTER TABLE info_dept_rs
ADD numar NUMBER DEFAULT 0;

BEGIN
    FOR i IN (SELECT department_id, COUNT(*) cnt
              FROM emp_rs
              GROUP BY department_id) LOOP
        UPDATE info_dept_rs
        SET numar = nvl(i.cnt, 0)
        WHERE id = i.department_id;
    END LOOP;
END;
/

--b. Defini?i un declan?ator care va actualiza automat aceast? coloan? în func?ie de actualiz?rile 
--realizate asupra tabelului info_emp_***.
CREATE OR REPLACE TRIGGER trig3_tema_rs
    AFTER INSERT OR DELETE OR UPDATE OF id_dept ON info_emp_rs
    FOR EACH ROW
BEGIN
    IF INSERTING THEN      
        UPDATE info_dept_rs
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
    ELSIF DELETING THEN
        UPDATE info_dept_rs
        SET numar = numar + 1
        WHERE id = :OLD.id_dept;
    ELSIF UPDATING('id_dept') THEN
        UPDATE info_dept_rs
        SET numar = numar - 1
        WHERE id = :OLD.id_dept;
        
        UPDATE info_dept_rs
        SET numar = numar + 1
        WHERE id = :NEW.id_dept;
    END IF;
END;
/

SELECT * FROM info_emp_rs;
SELECT * FROM info_dept_rs;

UPDATE info_emp_rs
SET id_dept = 80 
WHERE id = 205; 

INSERT INTO info_emp_rs
VALUES(999, 'Fifi', 'Flo', 9999, 210);

DELETE info_emp_rs
WHERE id = 999;

--4. Defini?i un declan?ator cu ajutorul c?ruia s? se implementeze restric?ia conform c?reia într-un 
--departament nu pot lucra mai mult de 45 persoane (se vor utiliza doar tabelele emp_*** ?i
--dept_*** f?r? a modifica structura acestora).
CREATE OR REPLACE PACKAGE pachet_rs
AS
    cnt NUMBER;
END pachet_rs;
/

CREATE OR REPLACE TRIGGER trig4_tema_rs
    BEFORE INSERT OR UPDATE OF department_id ON emp_rs
    FOR EACH ROW
BEGIN
    IF INSERTING OR UPDATING('department_id') THEN      
        SELECT COUNT(*) INTO pachet_rs.cnt
        FROM emp_rs
        WHERE department_id = :NEW.department_id;
        IF pachet_rs.cnt + 1 > 45 THEN
            RAISE_APPLICATION_ERROR(-20900, 'Sunt mai mult de 45 de angajati in departamentul ales');
        END IF;
    END IF;
END;
/

--5. a. Pe baza informa?iilor din schem? crea?i ?i popula?i cu date urm?toarele dou? tabele: 
--- emp_test_*** (employee_id – cheie primar?, last_name, first_name, department_id);
--- dept_test_*** (department_id – cheie primar?, department_name).
CREATE TABLE dept_test_rs 
    (department_id NUMBER(4, 0) PRIMARY KEY,
     department_name VARCHAR2(25));

CREATE TABLE emp_test_rs 
    (employee_id NUMBER(6, 0) PRIMARY KEY,
     last_name VARCHAR2(25),
     first_name VARCHAR2(25),
     department_id NUMBER(4, 0));

BEGIN
    FOR i IN (SELECT department_id id, department_name dn
              FROM departments) LOOP
        INSERT INTO dept_test_rs 
        VALUES(i.id, i.dn);
    END LOOP;
    
    FOR i IN (SELECT employee_id id, last_name ln, first_name fn, n.department_id did
              FROM employees e, dept_test_rs n
              WHERE e.department_id = n.department_id) LOOP
        INSERT INTO emp_test_rs 
        VALUES(i.id, i.ln, i.fn, i.did);
    END LOOP;
END;
/

--b. Defini?i un declan?ator care va determina ?tergeri ?i modific?ri în cascad?:
--- ?tergerea angaja?ilor din tabelul emp_test_*** dac? este eliminat departamentul acestora 
--din tabelul dept_test_***; 
--- modificarea codului de departament al angaja?ilor din tabelul emp_test_*** dac? 
--departamentul respectiv este modificat în tabelul dept_test_***
CREATE OR REPLACE TRIGGER trig5_tema_rs
    AFTER DELETE OR UPDATE OF department_id ON dept_test_rs
    FOR EACH ROW
BEGIN
    IF DELETING THEN     
        DELETE FROM emp_test_rs
        WHERE department_id = :OLD.department_id;
    ELSIF UPDATING('department_id') THEN  
        UPDATE emp_test_rs
        SET department_id = :NEW.department_id
        WHERE department_id = :OLD.department_id;
    END IF;
END;
/

COMMIT;

--Testa?i ?i rezolva?i problema în urm?toarele situa?ii:
--    - nu este definit? constrângere de cheie extern? între cele dou? tabele;
--    - este definit? constrângerea de cheie extern? între cele dou? tabele;
--    - este definit? constrângerea de cheie extern? între cele dou? tabele cu op?iunea ON DELETE CASCADE;
--    - este definit? constrângerea de cheie extern? între cele dou? tabele cu op?iunea ON DELETE SET NULL.
--Comenta?i fiecare caz în parte.

--CAZUL 1    FARA CONSTRANGERE DE CHEIE EXTERNA
DELETE FROM dept_test_rs
WHERE department_id = 90;
--sterge din ambele tabele

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 80;
--updateaza din ambele tabele

--CAZUL 2    CU CONSTRANGERE DE CHEIE EXTERNA
ALTER TABLE emp_test_rs
ADD CONSTRAINT EMP_TEST_DEPT_FK FOREIGN KEY(department_id)
    REFERENCES dept_test_rs(department_id);

DELETE FROM dept_test_rs
WHERE department_id = 90;
--sterge din ambele tabele

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 90;
--updateaza in ambele tabele

--CAZUL 3    CU CONSTRANGERE DE CHEIE EXTERNA ON DELETE CASCADE
ALTER TABLE emp_test_rs
ADD CONSTRAINT EMP_TEST_DEPT_FK FOREIGN KEY(department_id)
    REFERENCES dept_test_rs(department_id) ON DELETE CASCADE;

DELETE FROM dept_test_rs
WHERE department_id = 90;
--  Error report -
--  ORA-04091: table GRUPA232.DEPT_TEST_RS is mutating, trigger/function may not see it
--  ORA-06512: at "GRUPA232.TRIG5_TEMA_RS", line 3
--  ORA-04088: error during execution of trigger 'GRUPA232.TRIG5_TEMA_RS'

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 90;
--updateaza in ambele tabele

--REZOLVARE EROARE MUTATING TABLE
CREATE OR REPLACE TRIGGER trig5_del_tema_rs 
    FOR DELETE ON dept_test_rs    
    COMPOUND TRIGGER
        TYPE tab_idx IS TABLE OF NUMBER INDEX BY PLS_INTEGER;    
        tabelO tab_idx;
    AFTER EACH ROW IS
    BEGIN
        tabelO(tabelO.COUNT + 1) := :OLD.department_id; 
    END AFTER EACH ROW;
    AFTER STATEMENT IS      
    BEGIN   
        FOR i IN tabelO.FIRST..tabelO.LAST LOOP                                      
            DELETE FROM emp_test_rs     
            WHERE department_id = tabelO(i);       
        END LOOP;  
    END AFTER STATEMENT;   
END; 
/

CREATE OR REPLACE TRIGGER trig5_tema_rs
    AFTER UPDATE OF department_id ON dept_test_rs
    FOR EACH ROW
BEGIN
    UPDATE emp_test_rs
    SET department_id = :NEW.department_id
    WHERE department_id = :OLD.department_id;
END;
/

DELETE FROM dept_test_rs
WHERE department_id = 90;
--sterge din ambele tabele

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 90;
--updateaza in ambele tabele

--CAZUL 4    CU CONSTRANGERE DE CHEIE EXTERNA ON DELETE SET NULL
ALTER TABLE emp_test_rs 
ADD CONSTRAINT EMP_TEST_DEPT_FK FOREIGN KEY(department_id)
    REFERENCES dept_test_rs(department_id) ON DELETE SET NULL;
   
DELETE FROM dept_test_rs
WHERE department_id = 90;
--  Error report -
--  ORA-04091: table GRUPA232.DEPT_TEST_RS is mutating, trigger/function may not see it
--  ORA-06512: at "GRUPA232.TRIG5_TEMA_RS", line 3
--  ORA-04088: error during execution of trigger 'GRUPA232.TRIG5_TEMA_RS'

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 90;
--updateaza in ambele tabele

--REZOLVARE EROARE MUTATING TABLE
CREATE OR REPLACE TRIGGER trig5_del_tema_rs 
    FOR DELETE ON dept_test_rs    
    COMPOUND TRIGGER
        TYPE tab_idx IS TABLE OF NUMBER INDEX BY PLS_INTEGER;    
        tabelO tab_idx;
    AFTER EACH ROW IS
    BEGIN
        tabelO(tabelO.COUNT + 1) := :OLD.department_id; 
    END AFTER EACH ROW;
    AFTER STATEMENT IS      
    BEGIN   
        FOR i IN tabelO.FIRST..tabelO.LAST LOOP                                      
            DELETE FROM emp_test_rs     
            WHERE department_id is null;       
        END LOOP;  
    END AFTER STATEMENT;   
END; 
/

CREATE OR REPLACE TRIGGER trig5_tema_rs
    AFTER UPDATE OF department_id ON dept_test_rs
    FOR EACH ROW
BEGIN
    UPDATE emp_test_rs
    SET department_id = :NEW.department_id
    WHERE department_id = :OLD.department_id;
END;
/

DELETE FROM dept_test_rs
WHERE department_id = 90;
--sterge din ambele tabele

UPDATE dept_test_rs
SET department_id = 999
WHERE department_id = 80;
--updateaza in ambele tabele   
 
SELECT * FROM emp_test_rs;
SELECT * FROM dept_test_rs;

DELETE FROM emp_test_rs;
DELETE FROM dept_test_rs;

DROP TABLE emp_test_rs;
DROP TABLE dept_test_rs;
DROP TRIGGER trig5_tema_rs;
DROP TRIGGER trig5_del_tema_rs;

--6. a. Crea?i un tabel cu urm?toarele coloane: 
--- user_id (SYS.LOGIN_USER);
--- nume_bd (SYS.DATABASE_NAME);
--- erori (DBMS_UTILITY.FORMAT_ERROR_STACK);
--- data. 
--b. Defini?i un declan?ator sistem (la nivel de baz? de date) care s? introduc? date în acest tabel 
--referitoare la erorile ap?rute
CREATE TABLE erori_rs
    (user_id VARCHAR2(30),
     nume_bd VARCHAR2(50),
     erori VARCHAR(50),
     data DATE);
  
CREATE OR REPLACE TRIGGER trig6_tema_rs
    AFTER SERVERERROR ON SCHEMA
BEGIN
    INSERT INTO erori_rs
    VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK, SYSDATE);
END;
/  
     
CREATE OR REPLACE TRIGGER trig6_tema_rs
    AFTER SERVERERROR ON DATABASE
BEGIN
    INSERT INTO erori_rs
    VALUES(SYS.LOGIN_USER, SYS.DATABASE_NAME, DBMS_UTILITY.FORMAT_ERROR_STACK, SYSDATE);
END;
/
--nu am privilegii sa creez la nivel de baza de date


DROP TRIGGER trig6_tema_rs;
DROP TRIGGER trig5_tema_rs;
DROP TRIGGER trig5_del_tema_rs;
DROP TRIGGER trig4_tema_rs;
DROP TRIGGER trig3_tema_rs;
DROP TRIGGER trig1_tema_rs;
DROP TABLE erori_rs;
DROP TABLE emp_test_rs;
DROP TABLE dept_test_rs;