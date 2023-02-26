--1.Crea?i tabelul info_*** cu urm?toarele coloane:
---utilizator (numele utilizatorului care a ini?iat o comand?) 
---data (data ?i timpul la care utilizatorul a ini?iat comanda)
---comanda (comanda care a fost ini?iat? de utilizatorul respectiv)
---nr_linii (num?rul de linii selectate/modificate de comand?)
---eroare (un mesaj pentru excep?ii).
CREATE TABLE info_rs
    (utilizator VARCHAR2(100),
     data DATE,
     comanda VARCHAR2(100),
     nr_linii NUMBER,
     eroare VARCHAR2(200));

--2.Modifica?i func?ia definit? la exerci?iul 2, respectiv procedura definit? la exerci?iul 4 astfel 
--încât s? determine inserarea în tabelul info_*** a informa?iilor corespunz?toare fiec?rui caz determinat
--de valoarea dat? pentru parametru:
---exist? un singur angajat cu numele specificat;
---exist? mai mul?i angaja?i cu numele specificat;
---nu exist? angaja?i cu numele specificat. 

--modificare functie exercitiul 2
CREATE OR REPLACE FUNCTION f2_modif_rs(nume_ang employees.last_name%TYPE)
RETURN employees.salary%TYPE IS
    f_salariu employees.salary%TYPE;
    f_utiliz VARCHAR2(100);
    f_data DATE;
    f_comanda VARCHAR2(100) := 'SELECT salary INTO f_salariu';
    f_nr_linii NUMBER := 0;
    f_err VARCHAR2(200) := 'exista un singur angajat cu numele ' || nume_ang;
BEGIN
    SELECT user, sysdate INTO f_utiliz, f_data
    FROM dual;
    
    SELECT COUNT(*) INTO f_nr_linii
    FROM employees
    WHERE lower(last_name) = lower(nume_ang);
    
    SELECT salary INTO f_salariu
    FROM employees
    WHERE lower(last_name) = lower(nume_ang);

    f_comanda := 'SELECT COUNT(*) INTO f_nr_linii';
    INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
       
    RETURN f_salariu;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        f_err := 'nu exista angajati cu numele ' || nume_ang;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
        RETURN -1;
        --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele specificat ' || nume_ang);
    WHEN TOO_MANY_ROWS THEN 
        f_err := 'exista mai multi angajati cu numele ' || nume_ang;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
        RETURN -1;
        --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele specificat ' || nume_ang);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END f2_modif_rs;
/
VAR s NUMBER
EXECUTE :s := f2_modif_rs('Bell');
EXECUTE :s := f2_modif_rs('King');
EXECUTE :s := f2_modif_rs('Cambrault');
EXECUTE :s := f2_modif_rs('Stefania');

SELECT * FROM info_rs;
ROLLBACK;

--modificare procedura exercitiul 4
CREATE OR REPLACE PROCEDURE p4_modif_rs(nume_ang employees.last_name%TYPE,
                                        p_salariu OUT employees.salary%TYPE)
IS
    p_utiliz VARCHAR2(100);
    p_data DATE;
    p_comanda VARCHAR2(100) := 'SELECT salary INTO p_salariu';
    p_nr_linii NUMBER := 0;
    p_err VARCHAR2(200) := 'exista un singur angajat cu numele ' || nume_ang;
BEGIN
    SELECT user, sysdate INTO p_utiliz, p_data
    FROM dual;

    SELECT COUNT(*) INTO p_nr_linii
    FROM employees
    WHERE lower(last_name) = lower(nume_ang);

    SELECT salary INTO p_salariu
    FROM employees
    WHERE last_name = nume_ang;
    
    p_comanda := 'SELECT COUNT(*) INTO p_nr_linii';
    INSERT INTO info_rs VALUES(p_utiliz, p_data, p_comanda, p_nr_linii, p_err);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_err := 'nu exista angajati cu numele ' || nume_ang;
        INSERT INTO info_rs VALUES(p_utiliz, p_data, p_comanda, p_nr_linii, p_err);
        --RAISE_APPLICATION_ERROR(-20000, 'Nu exista angajati cu numele specificat ' || nume_ang);
    WHEN TOO_MANY_ROWS THEN 
        p_err := 'exista mai multi angajati cu numele ' || nume_ang;
        INSERT INTO info_rs VALUES(p_utiliz, p_data, p_comanda, p_nr_linii, p_err);
        --RAISE_APPLICATION_ERROR(-20001, 'Exista mai multi angajati cu numele specificat ' || nume_ang);
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END p4_modif_rs;
/

