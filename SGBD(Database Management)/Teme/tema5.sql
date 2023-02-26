--1.Mentineti intr-o colectie codurile celor mai prost platiti 5 angajati care nu castiga comision.
--Folosind aceasta colectie mariti cu 5% salariul acestor angajati. Afisati valoarea veche a salariului, 
--respectiv valoarea noua a salariului.
--Rincu Stefania
CREATE TABLE emp_aux_rs AS SELECT * FROM employees WHERE commission_pct IS NULL ORDER BY salary;
DECLARE
    TYPE vector IS VARRAY(5) OF employees.employee_id%TYPE;
    v vector := vector();
    salariu employees.salary%TYPE;
    salariu_nou NUMBER;
BEGIN
    SELECT employee_id 
    BULK COLLECT INTO v
    FROM (SELECT * FROM employees WHERE commission_pct IS NULL ORDER BY salary)
    WHERE rownum <= 5;
    
    FOR i IN 1..5 LOOP
        SELECT salary INTO salariu
        FROM employees
        WHERE employee_id = v(i);
        salariu_nou := salariu * 0.05;
        salariu_nou := salariu_nou + salariu;
        dbms_output.put_line('Angajatul cu codul ' || v(i) || ' ce avea un salariu de ' || salariu 
                            || ' lei, primeste acum un salariu de ' ||  salariu_nou || ' lei.');
    END LOOP;
END;
/
DROP TABLE emp_aux_rs;

--2.Definiti un tip colectie denumit tip_orase_***. Creati tabelul excursie_*** cu urmatoarea structura: 
--cod_excursie NUMBER(4), denumire VARCHAR2(20), orase tip_orase_*** (ce va contine lista oraselor care se 
--viziteaza intr-o excursie, intr-o ordine stabilita; de exemplu, primul oras din lista va fi primul oras vizitat),
--status(disponibila sau anulata). 
--a.Inserati 5 inregistrari in tabel. 
--b.Actualizati coloana orase pentru o excursie specificat?a: 
    --I.adaugati un oras nou in lista, ce va fi ultimul vizitat in excursia respectiva;
    --II.adaugati un ora? nou in lista, ce va fi al doilea oras vizitat in excursia respectiva;
    --III.inversati ordinea de vizitare a doua dintre orase al caror nume este specificat;
    --IV.eliminati din lista un oras al carui nume este specificat.
--c.Pentru o excursie al carui cod este dat, afisati numarul de orase vizitate, respectiv numele oraselor.
--d.Pentru fiecare excursie afisati lista oraselor vizitate.
--e.Anulati excursiile cu cele mai putine orase vizitate.

CREATE OR REPLACE TYPE tip_orase_rs IS TABLE OF VARCHAR2(20);
/
CREATE TABLE excursie_rs(
    cod_excursie NUMBER(4) PRIMARY KEY,
    denumire VARCHAR2(20),
    orase tip_orase_rs ,
    status VARCHAR2(20))NESTED TABLE orase STORE AS tabel_orase_rs;
--a
INSERT INTO excursie_rs VALUES(1, 'Moldo Trans', tip_orase_rs('Buzau', 'Focsani', 'Bacau', 'Iasi', 'Suceava'), 'Disponibila');
INSERT INTO excursie_rs VALUES(2, 'Nera Tour', tip_orase_rs('Oravita', 'Caransebes', 'Deva'), 'Disponibila');
INSERT INTO excursie_rs VALUES(3, 'Litoralul', tip_orase_rs('Vama Veche', 'Costinesti', 'Eforie Nord', 'Constanta', 'Navodari', 'Corbu'), 'Disponibila');
INSERT INTO excursie_rs VALUES(4, 'Contele Dracula', tip_orase_rs('Bran', 'Rasnov', 'Brasov'), 'Disponibila');
INSERT INTO excursie_rs VALUES(5, 'SasMobil', tip_orase_rs('Sibiu', 'Medias', 'Sighisoara', 'Alba Iulia'), 'Disponibila');
SELECT * FROM excursie_rs;
--b
--Rincu Stefania
DECLARE
    nume excursie_rs.denumire%TYPE := 'Moldo Trans';
    orase_temp excursie_rs.orase%TYPE;
    nume1 VARCHAR2(20) := 'Bacau';
    nume2 VARCHAR2(20) := 'Suceava';
    nume3 VARCHAR2(20) := 'Focsani';
    aux VARCHAR2(20);
    poz1 NUMBER;
    poz2 NUMBER;
    poz3 NUMBER;
    j NUMBER;
