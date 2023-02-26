--1.

CREATE TABLE error_rs
(cod    NUMBER,
 mesaj  VARCHAR2(100));

DECLARE
    variabila NUMBER := &p_var;
    v_cod NUMBER;
    v_mesaj VARCHAR2(100);
    exc_neg EXCEPTION;
BEGIN
    IF variabila < 0 THEN 
        RAISE exc_neg;
    ELSE
        variabila := SQRT(variabila);
        dbms_output.put_line('Radicalul este ' || variabila);
    END IF;
EXCEPTION
    WHEN exc_neg THEN
        v_cod := -20001;
        v_mesaj := 'variabila = ' || variabila || ' cere o extragere a radicalului dintr-un numar negativ';
        INSERT INTO error_rs
        VALUES (v_cod, v_mesaj);
END;
/

SELECT * FROM error_rs;

--2.
DECLARE
    sal NUMBER := &p_sal;
    cnt NUMBER;
    nume VARCHAR(60);
    exc_ndf EXCEPTION;
    exc_tmr EXCEPTION;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM employees
    WHERE salary = sal;
    IF cnt = 0 THEN 
        RAISE exc_ndf;
    ELSIF cnt > 1 THEN
        RAISE exc_tmr;
    ELSE
        SELECT last_name || ' ' || first_name INTO nume
        FROM employees
        WHERE salary = sal;
        dbms_output.put_line('Angajatul este ' || nume);
    END IF;
EXCEPTION
    WHEN exc_ndf THEN
        dbms_output.put_line('Nu exista niciun salariat care sa castige salariul ' || sal);
    WHEN exc_tmr THEN
        dbms_output.put_line('Exista mai multi salariati care castiga salariul ' || sal);
END;
/
--Nu exista niciun salariat care sa castige salariul 300
--Nu exista niciun salariat care sa castige salariul 3000
--Nu exista niciun salariat care sa castige salariul 5000
--Exista mai multi salariati care castiga salariul 6000
--Angajatul este Sarchand Nandita (sal = 4410)

--3.
ALTER TABLE dept_rs
ADD CONSTRAINT c_pr_rs PRIMARY KEY(department_id);

ALTER TABLE emp_rs
ADD CONSTRAINT c_ex_rs FOREIGN KEY (department_id) REFERENCES dept_rs;

UPDATE dept_rs
SET department_id = 10
WHERE department_id = 80;

DECLARE
    cod_v NUMBER := &p_codv;
    cod_n NUMBER := &p_codn;
    exceptie EXCEPTION;
    PRAGMA EXCEPTION_INIT(exceptie, -00001);
BEGIN
    UPDATE dept_rs
    SET department_id = cod_n
    WHERE department_id = cod_v;
EXCEPTION
    WHEN exceptie THEN
        dbms_output.put_line('Nu puteti modifica id-ul unui departament in care lucreaza angajati');
END;
/
--new:DECLARE
--    cod_v NUMBER := 80;
--    cod_n NUMBER := 10;
--Nu puteti modifica id-ul unui departament in care lucreaza angajati

--4.
DECLARE
    lim_inf NUMBER := &p_lim_inf;
    lim_sup NUMBER := &p_lim_sup;
    exceptie EXCEPTION;
    cnt NUMBER;
    nume departments.department_name%TYPE;
BEGIN
    SELECT COUNT(department_id) INTO cnt
    FROM employees
    WHERE department_id = 10;
    IF cnt < lim_inf OR cnt > lim_sup THEN
        RAISE exceptie;
    ELSE
        SELECT department_name INTO nume
        FROM departments
        WHERE department_id = 10;
        
        dbms_output.put_line('Numele departamentului ' ||  UPPER(nume));
    END IF;
EXCEPTION
    WHEN exceptie THEN
        dbms_output.put_line('Numarul de angajati nu se afla in intervalul specificat');
END;
/
--new:DECLARE
--    lim_inf NUMBER := 1;
--    lim_sup NUMBER := 2;
--Numele departamentului ADMINISTRATION