VAR x NUMBER
EXECUTE p4_modif_rs('Bell', :x);
EXECUTE p4_modif_rs('King', :x);
EXECUTE p4_modif_rs('Cambrault', :x);
EXECUTE p4_modif_rs('Stefania', :x);

--3.Defini?i o func?ie stocat? care determin? num?rul de angaja?i care au avut cel pu?in 2 joburi diferite
--?i care în prezent lucreaz? într-un ora? dat ca parametru. Trata?i cazul în care ora?ul dat ca parametru
--nu exist?, respectiv cazul în care în ora?ul dat nu lucreaz? niciun angajat. Insera?i în tabelul 
--info_***informa?iile corespunz?toare fiec?rui caz determinat de valoarea dat? pentru parametru. 
CREATE OR REPLACE FUNCTION f3_tema_rs(oras locations.city%TYPE)
RETURN NUMBER IS
    f_utiliz VARCHAR2(100);
    f_data DATE;
    f_comanda VARCHAR2(100) := 'SELECT';
    f_nr_linii NUMBER := 0;
    f_err VARCHAR2(200);
BEGIN
    SELECT user, sysdate INTO f_utiliz, f_data
    FROM dual;

    SELECT COUNT(*) INTO f_nr_linii
    FROM locations
    WHERE lower(city) = lower(oras);
    
    IF f_nr_linii = 0 THEN
        f_err := 'nu exista orasul ' || oras;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
        RETURN -1;
    END IF;
    
    SELECT COUNT(*) INTO f_nr_linii
    FROM employees e, departments d, locations l
    WHERE e.department_id = d.department_id AND 
          d.location_id = l.location_id AND 
          lower(l.city) = lower(oras);
    
    IF f_nr_linii = 0 THEN
        f_err := 'nu exista niciun angajat in orasul ' || oras;
        f_comanda := 'SELECT COUNT(*) + JOIN 3 tabele => nr angajati din orasul ' || oras;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
        RETURN f_nr_linii;
    END IF;
    
    SELECT COUNT(employee_id) INTO f_nr_linii 
    FROM employees e
    WHERE department_id IN (SELECT department_id 
                            FROM departments 
                            WHERE location_id IN (SELECT location_id 
                                                  FROM locations 
                                                  WHERE lower(city) = lower(oras)))
            AND (SELECT COUNT(DISTINCT job_id) 
                 FROM job_history jh 
                 WHERE jh.employee_id = e.employee_id) > 1;
    
    IF f_nr_linii = 0 THEN
        f_err := 'nu exista niciun angajat cu cel putin 2 joburi care sa lucreze in orasul ' || oras;
        f_comanda := 'SELECT COUNT(*) + JOIN 4 tabele => nr angajati cu cel putin 2 joburi din orasul ' || oras;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
    ELSE
        f_err := 'SUCCES';
        f_comanda := 'SELECT COUNT(*) + JOIN 4 tabele => nr angajati cu cel putin 2 joburi din orasul ' || oras;
        INSERT INTO info_rs VALUES(f_utiliz, f_data, f_comanda, f_nr_linii, f_err);
    END IF;
    
    RETURN f_nr_linii;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END f3_tema_rs;
/
VAR na NUMBER
EXECUTE :na := f3_tema_rs('Seattle');
EXECUTE :na := f3_tema_rs('OxFord');
EXECUTE :na := f3_tema_rs('tOrOntO');
EXECUTE :na := f3_tema_rs('BucurEsti');
EXECUTE :na := f3_tema_rs('Roma');

SELECT * FROM info_rs;
ROLLBACK;

