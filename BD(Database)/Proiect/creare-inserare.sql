create sequence seq_id_locatie
increment by 5
start with 100
maxvalue 9999
nocycle
cache 10;


create sequence seq_cod_cinema
increment by 20
start with 100
maxvalue 9999
nocycle
cache 10;


create sequence seq_nr_sala
increment by 3
start with 1
minvalue 1
maxvalue 40
cycle
cache 10;
 
 
create sequence seq_cod_angajat
increment by 17
start with 1000
maxvalue 9999
nocycle
cache 15;


create sequence seq_cod_film
increment by 100
start with 10
maxvalue 9999
nocycle
cache 20;


create sequence seq_cod_difuzare
increment by 21
start with 50
maxvalue 9999
nocycle
cache 25;

create sequence seq_cod_bilet
increment by 5
start with 1
maxvalue 9999
nocycle
cache 10;


create sequence seq_id_actor
increment by 15
start with 10
maxvalue 9999
nocycle
cache 10;


create sequence seq_id_regizor
increment by 20
start with 30
maxvalue 9999
nocycle
cache 10;

create sequence seq_cod_joaca
increment by 20
start with 30
maxvalue 9999
nocycle
cache 50;


create sequence seq_cod_ruleaza
increment by 40
start with 100
maxvalue 9999
nocycle
cache 50;


create table locatie(
    id_locatie number(4) constraint pk_locatie primary key,
    tara varchar(3) constraint null_tara_loc not null,
    oras varchar(20) constraint null_oras_loc not null,
    localitate varchar(20),
    strada varchar(20) constraint null_strada_loc not null,
    nr_strada number(2));


create table job(
    cod_job varchar(6) constraint pk_job primary key,
    nume_job varchar(20) constraint null_nume_job not null,
    salariu_min number(8, 2) constraint null_sal_min not null,
    salariu_max number(8, 2) constraint null_sal_max not null,
    constraint unq_nume_job unique(nume_job),
    constraint ck_sal_min check(salariu_min > 0.0),
    constraint ck_sal_max check(salariu_max > 0.0));


create table angajat(
    cod_angajat number(4) constraint pk_angajat primary key,
    nume varchar(25) constraint null_nume_ang not null,
    prenume varchar(25),
    email char(25) constraint null_email_ang not null,
    telefon varchar2(20),
    nr_ore number(2) constraint null_nr_ore not null,
    id_superior number(4) constraint fk_ang_ang_sup references angajat(cod_angajat) on delete cascade, 
    constraint unq_nume_pren_ang unique(nume, prenume),
    constraint unq_email_ang unique(email),
    constraint ck_nr_ore_ang check(nr_ore > 0 and nr_ore < 24));
    

create table cinematograf(
    cod_cinema number(4) constraint pk_cinema primary key,
    nume_cinema varchar(25) constraint null_nume_cinema not null,
    id_locatie number(4) constraint null_loc_cinema not null,
    complex varchar2(30),
    telefon varchar2(20),
    email char(25) constraint null_email_cinema not null,
    data_desch date default sysdate,
    constraint unq_email_cinema unique(email),
    constraint fk_cinem_loc foreign key(id_locatie) references locatie(id_locatie) on delete cascade);
alter table cinematograf add constraint unqid_loc_cin unique(id_locatie);


create table lucreaza(
    cod_cinema number(4) constraint fk_cin_lucr references cinematograf(cod_cinema),
    cod_angajat number(4)constraint fk_ang_lucr references angajat(cod_angajat),
    cod_job varchar(6)constraint fk_job_lucr references job(cod_job),
    data_ang date default sysdate,
    data_demisie date,
    salariu number(8,2),
    constraint pk_ang_lucr_cin primary key( cod_angajat, cod_cinema, cod_job, data_ang),
    constraint ck_sal_ang check(salariu > 0));

  
create table film(
    cod_film number(4) constraint pk_film primary key,
    nume_film varchar(25) constraint null_nume_film not null,
    gen varchar(20) constraint null_gen not null, 
    durata number(3) default 0,
    rating number(2, 1) constraint ck_rating check(rating > 0.0 and rating <= 10.0),
    an_aparitie number(4) constraint null_an_aparitie not null,
    constraint ck_an_ap check(an_aparitie > 0),
    constraint unq_nume_film_an_ap unique(nume_film, an_aparitie));
    