BEGIN
    SELECT orase INTO orase_temp
    FROM excursie_rs
    WHERE lower(denumire) like lower(nume);
    
    --I.
    orase_temp.EXTEND;
    orase_temp(orase_temp.LAST) := 'Botosani';
    
    --II.
    orase_temp.EXTEND;
    j := orase_temp.LAST - 1;
    WHILE j >= 2 LOOP
        orase_temp(j + 1) := orase_temp(j);
        j := j - 1;
    END LOOP;
    orase_temp(2) := 'Ramnicu Sarat';
    
    --III.
    FOR i IN orase_temp.FIRST..orase_temp.LAST LOOP
        IF lower(orase_temp(i)) LIKE lower(nume1) THEN
            poz1 := i;
        END IF;
        IF lower(orase_temp(i)) LIKE lower(nume2) THEN
            poz2 := i;
        END IF;
    END LOOP;
    aux := orase_temp(poz1);
    orase_temp(poz1) := orase_temp(poz2);
    orase_temp(poz2) := aux;
    
    --IV.
    FOR i IN orase_temp.FIRST..orase_temp.LAST LOOP
        IF lower(orase_temp(i)) LIKE lower(nume3) THEN
            poz3 := i;
        END IF;
    END LOOP;
    
    WHILE poz3 < orase_temp.LAST LOOP
        orase_temp(poz3) := orase_temp(poz3 + 1);
        poz3 := poz3 + 1;
    END LOOP;
    orase_temp.TRIM;
    
    --ACTUALIZARE
    UPDATE excursie_rs
    SET orase = orase_temp
    WHERE lower(denumire) like lower(nume);
END;
/
SELECT * FROM excursie_rs;
ROLLBACK;

--c
DECLARE
    cod excursie_rs.cod_excursie%TYPE := &cod_exc;
    orase_temp excursie_rs.orase%TYPE;
BEGIN
    SELECT orase INTO orase_temp
    FROM excursie_rs
    WHERE cod_excursie = cod;
    
    dbms_output.put_line('Excursia are ca scop vizitarea a ' || orase_temp.COUNT || ' orase.');
    dbms_output.put('Acestea sunt: ');
    dbms_output.put(orase_temp(1));
    FOR i IN orase_temp.FIRST+1..orase_temp.LAST LOOP
        dbms_output.put(', ' || orase_temp(i));
    END LOOP;
    dbms_output.new_line();
END;
/
--Rincu Stefania
--d
DECLARE
    TYPE t_orase IS TABLE OF excursie_rs.orase%TYPE;
    v_orase t_orase := t_orase();
BEGIN
    SELECT orase BULK COLLECT INTO v_orase
    FROM excursie_rs;
    
    FOR i IN v_orase.FIRST..v_orase.LAST LOOP
        dbms_output.put('Orasele vizitate in excursia ' || i || ' sunt: ');
        dbms_output.put(v_orase(i)(1));
        FOR j IN v_orase(i).FIRST + 1..v_orase(i).LAST LOOP
            dbms_output.put(', ' || v_orase(i)(j));
        END LOOP;   
        dbms_output.new_line();
    END LOOP;
END;
/

--e
DECLARE
    TYPE v_minime IS TABLE OF NUMBER;
    minime v_minime := v_minime();
    mini NUMBER;
BEGIN
    SELECT CARDINALITY(orase) BULK COLLECT INTO minime
    FROM excursie_rs;
    
    mini := minime(minime.FIRST);
    FOR i IN minime.FIRST + 1..minime.LAST LOOP
        IF minime(i) < mini THEN
            mini := minime(i);
        END IF;
    END LOOP;
    
    UPDATE excursie_rs
    SET status = 'Anulata'
    WHERE CARDINALITY(orase) = mini;
END;
/
SELECT * FROM excursie_rs;
ROLLBACK;

DROP TABLE excursie_rs;
DROP TYPE tip_orase_rs;

--3.Rezolvati problema anterioara folosind un alt tip de colectie studiat.

CREATE OR REPLACE TYPE tip_orase_rs IS VARRAY(200) OF VARCHAR2(20);
CREATE TABLE excursie_rs(
    cod_excursie NUMBER(4) PRIMARY KEY,
    denumire VARCHAR2(20),
    orase tip_orase_rs ,
    status VARCHAR2(20));
    
--a
INSERT INTO excursie_rs VALUES(1, 'Moldo Trans', tip_orase_rs('Buzau', 'Focsani', 'Bacau', 'Iasi', 'Suceava'), 'Disponibila');
INSERT INTO excursie_rs VALUES(2, 'Nera Tour', tip_orase_rs('Oravita', 'Caransebes', 'Deva'), 'Disponibila');
INSERT INTO excursie_rs VALUES(3, 'Litoralul', tip_orase_rs('Vama Veche', 'Costinesti', 'Eforie Nord', 'Constanta', 'Navodari', 'Corbu'), 'Disponibila');
INSERT INTO excursie_rs VALUES(4, 'Contele Dracula', tip_orase_rs('Bran', 'Rasnov', 'Brasov'), 'Disponibila');
INSERT INTO excursie_rs VALUES(5, 'SasMobil', tip_orase_rs('Sibiu', 'Medias', 'Sighisoara', 'Alba Iulia'), 'Disponibila');
SELECT * FROM excursie_rs;
--b
DECLARE
    nume excursie_rs.denumire%TYPE := 'Moldo Trans';
    orase_temp excursie_rs.orase%TYPE;
    nume1 VARCHAR2(20) := 'Bacau';
    nume2 VARCHAR2(20) := 'Suceava';
    nume3 VARCHAR2(20) := 'Focsani';
    aux VARCHAR2(20);
    poz1 NUMBER;
    poz2 NUMBER;
    poz3 NUMBER;
    j NUMBER;