--4.Defini?i o procedur? stocat? care m?re?te cu 10% salariile tuturor angaja?ilor condu?i direct sau 
--indirect de c?tre un manager al c?rui cod este dat ca parametru. Trata?i cazul în care nu exist? niciun
--manager cu codul dat. Insera?i în tabelul info_***informa?iile corespunz?toare fiec?rui caz determinat 
--de valoarea dat? pentru parametru.
CREATE OR REPLACE PROCEDURE p4_tema_rs(p_cod employees.employee_id%TYPE)
IS
    p_nr_linii NUMBER := 0;
    p_var NUMBER;
BEGIN
    SELECT COUNT(*) INTO p_var
    FROM employees
    WHERE manager_id = p_cod;
    
    IF p_var = 0 THEN
        INSERT INTO info_rs VALUES(user, sysdate, 'SELECT COUNT(*)', 0, 'Nu exista niciun manager care sa aiba codul ' || p_cod);
    ELSE
        UPDATE emp_rs
        SET salary = salary * 1.1
        WHERE manager_id IN (SELECT employee_id
                             FROM employees
                             START WITH manager_id = p_cod
                             CONNECT BY PRIOR employee_id = manager_id);
        p_nr_linii := SQL%ROWCOUNT; 
        INSERT INTO info_rs VALUES(user, sysdate, 'UPDATE' , p_nr_linii, 'SUCCES');
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE_APPLICATION_ERROR(-20002, 'Alta eroare');
END p4_tema_rs;
/

EXECUTE p4_tema_rs(101);
EXECUTE p4_tema_rs(189);
EXECUTE p4_tema_rs(149);
EXECUTE p4_tema_rs(122);
EXECUTE p4_tema_rs(132);

--5.Defini?i un subprogram care ob?ine pentru fiecare nume de departament ziua din s?pt?mân? în care au 
--fost angajate cele mai multe persoane, lista cu numele acestora, vechimea ?i venitul lor lunar. Afi?a?i
--mesaje corespunz?toare urm?toarelor cazuri:
---într-un departament nu lucreaz? niciun angajat;
---într-o zi din s?pt?mân? nu a fost nimeni angajat.
--Observa?ii: 
--a.Numele departamentului ?i ziua apar o singur? dat? în rezultat.
--b.Rezolva?i problema în dou? variante, dup? cum se ?ine cont sau nu de istoricul joburilor angaja?ilor.

--Varianta 1                   
CREATE OR REPLACE PROCEDURE p5_v1_rs
IS
    CURSOR c IS (SELECT department_name FROM departments);
    dep_name departments.department_name%TYPE;
    data_max DATE;
    p_var NUMBER;
