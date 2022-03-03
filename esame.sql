drop schema if exists ippica cascade;
create schema ippica;
set search_path to ippica;

create table fantino(
 nome varchar primary key,
 eta integer check (eta>17));

create table cavallo(
nome varchar primary key,
eta integer,
scuderia varchar);

create table coppia(
pettorale integer check (pettorale between 1 and 20),
nazione varchar,
fantino varchar references fantino(nome) on delete cascade,
cavallo varchar references cavallo(nome) on delete cascade,
unique(fantino,cavallo),
primary key(pettorale,nazione));

create table gara(
giorno date primary key,
ippodromo varchar,
vinc_pett integer,
vinc_naz varchar,
	foreign key(vinc_pett,vinc_naz) references coppia(pettorale,nazione) on delete cascade);

insert into fantino values('Simone',25);
insert into fantino values('Luca',30);
insert into fantino values('Michele',31);


insert into cavallo values('Berry',8,'Bianchi');
insert into cavallo values('Rock',9,'Bianchi');
insert into cavallo values('Thor',12,'Bianchi');
insert into cavallo values('Split',12,'Rossi');
insert into cavallo values('Wolverine',12,'Verdi');
insert into cavallo values('Iron',10,'Verdi');


insert into coppia values(1,'Italia','Simone','Berry');
insert into coppia values(3,'Italia','Simone','Iron');
insert into coppia values(5,'Italia','Simone', 'Wolverine');
insert into coppia values(6,'Italia','Simone', 'Split');
insert into coppia values(7,'Italia','Michele', 'Iron');
insert into coppia values(8,'Italia','Luca', 'Split');
insert into coppia values(4,'Francia','Michele','Split');
insert into coppia values(6,'Germania','Michele','Wolverine');


insert into gara values('1/06/2016','Capannelle',1,'Italia');
insert into gara values('2/07/2016','asd',4,'Francia');
insert into gara values('3/08/2016','Capannelle',6,'Germania');

\echo il nome e l eta dei fantini che non hanno partecipato ad alcna gara ossia fatto parte di una coppia di gara

select f.nome, f.eta from fantino as f 
EXCEPT select f.nome, f.eta from fantino as f, coppia as c where f.nome=c.fantino;

\echo numero di partecipanti di ciascuna nazione che gareggi con almeno due fantini


select nazione, count(distinct fantino) from fantino,coppia
where fantino.nome=coppia.fantino group by nazione having count(distinct fantino)>1;

\echo i fantini che durante la loro cariera hanno gareggiato con almeno un cavallo per ogni scuderia memorizzata nella base di dati

create view v as select * from coppia,cavallo where cavallo=nome;

select distinct x.fantino from v as x where not exists(select * from cavallo as y where not exists ( select * from v as z where x.fantino=z.fantino and y.scuderia=z.scuderia));


CREATE TABLE ippodromo (
	nome varchar PRIMARY KEY,
	capienza INTEGER ,
	citta VARCHAR,
	nazione VARCHAR);

alter table gara add column spettatori integer;
	
insert into ippodromo values('ads',10,'Verona','Italia');
insert into ippodromo values('Capannelle',40,'Parigi','Francia');
insert into ippodromo values('Vittorio',60,'Spagna','Madrid');



CREATE FUNCTION vincola_num_spettatori() RETURNS TRIGGER AS $BODY$

DECLARE
a INTEGER;
BEGIN

SELECT capienza INTO a FROM ippodromo WHERE nome=NEW.ippodromo;
IF a<NEW.spettatori THEN
RAISE EXCEPTION $$ Numero spettatori maggiore della capienza $$;
END IF;
RETURN NEW;
END;
$BODY$
LANGUAGE PLPGSQL;

CREATE TRIGGER trigger_num_spettatori BEFORE INSERT OR UPDATE ON gara
 FOR EACH ROW EXECUTE PROCEDURE vincola_num_spettatori();


