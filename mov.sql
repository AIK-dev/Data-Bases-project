-- Напишете заявка, която извежда име на актьор,
-- адрес на актьор и заглавие на филм,
-- за тези филми създадени
-- след 1990 г. и име на актьор започващо с ‘J’.


set schema DB2MOVIES;



select STUDIONAME,TITLE,LENGTH
    from MOVIE m
where LENGTH>=(select max(LENGTH)
    from MOVIE where STUDIONAME=m.STUDIONAME)
group by STUDIONAME, TITLE, LENGTH;

select studioname, title, length
from movie m
where length >= (select max(length)
		     from movie
		     where studioname=m.studioname);

select studioname, title, length
from movie m
where length >=all (select length
		     from movie
		     where studioname=m.studioname);

set schema DB2PC;

set schema Db2pc;

select decimal(avg(price), 9, 2) as AvgPrice
from pc
group by speed;

set schema  DB2SHIPS;
select count(*) from SHIPS
    order by CLASS;



select p.maker, count(p.model) as CNT
from pc join product p on p.model=pc.model
group by p.maker
having count(p.model)>=3;

select maker, t.price
from
(
select p.maker, max(price) price
from pc join product p on p.model=pc.model
where p.type='PC'
group by p.maker
)T
where t.price >= all(select price from
(
select p.maker, max(price) price
from pc join product p on p.model=pc.model
where p.type='PC'
group by p.maker
)T);

select avg(PRICE) from
pc join PRODUCT on PC.MODEL = PRODUCT.MODEL
where SPEED>800
group by SPEED;

select speed, decimal(avg(price), 9, 2) as AvgPrice
from pc
where speed > 800
group by speed;

set schema DB2SHIPS;

select SHIPS.CLASS, count(*) from
CLASSES,SHIPS,OUTCOMES
where SHIPS.CLASS=CLASSES.CLASS
and OUTCOMES.SHIP=SHIPS.NAME
and OUTCOMES.RESULT='sunk'
group by SHIPS.CLASS;

select class, count(o.ship)
from ships s join outcomes o on s.name=o.ship
where o.result='sunk'
group by class
having count(*)>=2;

set schema DB2MOVIES;

select name,title
from MOVIE,MOVIEEXEC
where PRODUCERC#=CERT#
and CERT# in (
    select CERT# from
    MOVIEEXEC, MOVIE,STARSIN
where TITLE=MOVIETITLE
    and YEAR=MOVIEYEAR
    and CERT#=PRODUCERC#
    and STARNAME='Harrison Ford'
    );

select distinct me.name
from movie m join starsin s
on m.title=s.movietitle and m.year=s.movieyear
join movieexec me on m.producerc#=me.cert#
where starname='Harrison Ford';

set schema DB2PC;

select pc.model,   from pc
join product p on pc.model=p.model
group by pc.model, p.maker
having avg(price) < (select min(price) from laptop
	join product t
	on laptop.model=t.model
	where t.maker=p.maker);

select p.maker,pc1.PRICE from PRODUCT p
join pc pc1 on p.MODEL = pc1.MODEL
where pc1.PRICE>=(select max(pc3.price)
    from pc pc3 )

set schema ships;
set schema DB2SHIPS;
select distinct name, class
from ships
where class in
(
select class
from classes
where bore=16
);

select battle
from outcomes
where ship in
(select name
 from ships
 where class = 'Kongo');

select name from SHIPS,CLASSES
where CLASSES.CLASS=SHIPS.CLASS
    and NUMGUNS>= all(select NUMGUNS from
        CLASSES c where c.BORE=Classes.BORE
        and c.CLASS=SHIPS.CLASS
    );

select c1. class, name
from classes c1, ships s
where numguns >= all (select numguns from classes where bore=c1.bore)
and s.class = c1.class
order by c1.class

select distinct country
from classes
where numguns >= all(select numguns from classes);
-- Напишете заявка, която за всяко студио
--  извежда името на студиото и името
--  на филма излязъл последно на екран за това студио.

select STUDIONAME, TITLE, YEAR
from MOVIE
order by STUDIONAME

select STUDIONAME, TITLE
from MOVIE m
where YEAR >= (select max(YEAR)
               from MOVIE
               where m.STUDIONAME = MOVIE.STUDIONAME)

select STARNAME, count(*)
from STARSIN
group by STARNAME;

select MOVIETITLE
from STARSIN
where STARNAME = 'Alec Baldwin';


select STUDIONAME, TITLE, STARNAME
from STARSIN
         join MOVIE M on STARSIN.MOVIETITLE = M.TITLE and STARSIN.MOVIEYEAR = M.YEAr;


