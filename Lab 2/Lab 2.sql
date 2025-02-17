-- create a new version of the three tables
-- which you can call TwinsPlayerList2, TwinsBatting2, and TwinsFielding2.
-- You should create these by creating queries
-- on the relations master, batting, and fielding
-- Extra fields in batting anf fielding
-- Need to specify fields directly
-- Only need stuff from Twins from 2010 to 2015
-- all data for playerlist is in master
-- create table as (query)
--

select * from public.master;
select * from public.batting where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN';
select * from public.fielding;

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

select playerid
from pratt440.TwinsBatting2
where playerid = 'achteaj01';
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
-- TwinsFielding2

drop table pratt440.TwinsBatting2;