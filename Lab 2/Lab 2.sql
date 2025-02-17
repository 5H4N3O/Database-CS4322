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
/* 1. Print out the following statistics for each year Kirby Puckett was a batter.
   yearID,g,ab,r,h,db,tr,hr,rbi,sb,cs,bb,HBP,SF */
select * from public.master where namefirst = 'Kirby' and namelast = 'Puckett';
select * from public.batting where playerid = 'puckeki01';
