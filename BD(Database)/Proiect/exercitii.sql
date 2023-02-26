--12

--I.	Afiati codul cinematografului,  codul filmului,  numele filmului, numarul salii în care va difuza filmul,
--numele si prenumele (concatenate) actorilor care joaca în acest film si aprecierea filmului. Aprecierea este 
--obtinuta prin urmatarea regula: daca filmul are un rating de nota 8, atunci este „Foarte apreciat”, daca are un 
--rating de 6.3 este „Nu foarte apreciat”, altfel este „Apreciat”.  Rezultatele trebuie sa contina doar 
--cinematografele ce au numele „Cinema City”, au locatia într-un oras al carui nume are o lungime mai mare decât 8,
--iar tipul salilor  incluse în acestea au structura ‘multi’ în nume. Filmele care ruleaza în aceste cinematografe
--vor fi afisate doar daca ruleaza pe o durata mai mare de 4 luni. Aceste rezultate vor fi ordonate crescator dupa
--codul cinematorafului în care ruleaza. 

select r.cod_cinema, f.cod_film, f.nume_film, d.nr_sala, concat(concat(a.nume, ' '), a.prenume) as nume_actor,
       case f.rating
       when 6.3 then 'Nu prea apreciat'
       when 8.0 then 'Foarte apreciat'
       else 'Apreciat' end as aprecieri
from film f, ruleaza r, difuzare d, joaca j, actor a
where f.cod_film = r.cod_film and f.cod_film = d.cod_film 
      and f.cod_film = j.cod_film and j.id_actor = a.id_actor
      and months_between(r.data_final, r.data_inceput) > 4
      and r.cod_cinema in (select c.cod_cinema
                           from cinematograf c, locatie l, sala s
                           where l.id_locatie = c.id_locatie and s.cod_cinema = c.cod_cinema
                                 and lower(c.nume_cinema) like lower('Cinema City')
                                 and length(l.oras) > 8 and lower(s.tip) like '%multi%')
order by 1;


--II.	Afisati numele si prenumele (concatenate) angajatului si salariul modificat pentru toti angajatii care
--au numarul de ore egal cu numarul minim de ore din cinematograful în care sunt angajati. Rezultatele trebuie 
--sa redea angajatii pentru care codul cinematografului în care lucreaza este mai mare decât 120 si care au 
--asignat un job ce contine în codul sau litera ‘a’. Salariul se modifica dupa regula urmatoare: daca persoana 
--s-a angajat în decursul anului 2017, atunci va avea o marire de salariu cu 30%, daca s-a angajat în decursul 
--anului 2018, atunci va avea o marire de salariu cu 25%, daca s-a angajat în decursul anului 2019, atunci va 
--avea o marire de salariu cu 20%, daca s-a angajat în decursul anului 2020, atunci va avea o marire de salariu 
--cu 15%,  altfel va avea o marire de salariu cu 10%. Rezultatele vor fi afisate descrescator, dupa valoarea 
--salariului modificat.

select concat(concat(a1.nume, ' '), a1.prenume) as nume, l1.salariu as salariu,
       decode(to_char(l1.data_ang, 'YYYY'),'2017', l1.salariu * 1.3,'2018', l1.salariu * 1.25,
              '2019',l1.salariu * 1.2,'2020', l1.salariu * 1.15, l1.salariu * 1.1) as "Modificare salariu"
from angajat a1, lucreaza l1
where a1.cod_angajat = l1.cod_angajat
      and l1.data_demisie is null
      and months_between(sysdate, l1.data_ang) > 30
      and a1.nr_ore = (select min(nr_ore)
                       from angajat a2, lucreaza l, cinematograf c
                       where a1.cod_angajat = a2.cod_angajat and a2.cod_angajat = l.cod_angajat
                             and l.cod_cinema = c.cod_cinema and c.cod_cinema > 120 
                             and lower(l.cod_job) like '%a%')
order by "Modificare salariu" desc;


--III.	Afisati pentru fiecare cinematograf ce detine mai mult de doua sali sala cu indicele maxim. 
--Rezultatele vor fi afisate descrescator dupa indicele salilor.

select cod_cinema, max(nr_sala)
from sala
having count(nr_sala) > 2
group by cod_cinema
order by 2 desc;


--IV.	Afisati codul cinematografului în care lucreaza fiecare angajat, codul jobului asignat, numele si 
--prenumele (concatenate) angajatului, numarul de telefon sau lipsa acestuia si salariul angajatului. 
--Rezultatele trebuie sa respecte conditia ca pentru fiecare angajat afisat acesta si aiba salariul mai mare 
--decât salariul minim din cinematograful în care lucreaza si mai mic decât salariul mediu din cinematograful 
--în care lucreaza (bloc de instructiuni with).

with 
sal_mediu as (select l1.cod_cinema, round(avg(l1.salariu)) as s_mediu
              from lucreaza l1
              group by l1.cod_cinema),