BEGIN
    OPEN c;  
    LOOP
        FETCH c INTO dep_name;
        EXIT WHEN c%NOTFOUND;
        WITH aux AS (SELECT d.department_name nume, COUNT(jh.employee_id) nr
                 FROM job_history jh, departments d
                 WHERE jh.department_id(+) = d.department_id
                 GROUP BY d.department_name),
        aux2 AS (SELECT d2.department_name nume, COUNT(e.employee_id) nr
                 FROM employees e, departments d2
                 WHERE e.department_id(+) = d2.department_id
                 GROUP BY d2.department_name)
        SELECT a2.nr + a.nr INTO p_var
        FROM aux a, aux2 a2
        WHERE a.nume = a2.nume AND LOWER(a.nume) = LOWER(dep_name);
        
        IF p_var = 0 THEN
            dbms_output.put_line('Niciun angajat nu lucreaza sau a lucrat in departamentul ' || dep_name);
        ELSE
            FOR b IN (WITH aux AS (SELECT d.department_id id, TO_CHAR(jh.start_date, 'DAY') zi, COUNT(jh.employee_id) nr
                                   FROM job_history jh, departments d
                                   WHERE jh.department_id = d.department_id AND LOWER(d.department_name) = LOWER(dep_name)
                                   GROUP BY d.department_id, TO_CHAR(jh.start_date, 'DAY')),
                           aux2 AS (SELECT d2.department_id id, TO_CHAR(e.hire_date, 'DAY') zi, COUNT(e.employee_id) nr
                                    FROM employees e, departments d2
                                    WHERE e.department_id = d2.department_id AND LOWER(d2.department_name) = LOWER(dep_name)
                                    GROUP BY d2.department_id, TO_CHAR(e.hire_date, 'DAY')),
                           aux3 AS (SELECT a.id id, a.zi zi, nvl(a2.nr, 0) + a.nr suma
                                    FROM aux a, aux2 a2
                                    WHERE a.id = a2.id(+) AND a.zi = a2.zi(+)
                                    UNION
                                    SELECT a2.id id, a2.zi zi, nvl(a.nr, 0) + a2.nr suma
                                    FROM aux a, aux2 a2
                                    WHERE a.id(+) = a2.id AND a2.zi = a.zi(+))
                        SELECT a3.id dep_id, a3.zi zi, a3.suma nr_ang
                        FROM aux3 a3
                        WHERE suma = (SELECT MAX(suma)
                                      FROM aux3
                                      GROUP BY id
                                      HAVING id = a3.id))LOOP
                IF b.nr_ang = 1 THEN
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajare, iar angajatul fiind: ');
                ELSE
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajari, iar angajatii fiind: ');
                END IF;
                FOR a IN (SELECT first_name || ' ' || last_name nume, 
                                employee_id id, hire_date data,
                                salary + (salary * nvl(commission_pct, 0)) venit
                          FROM employees e
                          WHERE TO_CHAR(hire_date, 'DAY') = b.zi AND e.department_id = b.dep_id) LOOP
                    SELECT MAX(end_date) INTO data_max
                    FROM job_history
                    WHERE employee_id = a.id;
                    IF data_max IS NULL THEN
                        data_max := a.data;
                    END IF;
                    dbms_output.put_line('      Angajatul:   '  || a.nume || '       are vechimea:    ' || round(sysdate - data_max) || ' zile      si venitul:   ' || a.venit);
                END LOOP;
                FOR a IN (SELECT first_name || ' ' || last_name nume, 
                                 ROUND(end_date - start_date)vechime, 
                                 salary + (salary * nvl(commission_pct, 0)) venit
                          FROM employees e, job_history jh
                          WHERE TO_CHAR(start_date, 'DAY') = b.zi AND jh.department_id = b.dep_id AND jh.employee_id = e.employee_id) LOOP
                    dbms_output.put_line('  DEMISIONAT    Angajatul:   '  || a.nume || '       are vechimea:    ' || a.vechime || ' zile      si venitul:   ' || a.venit);
                END LOOP;
            END LOOP;
            dbms_output.new_line();
        END IF;
    END LOOP;
    CLOSE c;
END p5_v1_rs;
/

EXECUTE p5_v1_rs;

--Varianta 2                   
CREATE OR REPLACE PROCEDURE p5_v2_rs
IS
    CURSOR c IS (SELECT department_name FROM departments);
    dep_name departments.department_name%TYPE;
    p_var NUMBER;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO dep_name;
        EXIT WHEN c%NOTFOUND;
        SELECT COUNT(*) INTO p_var
        FROM employees e, departments d
        WHERE e.department_id = d.department_id AND LOWER(d.department_name) = LOWER(dep_name);
        
        IF p_var = 0 THEN
            dbms_output.put_line('Niciun angajat nu lucreaza in departamentul ' || dep_name);
        ELSE
            FOR b IN (SELECT e.department_id dep_id, TO_CHAR(e.hire_date, 'DAY') zi, COUNT(*) nr_ang 
                      FROM employees e, departments d
                      WHERE e.department_id = d.department_id AND LOWER(d.department_name) = LOWER(dep_name)
                      GROUP BY e.department_id, TO_CHAR(e.hire_date, 'DAY')
                      HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                         FROM employees e2
                                         GROUP BY e2.department_id, TO_CHAR(e2.hire_date, 'DAY')
                                         HAVING e2.department_id = e.department_id)) LOOP
                IF b.nr_ang = 1 THEN
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajare, iar angajatul fiind: ');
                ELSE
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajari, iar angajatii fiind: ');
                END IF;
                FOR a IN (SELECT first_name || ' ' || last_name nume, ROUND(sysdate - hire_date) vechime, 
                                salary + (salary * nvl(commission_pct, 0)) venit
                          FROM employees 
                          WHERE TO_CHAR(hire_date, 'DAY') = b.zi AND department_id = b.dep_id) LOOP
                    dbms_output.put_line('      Angajatul:   '  || a.nume || '       are vechimea:    ' || a.vechime || ' zile      si venitul:   ' || a.venit);
                END LOOP;
            END LOOP;
        dbms_output.new_line();
        END IF;
    END LOOP;
    CLOSE c;
