--1.Pentru fiecare job (titlu –care va fi afi?at o singur? dat?) ob?ine?i lista angaja?ilor (nume ?i salariu) 
--care lucreaz? în prezent pe jobul respectiv. Trata?i cazul în care nu exist? angaja?i care s? lucreze în prezent 
--pe un anumit job. Rezolva?i problema folosind:
--a.cursoare clasice
--b.ciclu cursoare
--c.ciclu cursoare cu subcereri
--d.expresii cursor

--a. CURSOR CLASIC
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary salariu
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    v_numeJ jobs.job_title%TYPE;
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_salariu employees.salary%TYPE;
BEGIN
    SELECT job_id BULK COLLECT INTO v_id FROM jobs;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        dbms_output.put_line('            ' || v_numeJ);
        OPEN c(v_id(i));
        LOOP
            FETCH c INTO v_nume, v_prenume, v_salariu;
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line('Angajatul: ' || v_nume || ' ' || v_prenume || ' are salariul: ' || v_salariu);
        END LOOP;
        IF c%ROWCOUNT = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        CLOSE c;
        dbms_output.new_line();
    END LOOP;
END;
/

--b. CICLU CURSOARE
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary salariu
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    v_numeJ jobs.job_title%TYPE;
    cont NUMBER;
BEGIN
    SELECT job_id BULK COLLECT INTO v_id FROM jobs;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        dbms_output.put_line('            ' || v_numeJ);
        cont := 0;
        FOR j IN c(v_id(i)) LOOP
            EXIT WHEN c%NOTFOUND;
            dbms_output.put_line('Angajatul: ' || j.nume || ' ' || j.prenume || ' are salariul: ' || j.salariu);
            cont := cont + 1;
        END LOOP;
        IF cont = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        dbms_output.new_line();
    END LOOP;
END;
/

--c. CICLU CURSOARE CU SUBCERERI
DECLARE
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    v_numeJ jobs.job_title%TYPE;
    cont NUMBER;
BEGIN
    SELECT job_id BULK COLLECT INTO v_id FROM jobs;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        dbms_output.put_line('            ' || v_numeJ);
        cont := 0;
        FOR j IN (SELECT last_name nume, first_name prenume, salary salariu
                  FROM employees e, jobs j
                  WHERE e.job_id = j.job_id AND j.job_id = v_id(i)) LOOP
            dbms_output.put_line('Angajatul: ' || j.nume || ' ' || j.prenume || ' are salariul: ' || j.salariu);
            cont := cont + 1; 
        END LOOP;
        IF cont = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        dbms_output.new_line();
    END LOOP;
END;
/

--d. EXPRESII CURSOR
DECLARE
    CURSOR c IS SELECT j2.job_title, CURSOR (SELECT last_name nume, first_name prenume, salary salariu
                                             FROM employees e, jobs j
                                             WHERE e.job_id = j.job_id AND j.job_id = j2.job_id)
                FROM jobs j2;
    v_job jobs.job_title%TYPE; 
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_salariu employees.salary%TYPE;
    TYPE refcursor IS REF CURSOR;
    v_cursor refcursor;
BEGIN
    OPEN c;
    dbms_output.new_line();
    LOOP
        FETCH c INTO v_job, v_cursor;
        EXIT WHEN c%NOTFOUND;
        dbms_output.put_line('            ' || v_job);
        LOOP
            FETCH v_cursor INTO v_nume, v_prenume, v_salariu;
            EXIT WHEN v_cursor%NOTFOUND;
            dbms_output.put_line('Angajatul: ' || v_nume || ' ' || v_prenume || ' are salariul: ' || v_salariu);
        END LOOP;
        IF v_cursor%ROWCOUNT = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        dbms_output.new_line();
    END LOOP;
    CLOSE c;
END;
/

--2. Modifica?i exerci?iul anterior astfel încât s? ob?ine?i ?i urm?toarele informa?ii:
--  -un num?r de ordine pentru fiecare angajat care va fi resetat pentru fiecare job
--  -pentru fiecare job
--          ->num?rul de angaja?i 
--          ->valoarea lunar? a veniturilor angaja?ilor 
--          ->valoarea medie a veniturilor angaja?ilor   
--  -indiferent job
--          ->num?rul total de angaja?i
--          ->valoarea total? lunar? a veniturilor angaja?ilor
--          ->valoarea medie a veniturilor angaja?ilor

--a. CURSOR CLASIC
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary + (salary * nvl(commission_pct, 0)) venit
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    TYPE t_venit IS TABLE OF NUMBER;
    venit_job t_venit;
    v_numeJ jobs.job_title%TYPE;
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_venit NUMBER;
    venit_total NUMBER := 0;
    v_cntT NUMBER := 0;
    v_cnt NUMBER;
    v_medie NUMBER;