--new:DECLARE
--    lim_inf NUMBER := 4;
--    lim_sup NUMBER := 8;
--Numarul de angajati nu se afla in intervalul specificat

--5.
DECLARE
    nume_nou VARCHAR(25) := '&p_nume';
    cod NUMBER := &p_cod;
    exceptie EXCEPTION;
    cnt NUMBER;
    nume departments.department_name%TYPE;
BEGIN
    SELECT COUNT(*) INTO cnt
    FROM departments
    WHERE department_id = cod;
    IF cnt = 0 THEN
        RAISE exceptie;
    ELSE
        UPDATE dept_rs
        SET department_name = UPPER(nume_nou)
        WHERE department_id = cod;
        
        dbms_output.put_line('Randuri afectate ' ||  SQL%ROWCOUNT);
    END IF;
EXCEPTION
    WHEN exceptie THEN
        dbms_output.put_line('Departamentul specificat nu exista');
END;
/
--new:DECLARE
--    nume_nou VARCHAR(25) := 'CEVA';
--    cod NUMBER := 10;
--Randuri afectate 1

--new:DECLARE
--    nume_nou VARCHAR(25) := 'ceva';
--    cod NUMBER := 2;
--Departamentul specificat nu exista

--6.
--Varianta 1 � fiecare comanda are un numar de ordine
DECLARE
    v_loc locations.location_id%TYPE := &p_cod_loc;
    v_dep departments.department_id%TYPE := &p_cod_dep;
    nume departments.department_name%TYPE;
    v_ind1 NUMBER := 1;
    v_ind2 NUMBER := 1;
BEGIN  
    SELECT department_name
    INTO   nume
    FROM   departments
    WHERE  location_id = v_loc;
    dbms_output.put_line(nume);

    v_ind1 := 2;
    v_ind2 := 2;
    SELECT department_name
    INTO   nume
    FROM   departments
    WHERE  department_id = v_dep;
    dbms_output.put_line(nume);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('comanda SELECT ' || v_ind1 || ' nu returneaza nicio linie');
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('comanda SELECT ' || v_ind2 || ' returneaza mai multe linii');
END;
/
--new:DECLARE
--    v_loc locations.location_id%TYPE := 1;
--    v_dep departments.department_id%TYPE := 10;
--comanda SELECT 1 nu returneaza nicio linie

--new:DECLARE
--    v_loc locations.location_id%TYPE := 1400;
--    v_dep departments.department_id%TYPE := 1;
--IT
--comanda SELECT 2 nu returneaza nicio linie

--Varianta 2 � fiecare comanda este inclusa intr-un subbloc

DECLARE
    v_loc locations.location_id%TYPE := &p_cod_loc;
    v_dep departments.department_id%TYPE := &p_cod_dep;
    nume departments.department_name%TYPE;
BEGIN  
    BEGIN
        SELECT department_name
        INTO   nume
        FROM   departments
        WHERE  location_id = v_loc;
        dbms_output.put_line(nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('comanda SELECT 1 nu returneaza nicio linie');
        WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('comanda SELECT 1  returneaza mai multe linii');
    END;

    BEGIN
        SELECT department_name
        INTO   nume
        FROM   departments
        WHERE  department_id = v_dep;
        dbms_output.put_line(nume);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            dbms_output.put_line('comanda SELECT2 nu returneaza nicio linie');
        WHEN TOO_MANY_ROWS THEN
            dbms_output.put_line('comanda SELECT 1  returneaza mai multe linii');
    END;
END;
/
--new:DECLARE
--    v_loc locations.location_id%TYPE := 1;
--    v_dep departments.department_id%TYPE := 100;
--comanda SELECT 1 nu returneaza nicio linie
--Finance

--new:DECLARE
--    v_loc locations.location_id%TYPE := 1400;
--    v_dep departments.department_id%TYPE := 1;
--IT
--comanda SELECT2 nu returneaza nicio linie