select STARNAME
from STARSIN
         join MOVIE M on STARSIN.MOVIETITLE = M.TITLE and STARSIN.MOVIEYEAR = M.YEAR
         join MOVIEEXEC M2 on M.PRODUCERC# = M2.CERT#
where NETWORTH >= all (select NETWORTH
                       from MOVIEEXEC)

select NAME
from MOVIEEXEC
where NETWORTH >= (select max(NETWORTH) from MOVIEEXEC)

select STARNAME
from STARSIN
         join MOVIE M on STARSIN.MOVIETITLE = M.TITLE and STARSIN.MOVIEYEAR = M.YEAR
         join MOVIEEXEC M2 on M.PRODUCERC# = M2.CERT#
where M2.NAME = 'George Lucas';


select name, TITLE
from MOVIEEXEC
         join MOVIE on MOVIEEXEC.CERT# = MOVIE.PRODUCERC#
where title in
      (select Title
       from (select TITLE, count(*) as WomenCount
             from MOVIE
                      join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                      join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
             where GENDER = 'F'
             group by TITLE) T
       where WomenCount >= all
             (select count(*) as WomenCount
              from MOVIE
                       join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                       join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
              where GENDER = 'F'
              group by TITLE));

select STUDIONAME, count(*)
from MOVIE select Name,TITLE
from MOVIEEXEC
    join MOVIE
on MOVIEEXEC.CERT# = MOVIE.PRODUCERC#
order by NAME

select m.TITLE,
       (select TITLE, count(*) as WomenCount
        from MOVIE
                 join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                 join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
        where GENDER = 'F'
          and m.TITLE = MOVIE.TITLE
        group by TITLE)
from MOVIE m



select Title
from (select TITLE, count(*) as WomenCount
      from MOVIE
               join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
               join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
      where GENDER = 'F'
      group by TITLE) T
where WomenCount >= all
      (select count(*) as WomenCount
       from MOVIE
                join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
       where GENDER = 'F'
       group by TITLE);

select TITLE, STARNAME
from MOVIE
         join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
order by TITLE;



select name, TITLE
from MOVIEEXEC
         join MOVIE on MOVIEEXEC.CERT# = MOVIE.PRODUCERC#
where title in
      (select Title
       from (select TITLE, count(*) as WomenCount
             from MOVIE
                      join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                      join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
             where GENDER = 'F'
             group by TITLE) T
       where WomenCount >= all
             (select count(*) as WomenCount
              from MOVIE
                       join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
                       join MOVIESTAR on S.STARNAME = MOVIESTAR.NAME
              where GENDER = 'F'
              group by TITLE));

select STUDIONAME, count(*)
from MOVIE
         join STARSIN S on MOVIE.TITLE = S.MOVIETITLE and MOVIE.YEAR = S.MOVIEYEAR
group by STUDIONAME;

select STARNAME, STUDIONAME, count(*)
from MOVIE
         join STARSIN on MOVIE.TITLE = STARSIN.MOVIETITLE and MOVIE.YEAR = STARSIN.MOVIEYEAR
group by STARNAME, STUDIONAME

select STARNAME, STUDIONAME
from STARSIN
         join MOVIE M on STARSIN.MOVIETITLE = M.TITLE and STARSIN.MOVIEYEAR = M.YEAR
where STUDIONAME in
      (select T.STUDIONAME
       from (select s1.starname, m.STUDIONAME, count(*) as Appearances
             from MOVIE m
                     left join STARSIN s1 on s1.MOVIETITLE = m.TITLE and s1.MOVIEYEAR = m.YEAR
                 and s1.STARNAME = STARNAME
             group by M.STUDIONAME, s1.starname) T
       where Appearances <= all
             (select count(*)
              from MOVIE m2
                       join STARSIN s2 on s2.MOVIEYEAR = m2.YEAR and s2.MOVIETITLE = m2.TITLE
                  and s2.STARNAME = STARNAME
              group by s2.STARNAME,m2.STUDIONAME))
group by STARNAME,STUDIONAME




select s1.starname, m.STUDIONAME, count(*) as Appearances
             from MOVIE m
                     left join STARSIN s1 on s1.MOVIETITLE = m.TITLE and s1.MOVIEYEAR = m.YEAR
                 and s1.STARNAME = STARNAME
             group by M.STUDIONAME, s1.starname

select NAME,STUDIONAME from MOVIESTAR
left join STARSIN S on MOVIESTAR.NAME = S.STARNAME
left join MOVIE M on S.MOVIETITLE = M.TITLE and S.MOVIEYEAR = M.YEAR
where STUDIONAME is null