BEGIN
    SELECT j.job_id, COUNT(*), SUM(salary) + SUM(salary * nvl(commission_pct, 0)) BULK COLLECT INTO v_id, v_nr_ang, venit_job 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) = 0 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' nu are niciun angajat, deci venitul total lunar este 0, iar cel mediu este 0');
        ELSIF v_nr_ang(i) = 1 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are 1 angajat, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || venit_job(i));
        ELSE
            v_medie := venit_job(i) / v_nr_ang(i);
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are ' || v_nr_ang(i) || ' angajati, deci salariul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || v_medie);
        END IF;
        OPEN c(v_id(i));
        v_cnt := 0;
        LOOP
            FETCH c INTO v_nume, v_prenume, v_venit;
            EXIT WHEN c%NOTFOUND;
            v_cnt := v_cnt + 1;
            dbms_output.put_line(v_cnt || '. Angajatul: ' || v_nume || ' ' || v_prenume || ' are venitul lunar: ' || v_venit);
        END LOOP;
        IF c%ROWCOUNT = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        v_cntT := v_cntT + v_nr_ang(i);
        venit_total := venit_total + venit_job(i);
        CLOSE c;
        dbms_output.new_line();
    END LOOP;
    v_medie := venit_total / v_cntT;
    dbms_output.put_line('In aceasta firma lucreaza ' || v_cntT || ' angajati, salariul total al acestora este ' || venit_total || ', iar cel mediu este ' || v_medie);
END;
/

--b. CICLU CURSOARE
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary + (salary * nvl(commission_pct, 0)) venit
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    TYPE t_venit IS TABLE OF NUMBER;
    venit_job t_venit;
    v_numeJ jobs.job_title%TYPE;
    venit_total NUMBER := 0;
    v_cntT NUMBER := 0;
    v_cnt NUMBER;
    v_medie NUMBER;
BEGIN
    SELECT j.job_id, COUNT(*), SUM(salary) + SUM(salary * nvl(commission_pct, 0)) BULK COLLECT INTO v_id, v_nr_ang, venit_job 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) = 0 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' nu are niciun angajat, deci venitul total lunar este 0, iar cel mediu este 0');
        ELSIF v_nr_ang(i) = 1 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are 1 angajat, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || venit_job(i));
        ELSE
            v_medie := venit_job(i) / v_nr_ang(i);
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are ' || v_nr_ang(i) || ' angajati, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || v_medie);
        END IF;
        v_cnt := 0;
        FOR j IN c(v_id(i)) LOOP
            EXIT WHEN c%NOTFOUND;
            v_cnt := v_cnt + 1;
            dbms_output.put_line(v_cnt || '. Angajatul: ' || j.nume || ' ' || j.prenume || ' are venitul lunar: ' || j.venit);
        END LOOP;
        IF v_cnt = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        v_cntT := v_cntT + v_nr_ang(i);
        venit_total := venit_total + venit_job(i);
        dbms_output.new_line();
    END LOOP;
    v_medie := venit_total / v_cntT;
    dbms_output.put_line('In aceasta firma lucreaza ' || v_cntT || ' angajati, venitul total al acestora este ' || venit_total || ', iar cel mediu este ' || v_medie);
END;
/

--c. CICLU CURSOARE CU SUBCERERI
DECLARE
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    TYPE t_venit IS TABLE OF NUMBER;
    venit_job t_venit;
    v_numeJ jobs.job_title%TYPE;
    venit_total NUMBER := 0;
    v_cntT NUMBER := 0;
    v_cnt NUMBER;
    v_medie NUMBER;
BEGIN
    SELECT j.job_id, COUNT(*), SUM(salary) + SUM(salary * nvl(commission_pct, 0)) BULK COLLECT INTO v_id, v_nr_ang, venit_job 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) = 0 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' nu are niciun angajat, deci venitul total lunar este 0, iar cel mediu este 0');
        ELSIF v_nr_ang(i) = 1 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are 1 angajat, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || venit_job(i));
        ELSE
            v_medie := venit_job(i) / v_nr_ang(i);
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are ' || v_nr_ang(i) || ' angajati, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || v_medie);
        END IF;
        v_cnt := 0;
        FOR j IN (SELECT last_name nume, first_name prenume, salary + (salary * nvl(commission_pct, 0)) venit
                  FROM employees e, jobs j
                  WHERE e.job_id = j.job_id AND j.job_id = v_id(i)) LOOP
            v_cnt := v_cnt + 1;
            dbms_output.put_line(v_cnt || '. Angajatul: ' || j.nume || ' ' || j.prenume || ' are venitul lunar: ' || j.venit);
        END LOOP;
        IF v_cnt = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        v_cntT := v_cntT + v_nr_ang(i);
        venit_total := venit_total + venit_job(i);
        dbms_output.new_line();
    END LOOP;
    v_medie := venit_total / v_cntT;
    dbms_output.put_line('In aceasta firma lucreaza ' || v_cntT || ' angajati, venitul total al acestora este ' || venit_total || ', iar cel mediu este ' || v_medie);