create table ruleaza(
    cod_rulare number(4) constraint pk_ruleaza primary key,
    cod_cinema number(4) constraint fk_cin_rul references cinematograf(cod_cinema),
    cod_film number(4) constraint fk_film_rul references film(cod_film),
    data_inceput date default sysdate,
    data_final date default sysdate); 

    
create table actor(
    id_actor number(4) constraint pk_actor primary key,
    nume varchar(25) constraint null_nume_actor not null,
    prenume varchar(25),
    tara varchar(3) constraint null_tara_act not null,
    nr_premii number(3) default 0,
    an_debut number(4) constraint null_an_debut_act not null,
    salariu number(8, 2) constraint null_sal_act not null,
    constraint unq_nume_pren_act unique(nume, prenume),
    constraint ck_nr_premii_act check(nr_premii >= 0),
    constraint ck_an_debut_act check(an_debut > 0),
    constraint ck_sal_act check(salariu > 0));
    
    
create table joaca(
    cod_joaca number(4) constraint pk_joaca primary key,
    cod_film number(4) constraint fk_film_joaca references film(cod_film),
    id_actor number(4) constraint fk_act_joaca references actor(id_actor),
    rol varchar(20) constraint null_rol_joaca not null);
    
   
create table regizor(
    id_regizor number(4) constraint pk_regizor primary key,
    nume varchar(25) constraint null_nume_regizor not null,
    prenume varchar(25),
    tara varchar(3) constraint null_tara_reg not null,
    nr_premii number(3) default 0,
    constraint unq_nume_pren_reg unique(nume, prenume),
    constraint ck_nr_premii_reg check(nr_premii >= 0));


create table indruma(
    cod_film number(4) constraint fk_film_indruma references film(cod_film),
    id_regizor number(4) constraint fk_regizor_indruma references regizor(id_regizor),
    an_inceput number(4) constraint null_an_inc_indr not null,
    constraint pk_regizor_film primary key(cod_film, id_regizor),
    constraint ck_an_inc_indr check(an_inceput > 0));
    
    
create table sala(
    nr_sala number(2),
    cod_cinema number(4),
    tip varchar(10), 
    constraint ck_nr_sala check(nr_sala <= 40 and nr_sala > 0),
    constraint fk_sala_cinema foreign key(cod_cinema) references cinematograf(cod_cinema),
    constraint pk_sala_cin primary key(nr_sala, cod_cinema));
  
         
create table difuzare(
    cod_difuzare number(4) constraint pk_difuzare primary key,
    cod_film number(4) constraint null_dif_film not null,
    nr_sala number(2) constraint null_sala_dif not null,
    cod_cinema number(4) constraint null_cin_dif not null,
    data_inc date default sysdate,
    ora_inc number(2) constraint null_ora_inc not null,
    constraint ck_ora_inc check(ora_inc > 0 and ora_inc < 24),
    constraint fk_film_dif foreign key(cod_film) references film(cod_film),
    constraint fk_nr_sala_cin_dif foreign key(nr_sala, cod_cinema) references sala(nr_sala, cod_cinema));  
    
    
create table bilet(
    cod_bilet number(4) constraint pk_bilet primary key,
    pret number(8, 2) default 0.0,
    nr_loc number(3) constraint null_loc_bilet not null,
    nr_rand number(3) constraint null_rand_bilet not null,
    cod_difuzare number(4) constraint null_cod_dif_bilet not null,
    constraint ck_pret check(pret >= 0.0),
    constraint ck_nr_loc check(nr_loc > 0 and nr_loc <= 300),
    constraint ck_nr_rand check(nr_rand > 0 and nr_rand <= 20),
    constraint fk_bilet_dif foreign key(cod_difuzare) references difuzare(cod_difuzare) on delete cascade);


insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Bucuresti', 'Bucuresti', 'Liviu Rebreanu', 4);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Bucuresti', 'Bucuresti', 'Bd Timisoara', 26);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Bucuresti', 'Bucuresti', 'Mihai Eminescu', null);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Sibiu', null, 'Aurel Vlaicu', 11);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Suceava', 'Suceava', 'Energeticului', null);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Iasi', 'Iasi', 'Piata Unirii', 5);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Constanta', null, 'Aurel Vlaicu', 2);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Cluj-Napoca', null, 'Bd Eroilor', 51);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Baia Mare', null, 'Victoriei', 73);
insert into locatie
values(seq_id_locatie.nextval, 'RO', 'Pitesti', null, 'Justitiei', 1);

select * from locatie;