END p5_v2_rs;
/

EXECUTE p5_v2_rs;

--6.Modifica?i exerci?iul anterior astfel încât lista cu numele angaja?ilor s? apar? într-un clasament creat 
--în func?ie de vechimea acestora în departament. Specifica?i num?rul pozi?iei din clasament ?i apoi lista
--angaja?ilor  care ocup? acel loc. Dac? doi angaja?i au aceea?i vechime, atunci ace?tia ocup? aceea?i 
--pozi?ie în clasament.
                
CREATE OR REPLACE PROCEDURE p6_v2_rs
IS
    CURSOR c IS (SELECT department_name FROM departments);
    dep_name departments.department_name%TYPE;
    p_var NUMBER;
    v_top NUMBER := 1;
    v_prec NUMBER := -1;
BEGIN
    OPEN c;
    LOOP
        FETCH c INTO dep_name;
        EXIT WHEN c%NOTFOUND;
        SELECT COUNT(*) INTO p_var
        FROM employees e, departments d
        WHERE e.department_id = d.department_id AND LOWER(d.department_name) = LOWER(dep_name);
        
        IF p_var = 0 THEN
            dbms_output.put_line('Niciun angajat nu lucreaza in departamentul ' || dep_name);
        ELSE
            FOR b IN (SELECT e.department_id dep_id, TO_CHAR(e.hire_date, 'DAY') zi, COUNT(*) nr_ang 
                      FROM employees e, departments d
                      WHERE e.department_id = d.department_id AND LOWER(d.department_name) = LOWER(dep_name)
                      GROUP BY e.department_id, TO_CHAR(e.hire_date, 'DAY')
                      HAVING COUNT(*) = (SELECT MAX(COUNT(*))
                                         FROM employees e2
                                         GROUP BY e2.department_id, TO_CHAR(e2.hire_date, 'DAY')
                                         HAVING e2.department_id = e.department_id)) LOOP
                IF b.nr_ang = 1 THEN
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajare, iar angajatul fiind: ');
                ELSE
                    dbms_output.put_line('In departamentul ' || dep_name || ' ziua cu cele mai multe angajari a fost ' || b.zi || ' cu ' || b.nr_ang || ' angajari, iar angajatii fiind: ');
                END IF;
                v_top := 1;
                v_prec := -1;
                FOR a IN (SELECT first_name || ' ' || last_name nume, ROUND(sysdate - hire_date) vechime, 
                                salary + (salary * nvl(commission_pct, 0)) venit
                          FROM employees 
                          WHERE TO_CHAR(hire_date, 'DAY') = b.zi AND department_id = b.dep_id) LOOP
                    v_prec := a.vechime;
                    EXIT WHEN v_prec != -1;
                END LOOP;
                FOR a IN (SELECT first_name || ' ' || last_name nume, ROUND(sysdate - hire_date) vechime, 
                                salary + (salary * nvl(commission_pct, 0)) venit
                          FROM employees 
                          WHERE TO_CHAR(hire_date, 'DAY') = b.zi AND department_id = b.dep_id) LOOP
                    IF v_prec != a.vechime THEN
                        v_top := v_top + 1;
                    END IF;
                    v_prec := a.vechime;
                    dbms_output.put_line(v_top || '      Angajatul:   '  || a.nume || '       are vechimea:    ' || a.vechime || ' zile      si venitul:   ' || a.venit);
                END LOOP;
            END LOOP;
        dbms_output.new_line();
        END IF;
    END LOOP;
    CLOSE c;
END p6_v2_rs;
/

EXECUTE p6_v2_rs;

DROP TABLE info_rs;
DROP PROCEDURE p6_v1_rs;
DROP PROCEDURE p6_v2_rs;
DROP PROCEDURE p5_v1_rs;
DROP PROCEDURE p5_v2_rs;
DROP PROCEDURE p4_tema_rs;
DROP FUNCTION f3_tema_rs;
DROP PROCEDURE p4_modif_rs;
DROP FUNCTION f2_modif_rs;
ROLLBACK;