END;
/

--d. EXPRESII CURSOR
DECLARE
    CURSOR c IS SELECT j2.job_title, CURSOR (SELECT last_name nume, first_name prenume,  salary + (salary * nvl(commission_pct, 0)) venit
                                             FROM employees e, jobs j
                                             WHERE e.job_id = j.job_id AND j.job_id = j2.job_id)
                FROM jobs j2;
    v_job jobs.job_title%TYPE; 
    v_nr_ang NUMBER;
    venit_job NUMBER;
    venit_total NUMBER := 0;
    v_cntT NUMBER := 0;
    v_medie NUMBER;
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_venit NUMBER;
    TYPE refcursor IS REF CURSOR;
    v_cursor refcursor;
BEGIN
    OPEN c;
    dbms_output.new_line();
    LOOP
        FETCH c INTO v_job, v_cursor;
        EXIT WHEN c%NOTFOUND;
        v_nr_ang := 0;
        venit_job := 0;
        dbms_output.put_line('      Jobul ' || v_job);
        LOOP
            FETCH v_cursor INTO v_nume, v_prenume, v_venit;
            EXIT WHEN v_cursor%NOTFOUND;
            v_nr_ang := v_nr_ang + 1;
            venit_job := venit_job + v_venit;
            dbms_output.put_line(v_nr_ang || '. Angajatul: ' || v_nume || ' ' || v_prenume || ' are venitul lunar: ' || v_venit);
        END LOOP;
        IF v_nr_ang = 0 THEN
            dbms_output.put_line('Status: Jobul ' || v_job || ' nu are niciun angajat, deci venitul total lunar este 0, iar cel mediu este 0');
        ELSIF v_nr_ang = 1 THEN
            dbms_output.put_line('Status: Jobul ' || v_job || ' are 1 angajat, deci venitul total lunar este ' || venit_job || ', iar cel mediu este ' || venit_job);
        ELSE
            v_medie := venit_job / v_nr_ang;
            dbms_output.put_line('Status: Jobul ' || v_job || ' are ' || v_nr_ang || ' angajati, deci venitul total lunar este ' || venit_job || ', iar cel mediu este ' || v_medie);
        END IF;
        v_cntT := v_cntT + v_nr_ang;
        venit_total := venit_total + venit_job;
        dbms_output.new_line();
    END LOOP;
    CLOSE c;
    v_medie := venit_total / v_cntT;
    dbms_output.put_line('In aceasta firma lucreaza ' || v_cntT || ' angajati, venitul total al acestora este ' || venit_total || ', iar cel mediu este ' || v_medie);
END;
/

--3.Modifica?i  exerci?iul  anterior  astfel  încât  s?  ob?ine?i  suma  total?  alocat?  lunar  pentru  plata 
--salariilor ?i a comisioanelor tuturor angaja?ilor, iar pentru fiecare angajat cât la sut? din aceast? sum? 
--câ?tig? lunar. 
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary + (salary * nvl(commission_pct, 0)) venit
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    TYPE t_venit IS TABLE OF NUMBER;
    venit_job t_venit;
    v_numeJ jobs.job_title%TYPE;
    venit_total NUMBER := 0;
    v_cntT NUMBER := 0;
    v_cnt NUMBER;
    v_medie NUMBER;
BEGIN
    SELECT j.job_id, COUNT(*), SUM(salary) + SUM(salary * nvl(commission_pct, 0)) BULK COLLECT INTO v_id, v_nr_ang, venit_job 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    SELECT SUM(salary) + SUM(salary * commission_pct)
    INTO venit_total
    FROM employees;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) = 0 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' nu are niciun angajat, deci venitul total lunar este 0, iar cel mediu este 0');
        ELSIF v_nr_ang(i) = 1 THEN
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are 1 angajat, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || venit_job(i));
        ELSE
            v_medie := venit_job(i) / v_nr_ang(i);
            dbms_output.put_line('      Jobul ' || v_numeJ || ' are ' || v_nr_ang(i) || ' angajati, deci venitul total lunar este ' || venit_job(i) || ', iar cel mediu este ' || v_medie);
        END IF;
        v_cnt := 0;
        FOR j IN c(v_id(i)) LOOP
            EXIT WHEN c%NOTFOUND;
            v_cnt := v_cnt + 1;
            dbms_output.put_line(v_cnt || '. Angajatul: ' || j.nume || ' ' || j.prenume || ' are venitul lunar: ' || j.venit || ' astfel castigand un procent de ' ||  TO_CHAR((j.venit * 100 / venit_total), '0.00') || ' din venitul total');
        END LOOP;
        IF v_cnt = 0 THEN
            dbms_output.put_line('Nu exista niciun angajat cu acest job.');
        END IF;
        v_cntT := v_cntT + v_nr_ang(i);
        dbms_output.new_line();
    END LOOP;
    v_medie := venit_total / v_cntT;
    dbms_output.put_line('In aceasta firma lucreaza ' || v_cntT || ' angajati, venitul total al acestora este ' || venit_total || ', iar cel mediu este ' || v_medie);