insert into job
values('CAS', 'Casier', 3792.1, 6293.0);
insert into job
values('AG_C', 'Agent de Curatenie', 1239.2, 999.9);
insert into job
values('MAN', 'Manager', 5439.22, 6934.2);
insert into job
values('ING_S', 'Inginer Sunet', 3234.2, 4593.3);
insert into job
values('ING_T', 'Inginer Tehnic', 2134.2, 5593.3);
insert into job
values('PLAS', 'Plasator', 1231.4, 3432.43);
insert into job
values('BAR_C', 'Barman Cafenea', 1312.3, 2313.3);
insert into job
values('BAR', 'Barman', 1192.3, 1922.0);

select * from job;


insert into angajat
values(seq_cod_angajat.nextval, 'Popescu', 'Ion', 'ion.popescu@gmail.com', '0741.311.314', 8, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Georgesc', 'Vasile', 'vasile.georgesc@gmail.com', null, 8, 1000);
insert into angajat
values(seq_cod_angajat.nextval, 'Matei', 'Andrei', 'andrei.matei@gmail.com', '0799.532.678', 6, 1000);
insert into angajat
values(seq_cod_angajat.nextval, 'Iana', 'Gabriela', 'gabriela.iana@gmail.com', '0712.623.881', 6, 1034);
insert into angajat
values(seq_cod_angajat.nextval, 'Tudor', 'Maria', 'maria.tudor@gmail.com', '0712.133.292', 10, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Miron', 'Costin', 'costin.miron@gmail.com', '0771.229.345', 7, 1068);
insert into angajat
values(seq_cod_angajat.nextval, 'Banu', 'Codrin', 'codrin.banu@gmail.com', '0741.721.921', 9, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Crivat', 'Gheorghe', 'gheo.crivat@gmail.com', null, 8, 1102);
insert into angajat
values(seq_cod_angajat.nextval, 'Stan', 'Elena', 'elena.stan@gmail.com', '0789.123.433', 10, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Pitco', 'Natanael', 'nate.pitco@gmail.com', null, 7, 1136);
insert into angajat
values(seq_cod_angajat.nextval, 'Florea', 'Ana', 'ana.florea@gmail.com', null, 8, 1136);
insert into angajat
values(seq_cod_angajat.nextval, 'Nistor', 'Viviana', 'viv.nistor@gmail.com', '0712.385.763', 6, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Leona', 'Antonia', 'anto.leona@gmail.com', '0711.332.454', 12, 1187);
insert into angajat
values(seq_cod_angajat.nextval, 'Nils', 'Corina', 'corina.nils@gmail.com', null, 8, 1187);
insert into angajat
values(seq_cod_angajat.nextval, 'Petre', 'Cosmin', 'cosmin.petre@gmail.com', '0718.223.344', 10, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Popa', 'Maria', 'maria.popa@yahoo.com', '0792.233.211', 8, null);
insert into angajat
values(seq_cod_angajat.nextval, 'Dumitran', 'George', 'george.dumi@gmail.com', '0793.557.876', 9, null);


select * from angajat;

insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema City', 105, 'Park Lake', '031.403.2700', 'cin.city.pklk@yahoo.com', '2 may 2016');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Movieplex', 110, 'Plaza', '021.431.0000', 'movieplex.buc@yahoo.com', '23 june 2010');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema Arta Sibiu', 120, null, '0734.566.932', 'cin.arta.sibiu@yahoo.com', '27 december 2008');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema City', 125, 'Iulius Mall', '031.413.0400', 'cin.city.ilm@yahoo.com', '16 april 2014');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema Victoria', 130, null, '0232.268.012', 'cin.victoria.is@yahoo.com', '4 july 2015');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema City', 135, null, null, 'cin.city.ct@yahoo.com', '17 october 2018');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema Victoria', 140, null, '0744.338.939', 'c.victoria.cjn@yahoo.com', '30 august 2009');
insert into cinematograf
values(seq_cod_cinema.nextval, 'Cinema City', 145, null, '0362.403.030', 'cin.city.bm@yahoo.com', '7 may 2016');

select * from cinematograf;


insert into lucreaza
values(120, 1000, 'MAN', '3 june 2018', null, 6023.5);
insert into lucreaza
values(120, 1017, 'AG_C', '3 may 2017', '13 june 2019', null);
insert into lucreaza
values(120, 1034, 'CAS', '27 january 2020', null, 4672.5);
insert into lucreaza
values(120, 1051, 'CAS', '12 april 2021', null, 3972.5);
insert into lucreaza
values(140, 1068, 'MAN', '5 september 2017', null, 5998.8);
insert into lucreaza
values(140, 1085, 'PLAS', '17 july 2021', '19 november 2019', null);
insert into lucreaza
values(180, 1102, 'MAN', '21 december 2018', null, 5772.6);
insert into lucreaza
values(180, 1119, 'ING_S', '13 february 2019', null, 4129.7);
insert into lucreaza
values(240, 1136, 'MAN', '9 july 2020', null, 5972.5);
insert into lucreaza
values(240, 1153, 'ING_T', '12 april 2022', null, 3472.5);
insert into lucreaza
values(240, 1170, 'BAR_C', '24 october 2021', null,  2121.3);
insert into lucreaza
values(160, 1187, 'MAN', '1 march 2019', null, 6100.5);
insert into lucreaza
values(160, 1204, 'BAR', '7 november 2020', '12 may 2022', null);
insert into lucreaza
values(160, 1221, 'ING_S', '26 june 2021', null, 5972.5);
insert into lucreaza
values(200, 1238, 'MAN', '2 may 2018', null, 6191.0);
insert into lucreaza
values(220, 1255, 'MAN', '15 may 2017', null, 6132.1);
insert into lucreaza
values(260, 1289, 'MAN', '19 november 2018', null, 5789.1);


select * from lucreaza;


insert into sala
values(seq_nr_sala.nextval, 120, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 120, 'Multiplex');
insert into sala
values(seq_nr_sala.nextval, 120, 'Megaplex');
insert into sala
values(seq_nr_sala.nextval, 140, 'Multiplex');
insert into sala
values(seq_nr_sala.nextval, 160, 'Complex');
insert into sala
values(seq_nr_sala.nextval, 160, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 180, 'Megaplex');
insert into sala
values(seq_nr_sala.nextval, 200, 'Multiplex');
insert into sala
values(seq_nr_sala.nextval, 240, 'Complex');
insert into sala
values(seq_nr_sala.nextval, 220, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 220, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 200, 'Megaplex');
insert into sala
values(seq_nr_sala.nextval, 260, 'Multiplex');
insert into sala
values(seq_nr_sala.nextval, 260, 'Complex');
insert into sala
values(seq_nr_sala.nextval, 140, 'Complex');
insert into sala
values(seq_nr_sala.nextval, 200, 'Complex');
insert into sala
values(seq_nr_sala.nextval, 120, 'Megaplex');
insert into sala
values(seq_nr_sala.nextval, 120, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 260, 'VIP');
insert into sala
values(seq_nr_sala.nextval, 220, 'Multiplex');

select * from sala;


insert into film
values(seq_cod_film.nextval, 'Uncharted', 'Actiune', 116, 6.4, 2022);
insert into film
values(seq_cod_film.nextval, 'Spiderman: No Way Home', 'Actiune', 148, 8.4, 2021);
insert into film
values(seq_cod_film.nextval, 'Free Guy', 'Actiune, Comedie', 115, 7.1, 2021);
insert into film
values(seq_cod_film.nextval, 'Little Women', 'Romance, Drama', 135, 7.8, 2019);
insert into film
values(seq_cod_film.nextval, 'It', 'Horror', 135, 7.4, 2017);
insert into film
values(seq_cod_film.nextval, 'Encanto', 'Animatie', 109, 7.8, 2021);
insert into film
values(seq_cod_film.nextval, 'Star Wars: Episode III', 'S.F.', 140, 7.6, 2005);
insert into film
values(seq_cod_film.nextval, 'Black Widow', 'Actiune', 134, 6.4, 2021);
insert into film
values(seq_cod_film.nextval, 'Titanic', 'Romance, Drama', 194, 7.9, 1997);
insert into film
values(seq_cod_film.nextval, 'The Batman', 'Actiune, Crima', 176, 8.0, 2022);
insert into film
values(seq_cod_film.nextval, 'Red Notice', 'Actiune, Comedie', 118, 6.3, 2021);
insert into film
values(seq_cod_film.nextval, 'Venom', 'Actiune, Horror', 112, 7.9, 2018);
insert into film
values(seq_cod_film.nextval, 'Crimson Peak', 'Horror, Mister', 119, 7.0, 2015);
insert into film
values(seq_cod_film.nextval, 'Yes Day', 'Comedie, Familie', 146, 5.7, 2021);
insert into film
values(seq_cod_film.nextval, 'Zootopia', 'Animatie', 108, 8.5, 2016);
insert into film
values(seq_cod_film.nextval, 'Doctor Strange', 'Actiune, S.F.', 116, 7.5, 2016);
insert into film
values(seq_cod_film.nextval, 'It chapter 2', 'Horror', 169, 6.5, 2019);
insert into film
values(seq_cod_film.nextval, 'Death on the Nile', 'Crima, Mister', 127, 6.9, 2022);
insert into film
values(seq_cod_film.nextval, 'Sherlock Holmes', 'Crima, Mister', 128, 8.6, 2009);
insert into film
values(seq_cod_film.nextval, 'Divergent', 'Romance, S.F.', 140, 8.1, 2014);

select * from film;


insert into ruleaza
values(seq_cod_ruleaza.nextval, 120, 10, '2 march 2022', '13 may 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 120, 1210, '21 june 2018', '13 january 2019');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 140, 1110, '17 july 2020', '23 november 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 180, 1110, '17 july 2020', '23 november 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 200, 810, '15 april 2018', '19 may 2019');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 200, 410, '5 september 2017', '16 december 2017');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 200, 1610, '15 november 2019', '8 february 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 160, 1610, '15 november 2019', '8 february 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 140, 710, '28 may 2021', '13 october 2021');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 180, 1210, '23 december 2015', '27 may 2016');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 180, 510, '1 january 2022', '23 april 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 220, 910, '15 march 2022', '23 july 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 220, 1710, '15 april 2022', '3 september 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 200, 610, '5 june 2015', '18 august 2015');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 240, 610, '6 june 2015', '18 september 2015');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 160, 1310, '6 april 2021', '14 november 2021');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 120, 1610, '15 november 2019', '8 february 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 200, 710, '28 may 2021', '13 october 2021');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 240, 1210, '23 december 2015', '27 may 2016');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 240, 510, '1 january 2022', '23 april 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 260, 1510, '19 may 2017', '21 december 2017');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 260, 310, '15 august 2019', '5 january 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 120, 310, '15 august 2019', '5 january 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 160, 310, '16 august 2019', '5 january 2020');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 220, 1010, '15 september 2021', '14 february 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 240, 1010, '17 september 2021', '14 february 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 120, 1010, '16 september 2021', '11 february 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 140, 1310, '6 april 2021', '14 november 2021');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 140, 110, '16 december 2021', '14 february 2022');
insert into ruleaza
values(seq_cod_ruleaza.nextval, 160, 210, '6 july 2021', '19 october 2021');