BEGIN
    SELECT orase INTO orase_temp
    FROM excursie_rs
    WHERE lower(denumire) like lower(nume);
    
    --I.
    orase_temp.EXTEND;
    orase_temp(orase_temp.LAST) := 'Botosani';
    
    --II.
    orase_temp.EXTEND;
    j := orase_temp.LAST - 1;
    WHILE j >= 2 LOOP
        orase_temp(j + 1) := orase_temp(j);
        j := j - 1;
    END LOOP;
    orase_temp(2) := 'Ramnicu Sarat';
    
    --III.
    FOR i IN orase_temp.FIRST..orase_temp.LAST LOOP
        IF lower(orase_temp(i)) LIKE lower(nume1) THEN
            poz1 := i;
        END IF;
        IF lower(orase_temp(i)) LIKE lower(nume2) THEN
            poz2 := i;
        END IF;
    END LOOP;
    aux := orase_temp(poz1);
    orase_temp(poz1) := orase_temp(poz2);
    orase_temp(poz2) := aux;
    
    --IV.
    FOR i IN orase_temp.FIRST..orase_temp.LAST LOOP
        IF lower(orase_temp(i)) LIKE lower(nume3) THEN
            poz3 := i;
        END IF;
    END LOOP;
    
    WHILE poz3 < orase_temp.LAST LOOP
        orase_temp(poz3) := orase_temp(poz3 + 1);
        poz3 := poz3 + 1;
    END LOOP;
    orase_temp.TRIM;
    
    --ACTUALIZARE
    UPDATE excursie_rs
    SET orase = orase_temp
    WHERE lower(denumire) like lower(nume);
END;
/
SELECT * FROM excursie_rs;
ROLLBACK;

--c
DECLARE
    cod excursie_rs.cod_excursie%TYPE := &cod_exc;
    orase_temp excursie_rs.orase%TYPE;
BEGIN
    SELECT orase INTO orase_temp
    FROM excursie_rs
    WHERE cod_excursie = cod;
    
    dbms_output.put_line('Excursia are ca scop vizitarea a ' || orase_temp.COUNT || ' orase.');
    dbms_output.put('Acestea sunt: ');
    dbms_output.put(orase_temp(1));
    FOR i IN orase_temp.FIRST+1..orase_temp.LAST LOOP
        dbms_output.put(', ' || orase_temp(i));
    END LOOP;
    dbms_output.new_line();
END;
/

--d
DECLARE
    TYPE t_orase IS VARRAY(200) OF excursie_rs.orase%TYPE;
    v_orase t_orase := t_orase();
BEGIN
    SELECT orase BULK COLLECT INTO v_orase
    FROM excursie_rs;
    
    FOR i IN v_orase.FIRST..v_orase.LAST LOOP
        dbms_output.put('Orasele vizitate in excursia ' || i || ' sunt: ');
        dbms_output.put(v_orase(i)(1));
        FOR j IN v_orase(i).FIRST + 1..v_orase(i).LAST LOOP
            dbms_output.put(', ' || v_orase(i)(j));
        END LOOP;   
        dbms_output.new_line();
    END LOOP;
END;
/

--e
DECLARE
    TYPE v_ind IS VARRAY(200) OF NUMBER;
    indici v_ind := v_ind();
    TYPE v_orase IS VARRAY(200) OF excursie_rs.orase%TYPE;
    orase_temp v_orase := v_orase();
    TYPE v_cod IS VARRAY(200) OF excursie_rs.cod_excursie%TYPE;
    coduri v_cod := v_cod();
    mini NUMBER;
    k NUMBER := 1;
BEGIN
    SELECT cod_excursie, orase BULK COLLECT INTO coduri, orase_temp
    FROM excursie_rs;
    
    mini := orase_temp(orase_temp.FIRST).COUNT;
    indici.EXTEND;
    indici(k) := coduri(1);
    FOR i IN orase_temp.FIRST + 1..orase_temp.LAST LOOP
        IF orase_temp(i).COUNT < mini THEN
            mini := orase_temp(i).COUNT;
            indici.TRIM(indici.COUNT);
            k := 0;
        END IF;
        IF orase_temp(i).COUNT = mini THEN
            indici.EXTEND;
            k := k + 1;
            indici(k) := coduri(i);
        END IF;
    END LOOP;
    
    FORALL i IN indici.FIRST..indici.LAST
        UPDATE excursie_rs
        SET status = 'Anulata'
        WHERE cod_excursie = indici(i);
END;
/
SELECT * FROM excursie_rs;
ROLLBACK;

DROP TABLE excursie_rs;
DROP TYPE tip_orase_rs;