END;
/

--4.Modifica?i  exerci?iul anterior astfel încât s? ob?ine?i  pentru  fiecare  job primii 5  angaja?i care câ?tig? 
--cel mai mare salariu lunar. Specifica?i dac? pentru un job sunt mai pu?in de 5 angaja?i. 
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary salariu
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru
           ORDER BY salary DESC;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    v_numeJ jobs.job_title%TYPE;
    v_cnt NUMBER;
BEGIN
    SELECT j.job_id, COUNT(*) BULK COLLECT INTO v_id, v_nr_ang 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) < 5 THEN
            dbms_output.put_line('Jobul ' || v_numeJ || ' are mai putin de 5 angajati');
        ELSE
            dbms_output.put_line('Primii 5 angajati cu salariul cel mai mare ce au Jobul ' || v_numeJ);
        END IF;
        v_cnt := 0;
        FOR j IN c(v_id(i)) LOOP
            EXIT WHEN c%NOTFOUND OR v_cnt = 5;
            v_cnt := v_cnt + 1;
            dbms_output.put_line(v_cnt || '. Angajatul: ' || j.nume || ' ' || j.prenume || ' are salariul lunar: ' || j.salariu);
        END LOOP;
        dbms_output.new_line();
    END LOOP;
END;
/

--5.Modifica?i exerci?iul anterior astfel încât s? ob?ine?i pentru fiecare job top 5 angaja?i. Dac? exist? mai mul?i 
--angaja?i care respect? criteriul de selec?ie care au acela?i salariu, atunci ace?tia vor ocupa aceea?i pozi?ie în top 5.
DECLARE
    CURSOR c (parametru  jobs.job_id%TYPE) IS 
           SELECT last_name nume, first_name prenume, salary salariu
           FROM employees e, jobs j
           WHERE e.job_id = j.job_id AND j.job_id = parametru
           ORDER BY salary DESC;
    TYPE t_jobId IS TABLE OF jobs.job_id%TYPE;
    v_id t_jobId; 
    TYPE t_nr_ang IS TABLE OF NUMBER;
    v_nr_ang t_nr_ang;
    v_numeJ jobs.job_title%TYPE;
    v_nume employees.last_name%TYPE;
    v_prenume employees.first_name%TYPE;
    v_salariu employees.salary%TYPE;
    v_prec NUMBER;
    v_top NUMBER := 1;
BEGIN
    SELECT j.job_id, COUNT(*) BULK COLLECT INTO v_id, v_nr_ang 
    FROM jobs j, employees e
    WHERE j.job_id = e.job_id
    GROUP BY j.job_id;
    dbms_output.new_line();
    FOR i IN v_id.FIRST..v_id.LAST LOOP
        SELECT job_title INTO v_numeJ
        FROM jobs
        WHERE job_id = v_id(i);
        IF v_nr_ang(i) < 5 THEN
            dbms_output.put_line('Jobul ' || v_numeJ || ' are mai putin de 5 angajati');
        ELSE
            dbms_output.put_line('Top 5 cele mai mari salarii corespunzatoare angajatilor ce au jobul Jobul ' || v_numeJ);
        END IF;
        OPEN c(v_id(i));
        FETCH c INTO v_nume, v_prenume, v_prec;
        dbms_output.put_line('Angajatul: ' || v_nume || ' ' || v_prenume || ' are salariul: ' || v_prec);
        LOOP
            FETCH c INTO v_nume, v_prenume, v_salariu;
            EXIT WHEN c%NOTFOUND;
            IF v_salariu <> v_prec THEN
                v_top := v_top + 1;
            END IF;
            EXIT WHEN v_top = 6;
            v_prec := v_salariu;
            dbms_output.put_line('Angajatul: ' || v_nume || ' ' || v_prenume || ' are salariul: ' || v_salariu);
        END LOOP;
        CLOSE c;
        dbms_output.new_line();
    END LOOP;
END;
/