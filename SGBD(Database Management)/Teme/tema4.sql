--1. Se d? urm?torul bloc:
DECLARE
    numar number(3) := 100;
    mesaj1 varchar2(255) := 'text 1';
    mesaj2 varchar2(255) := 'text 2';
BEGIN
    DECLARE
        numar number(3) := 1;
        mesaj1 varchar2(255) := 'text 2';
        mesaj2 varchar2(255) := 'text 3';
    BEGIN
        numar := numar+1;
        mesaj2 := mesaj2 || ' adaugat in sub-bloc';
    END;
    numar := numar+1;
    mesaj1 := mesaj1 || ' adaugat un blocul principal';
    mesaj2 := mesaj2 || ' adaugat in blocul principal'; 
END;
/
--a)Valoarea variabilei numar în subbloc este: 2
--b)Valoarea variabilei mesaj1 în subbloc este: text 2
--c)Valoarea variabilei mesaj2 în subbloc este: text 3 adaugat in sub-bloc
--d)Valoarea variabilei numar în bloc este: 101
--e)Valoarea variabilei mesaj1 în bloc este: text 1 adaugat in blocul principal
--f)Valoarea variabilei mesaj2 în bloc este: text 2 adauat in blocul principal

--2.Se d? urm?torul enun?: 
--  Pentru fiecare zi a lunii octombrie(se vor lua în considerare ?i zilele din lun? în care nu 
--  au fost realizate împrumuturi) ob?ine?i num?rul de împrumuturi efectuate.
--a.Încerca?i s? rezolva?i problema în SQL f?r? a folosi structuri ajut?toare.
--b.Defini?i  tabelul octombrie_*** (id,  data).  Folosind  PL/SQL  popula?i  cu  date  acest  tabel. 
--Rezolva?i în SQL problema dat?.
--a.
with 
    aux as (select to_char(trunc(sysdate, 'mm') + level - 1, 'dd-mm-yyyy')as zi
            from dual
            connect by level <= extract(day from last_day(sysdate)))
select zi, (select count(*) from rental where to_char(book_date, 'dd-mm-yyyy') = zi) as nr_exemp
from aux;

--b
CREATE TABLE octombrie_rs(
    id NUMBER PRIMARY KEY,
    data DATE
);

DECLARE
    contor NUMBER := 1;
    v_data DATE := TO_DATE('01-10-2022','DD-MM-YYYY');
    maxim NUMBER := 31;
BEGIN
    LOOP
        INSERT INTO octombrie_rs
        VALUES(contor, v_data);
        v_data := v_data + 1;
        contor := contor + 1;
        EXIT WHEN contor > maxim;
    END LOOP;
END;
/
select * from octombrie_rs;

select data, (select count(*) from rental where to_char(book_date, 'dd-mm-yyyy') = to_char(data, 'dd-mm-yyyy')) as nr_exemp
from octombrie_rs;

--3.Defini?iun  bloc  anonim  în  care s? se determine num?rul de filme  (titluri)  împrumutate  de 
--un membru al c?rui nume este introdus de la tastatur?. Trata?i urm?toarele dou? situa?ii: 
--nu exist? nici un membru cu numele dat; exist? mai mul?i membrii cu acela?i nume.

DECLARE
    v_nume member.last_name%TYPE := '&p_nume';
    v_nr_carti NUMBER;
BEGIN
    SELECT COUNT(DISTINCT(r.title_id)) INTO v_nr_carti
    FROM rental r, member m
    WHERE LOWER(m.last_name) LIKE LOWER(v_nume)
         AND r.member_id(+) = m.member_id
    GROUP BY m.member_id;
    dbms_output.put_line('Membrul ' || upper(v_nume) || ' a imprumutat ' || v_nr_carti);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Sunt mai multi membrii cu acelasi nume!');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista acest membru!');
    WHEN OTHERS THEN 
      dbms_output.put_line('Error!'); 