sal_min as (select l2.cod_cinema, min(l2.salariu) as s_min
            from  lucreaza l2
            group by l2.cod_cinema)
select l.cod_cinema, l.cod_job, concat(concat(a.nume, ' '), a.prenume) as nume_angajat, 
       nvl(a.telefon, 'Nu a introdus nr. telefon') as telefon, l.salariu
from angajat a, lucreaza l
where l.cod_angajat = a.cod_angajat
      and l.salariu > (select s_min
                       from sal_min
                       where cod_cinema = l.cod_cinema)
        and l.salariu < (select s_mediu
                         from sal_mediu
                         where cod_cinema = l.cod_cinema)
order by l.cod_cinema;

 
--V.	Afisati numele cinematografului, complexul din care face parte (sau mesajul „este independent” în 
--cazul în care  nu apartine de un complex), orasul din care face parte, numele filmului care ruleaza în 
--cinematograful respectiv, numele si prenumele (concatenate) regizorului care a îndrumat filmul respectiv si 
--titlul acestui regizor, în functie de numarul de premii dobândite. Titlul regizorului se obtine dupa regula: 
--daca acesta nu are niciun premiu, atunci se va afisa  „nepremiat”,  daca are un premiu se va afisa „putin 
--premiat”, daca are 5 premii se va afisa „premiat”, iar altfel se va afisa „foarte premiat”.  Rezultatele vor 
--contine doar date despre cinematografele care s-au deschis într-o luna ce are 31 de zile si filmele care au o 
--durata mai mare de doua ore (120 minute) . 
 
select c.nume_cinema, nvl(c.complex, 'este independent') as Complex, l.oras, f.nume_film, 
       concat(concat(re.nume, ' '), re.prenume) as nume_regizor,
       decode(re.nr_premii, 0, 'nepremiat', 1, 'putin premiat', 5, 'premiat',  'foarte premiat') as Titlu_regizor
from cinematograf c, film f, ruleaza r, indruma i, regizor re, locatie l
where c.cod_cinema = r.cod_cinema and r.cod_film = f.cod_film 
      and f.cod_film = i.cod_film and i.id_regizor = re.id_regizor
      and c.id_locatie = l.id_locatie
      and f.durata > 120 and to_char(last_day(c.data_desch), 'DD') = 31;


--13.

--I. 	Sa se stearga datele despre rularea tuturor filmelor ce au o durata mai mare de 2 ore si jumatate 
--(150 minute).
delete from ruleaza
where cod_film in (select cod_film
                   from film
                   where durata > 150);

--II. 	Pentru toti angajatii ce au codul job-ului de forma „ING...” sa se modifice valoare numarului de ore 
--lucrate, primind valoarea 8. (S? lucreze 8 ore toti inginerii).                
update angajat
set nr_ore = 8
where cod_angajat in (select cod_angajat
                      from lucreaza
                      where lower(cod_job) like 'ing%');
                      
--III.   Sa se stearga datele despre difuzarea tuturor filmelor ce au o durata mai mare de 2 ore si jumatate 
--(150 minute). 
delete from difuzare
where cod_film in (select cod_film
                   from film
                   where durata > 150);
                  
commit;


--16.

--Sa se afiseze codul filmului, al difuzarii acestuia (un film poate avea corespondent in tabela difuzare sau nu), 
--id-urile actorilor care joaca in acesta (un film poate avea actori atribuiti care au fost introdusi in baza 
--de date sau nu) si id-urile regizorilor care au indrumat acest film (un film poate avea actori atribuiti care 
--au fost introdusi in baza de date sau nu).

select f.cod_film, d.cod_difuzare, j.id_actor, i.id_regizor
from indruma i, film f, joaca j, difuzare d
where f.cod_film = i.cod_film(+)
      and f.cod_film = j.cod_film(+)
      and f.cod_film = d.cod_film(+);
      
      
--Sa se afiseze codurile filmelor care ruleaza in toate cinematorafele ce au numele 'Cinema Victoria'.

select distinct cod_film
from ruleaza r1
where not exists (select *
                  from cinematograf c
                  where lower(nume_cinema) like 'cinema victoria'
                        and not exists (select *
                                        from ruleaza r2
                                        where r2.cod_cinema = c.cod_cinema and 
                                              r1.cod_film = r2.cod_film));
                                              
--Sa se afiseze codul cinematografelor care ruleaza toate filmele care au aparut in anul 2019.    

insert into ruleaza
values(seq_cod_ruleaza.nextval, 160, 1610, '5 may 2019', '9 august 2019');

select cod_cinema
from ruleaza
where cod_film in (select cod_film
                   from film
                   where an_aparitie = 2019)
group by cod_cinema
having count(cod_film) = (select count(*)
                          from film 
                          where an_aparitie = 2019);

commit;