select * from ruleaza;



insert into difuzare
values(seq_cod_difuzare.nextval, 10, 1, 120, '3 april 2022', 19);
insert into difuzare
values(seq_cod_difuzare.nextval, 1210, 7, 120, '9 july 2018', 12);
insert into difuzare
values(seq_cod_difuzare.nextval, 710, 10, 140, '5 august 2021', 15);
insert into difuzare
values(seq_cod_difuzare.nextval, 1510, 37, 260, '19 may 2017', 9);
insert into difuzare
values(seq_cod_difuzare.nextval, 1110, 4, 140, '3 august 2022', 10);
insert into difuzare
values(seq_cod_difuzare.nextval, 1010, 28, 220, '19 december 2018', 11);
insert into difuzare
values(seq_cod_difuzare.nextval, 610, 34, 200, '18 august 2015', 14);
insert into difuzare
values(seq_cod_difuzare.nextval, 410, 22, 200, '15 november 2017', 9);
insert into difuzare
values(seq_cod_difuzare.nextval, 1310, 16, 160, '9 july 2021', 19);
insert into difuzare
values(seq_cod_difuzare.nextval, 1610, 16, 160, '9 july 2018', 22);
insert into difuzare
values(seq_cod_difuzare.nextval, 1010, 25, 240, '18 september 2021', 11);
insert into difuzare
values(seq_cod_difuzare.nextval, 1210, 25, 240, '1 march 2016', 18);
insert into difuzare
values(seq_cod_difuzare.nextval, 910, 28, 220, '3 july 2022', 17);
insert into difuzare
values(seq_cod_difuzare.nextval, 1210, 4, 120, '7 october 2018', 11);
insert into difuzare
values(seq_cod_difuzare.nextval, 710, 7, 200, '27 june 2021', 16);
insert into difuzare
values(seq_cod_difuzare.nextval, 1510, 40, 260, '7 august 2017', 12);
insert into difuzare
values(seq_cod_difuzare.nextval, 1710, 31, 220, '1 september 2022', 13);
insert into difuzare
values(seq_cod_difuzare.nextval, 1310, 10, 140, '6 june 2021', 22);
insert into difuzare
values(seq_cod_difuzare.nextval, 510, 19, 180, '2 february 2022', 19);
insert into difuzare
values(seq_cod_difuzare.nextval, 1210, 19, 180, '2 february 2022', 12);