END;
/

--4. Modifica?i problema anterioar? astfel încât s? afi?a?i ?i urm?torul text:
---Categoria 1 (a împrumutat mai mult de 75% din titlurile existente)
---Categoria 2 (a împrumutat mai mult de 50% din titlurile existente)
---Categoria 3 (a împrumutat mai mult de 25% din titlurile existente)
---Categoria 4 (altfel)

DECLARE
    v_nume member.last_name%TYPE := '&p_nume';
    v_nr_carti NUMBER;
    v_tot_carti NUMBER;
    v_categ VARCHAR(20);
BEGIN
    SELECT COUNT(*) INTO v_tot_carti
    FROM title;
    
    SELECT COUNT(DISTINCT(r.title_id)) INTO v_nr_carti
    FROM rental r, member m
    WHERE LOWER(m.last_name) LIKE LOWER(v_nume)
         AND r.member_id(+) = m.member_id
    GROUP BY m.member_id;
    
    CASE
    WHEN v_nr_carti >= (v_tot_carti * 75) / 100 THEN
        v_categ := 'Categoria 1';
    WHEN v_nr_carti >= (v_tot_carti * 50) / 100 THEN
        v_categ := 'Categoria 2';
    WHEN v_nr_carti >= (v_tot_carti * 25) / 100 THEN
        v_categ := 'Categoria 3';
    ELSE v_categ := 'Categoria 4';
    END CASE;
    dbms_output.put_line('Membrul ' || upper(v_nume) || ' a imprumutat ' || v_nr_carti || ' carti si face parte din ' || v_categ);
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Sunt mai multi membrii cu acelasi nume!');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista acest membru!');
    WHEN OTHERS THEN 
      dbms_output.put_line('Error!'); 
END;
/

--5.Crea?i  tabelul member_***  (o  copie  a  tabelului member).  
--Ad?uga?i  în  acest  tabel  coloana discount,  care  va  reprezenta  procentul  de  reducere  aplicat  pentru  
--membrii,  în  func?ie  de  categoria din care fac parte ace?tia: 
---10% pentru membrii din Categoria 1 
---5% pentru membrii din Categoria 2
---3% pentru membrii din Categoria 3
---nimic 
--Actualiza?i  coloana discount pentru un membru al c?rui cod este dat de la tastatur?. 
--Afi?a?i  un mesaj din care s? reias? dac? actualizarea s-a produs sau nu.

create table member_rs as select * from member;
alter table member_rs
add discount number;
select * from member_rs;

DECLARE
    v_id member.member_id%TYPE := &p_id;
    v_nr_carti NUMBER;
    v_tot_carti NUMBER;
    v_discount NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_tot_carti
    FROM title;
    
    SELECT COUNT(DISTINCT(title_id)) INTO v_nr_carti
    FROM rental 
    WHERE member_id(+) = v_id
    GROUP BY member_id;
    
    CASE
    WHEN v_nr_carti >= (v_tot_carti * 75) / 100 THEN
        v_discount := 10;
    WHEN v_nr_carti >= (v_tot_carti * 50) / 100 THEN
        v_discount := 5;
    WHEN v_nr_carti >= (v_tot_carti * 25) / 100 THEN
        v_discount := 3;
    ELSE v_discount := 0;
    END CASE;
    
    UPDATE member_rs
    SET discount = v_discount
    WHERE v_id = member_id;
    
    IF SQL%ROWCOUNT = 0 THEN
        dbms_output.put_line('Nu exista un angajat cu acest cod');
    ELSE
        dbms_output.put_line('Actualizare realizata');
    END IF;
EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        dbms_output.put_line('Sunt mai multi membrii cu acelasi nume!');
    WHEN NO_DATA_FOUND THEN
        dbms_output.put_line('Nu exista acest membru!');
    WHEN OTHERS THEN 
      dbms_output.put_line('Error!'); 
END;
/