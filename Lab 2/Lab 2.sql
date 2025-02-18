/*** PART 1:
create a new version of the three tables
which you can call TwinsPlayerList2, TwinsBatting2, and TwinsFielding2.
You should create these by creating queries
on the relations master, batting, and fielding
Extra fields in batting anf fielding
Need to specify fields directly
Only need stuff from Twins from 2010 to 2015
all data for playerlist is in master
create table as (query) ***/

-- TwinsBatting2
create table pratt440.TwinsBatting2 as
    select
        distinct playerid, yearid, stint, ab, r, h,
        db, tr, hr, rbi, sb, cs, bb, so, ibb, hbp
    from public.batting
    where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN';

alter table pratt440.TwinsBatting2
    add primary key (playerid,yearid, stint);

select * from pratt440.TwinsBatting2;
drop table pratt440.TwinsBatting2;
-- TwinsBatting2

-- TwinsFielding2
select cs, sb from public.fielding where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN' and cs is not null;

create table pratt440.TwinsFielding2 as
    select
        distinct playerid, yearid, stint, pos, g,
        innouts, po, a, e, dp, pb, wp, sb, cs
    from public.fielding
    where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN';

alter table pratt440.TwinsFielding2
    add primary key (playerid, yearid, stint, pos);

select * from pratt440.TwinsFielding2;
drop table pratt440.TwinsFielding2;
-- TwinsFielding2

-- TwinsPlayerList2
create table pratt440.TwinsPlayerlist2 as
    select
	    distinct playerid, namelast, namefirst, namegiven, birthyear,
	    birthmonth, birthday, weight, height, bats, throws
    from public.master
    where playerid in(-- Checks if playerid is within TwinsBatting2 or TwinsFielding2
        select F.playerid
        from TwinsFielding2 F
        union
        select B.playerid
        from TwinsBatting2 B);

alter table pratt440.TwinsPlayerlist2
    add primary key (playerid);

select * from pratt440.TwinsPlayerlist2;
drop table pratt440.TwinsPlayerlist2;
-- TwinsPlayerList2

/*** PART 2: ***/
/* 1). Print out the following statistics for each year Kirby Puckett was a batter.
   yearID,g,ab,r,h,db,tr,hr,rbi,sb,cs,bb,HBP,SF */
select * from public.master where namefirst = 'Kirby' and namelast = 'Puckett';
select * from public.batting where playerid = 'puckeki01';

create table pratt440.KPbatting as
    select yearID,g,ab,r,h,db,tr,hr,rbi,sb,cs,bb,HBP,SF
    from public.batting
    /* Need to run a subquery to find KP's playerid from
       the master table using his first and last name,
       since we need the playerid to find players in
       the batting table */
    where playerid = (
        select m.playerid
        from public.master m
        where namefirst = 'Kirby' and namelast = 'Puckett');
select * from pratt440.KPbatting;
drop table pratt440.KPbatting;

/* 2). All of these are counting values,
   write a query that prints a total in each category (but not YEARID) */
select
    sum(g) as  g, sum(ab) as ab, sum(r) as r, sum(h) as h, sum(db) as db,
    sum(tr) as tr, sum(hr) as hr, sum(rbi) as rbi, sum(sb) as sb,
    sum(cs) as cs, sum(bb) as bb, sum(HBP) as HBP, sum(SF) as SF
from KPbatting;

/* 3). The following statistics are defined in terms of the statistics shown in 1).
   Alter your queries in 1) and 2) to include these statistics:
   BA = H / AB
   OBP = (H + BB + HBP) / (AB + BB + HBP + SF)
   SLG = (4 * HR + 3 * TR + 2 * DB + (H - HR - TR - DB)) / AB */

alter table pratt440.KPbatting
    add BA decimal, add OBP decimal, add SLG decimal;

update pratt440.KPbatting
set
    BA = cast(H as decimal)/cast(AB as decimal),

    OBP = (cast(H as decimal) + cast(BB as decimal) + cast(HBP as decimal)) /
	    (cast(AB as decimal) + cast(BB as decimal) + cast(HBP as decimal) + cast(SF as decimal)),

    SLG = (4 * cast(HR as decimal) + 3 * cast(TR as decimal) + 2 * cast(DB as decimal) +
	(cast(H as decimal) - cast(HR as decimal) - cast(TR as decimal) - cast(DB as decimal))) /
	cast(AB as decimal);

select * from pratt440.KPbatting;

select
    sum(g) as  g, sum(ab) as ab, sum(r) as r, sum(h) as h, sum(db) as db,
    sum(tr) as tr, sum(hr) as hr, sum(rbi) as rbi, sum(sb) as sb,
    sum(cs) as cs, sum(bb) as bb, sum(HBP) as HBP, sum(SF) as SF,
    sum(BA) as BA, sum(OBP) as OBP, sum(SLG) as SLG
from KPbatting;

/* 4). Write a query that finds, for all the years Kirby Puckett played,
   the first and last names of the players who had the highest value for BA (for players whose AB >= 50)
   as well as the year they played.  If that player is Kirby Puckett omit that year. */

select b.yearid, m.namefirst, m.namelast
from public.batting b, public.master m
where b.AB >= 50 and b.playerid = m.playerid and b.yearid in(select * from pratt440.KPbatting)
group by b.yearid;