insert into bilet
values(seq_cod_bilet.nextval, 17.1, 17, 3, 50);
insert into bilet
values(seq_cod_bilet.nextval, 22.5, 1, 1, 386);
insert into bilet
values(seq_cod_bilet.nextval, 18.6, 78, 10, 323);
insert into bilet
values(seq_cod_bilet.nextval, 36.9, 22, 5, 491);
insert into bilet
values(seq_cod_bilet.nextval, 0.0, 15, 2, 491);
insert into bilet
values(seq_cod_bilet.nextval, 24.3, 98, 14, 113);
insert into bilet
values(seq_cod_bilet.nextval, 22.5, 56, 4, 176);
insert into bilet
values(seq_cod_bilet.nextval, 40.1, 27, 3, 92);
insert into bilet
values(seq_cod_bilet.nextval, 10.4, 61, 7, 260);
insert into bilet
values(seq_cod_bilet.nextval, 12.2, 15, 3, 407);

select * from bilet;


insert into actor
values(seq_id_actor.nextval, 'Zendaya', null, 'SUA', 22, 2009, 67898.9);
insert into actor
values(seq_id_actor.nextval, 'Tom', 'Holland', 'EN', 7, 2008, 55118.3);
insert into actor
values(seq_id_actor.nextval, 'Ryan', 'Reynolds', 'CA', 9, 1991, 82658.5);
insert into actor
values(seq_id_actor.nextval, 'Emma', 'Watson', 'EN', 24, 2001, 72628.4);
insert into actor
values(seq_id_actor.nextval, 'Finn', 'Wolfhard', 'CA', 3, 2017, 32267.9);
insert into actor
values(seq_id_actor.nextval, 'Gal', 'Gadot', 'IL', 3, 2004, 56118.3);
insert into actor
values(seq_id_actor.nextval, 'Robert', 'Downey Jr', 'SUA', 29, 1970, 89658.5);
insert into actor
values(seq_id_actor.nextval, 'Robert', 'Pattinson', 'EN', 30, 2005, 76228.4);

select * from actor;


insert into joaca
values(seq_cod_joaca.nextval, 10, 10, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 110, 10, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 410, 70, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 1610, 70, 'secundar');
insert into joaca
values(seq_cod_joaca.nextval, 210, 40, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 1010, 40, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 310, 55, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 110, 25, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 910, 115, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 1710, 85, 'principal');
insert into joaca
values(seq_cod_joaca.nextval, 1810, 100, 'principal');

select * from joaca;


insert into regizor
values(seq_id_regizor.nextval, 'Jon', 'Watts', 'SUA', 0);
insert into regizor
values(seq_id_regizor.nextval, 'Shawn', 'Levy', 'CA', 0);
insert into regizor
values(seq_id_regizor.nextval, 'Matt', 'Reeves', 'SUA', 1);
insert into regizor
values(seq_id_regizor.nextval, 'Greta', 'Gerwig', 'SUA', 6);
insert into regizor
values(seq_id_regizor.nextval, 'George', 'Lucas', 'SUA', 7);
insert into regizor
values(seq_id_regizor.nextval, 'Ruben', 'Fleischer', 'SUA', 0);
insert into regizor
values(seq_id_regizor.nextval, 'Andy', 'Muschietti', 'AR', 0);
insert into regizor
values(seq_id_regizor.nextval, 'Kenneth', 'Branagh', 'EN', 22);
insert into regizor
values(seq_id_regizor.nextval, 'Guy', 'Ritchie', 'EN', 5);
insert into regizor
values(seq_id_regizor.nextval, 'Andy', 'Serkis', 'EN', 8);

select * from regizor;


insert into indruma
values(1110, 210, 2017);
insert into indruma
values(1110, 130, 2017);
insert into indruma
values(610, 110, 2003);
insert into indruma
values(110, 30, 2020);
insert into indruma
values(210, 50, 2020);
insert into indruma
values(910, 70, 2021);
insert into indruma
values(310, 90, 2017);
insert into indruma
values(10, 130, 2021);
insert into indruma
values(410, 150, 2015);
insert into indruma
values(1610, 150, 2017);
insert into indruma
values(1710, 170, 2020);
insert into indruma
values(1810, 190, 2008);

select * from indruma;


commit;