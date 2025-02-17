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

create table pratt440.tempMaster as
    select *
    from public.master;
alter table pratt440.tempMaster
add primary key (playerid);

select * from pratt440.tempMaster;
drop table pratt440.tempMaster;

create table pratt440.TwinsBatting2 (
	playerid varchar(50) references pratt440.tempMaster(playerid),
	yearid int, stint int, ab int, r int, h int, db int,
	tr int, hr int, rbi int, sb int, cs int, bb int, so int, ibb int,
	hbp int, primary key (playerid, yearid, stint)
);

insert into pratt440.TwinsBatting2
	(playerid, yearid, stint, ab, r, h, db, tr, hr, rbi, sb, cs, bb,
	so, ibb, hbp)
select
	distinct playerid, yearid, stint, ab, r, h, db, tr, hr, rbi, sb,
	cs, bb, so, ibb, hbp
from public.batting
where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN';

-- create table pratt440.TwinsBatting2 as
--     select
--         distinct playerid, yearid, stint, ab, r, h,
--         db, tr, hr, rbi, sb, cs, bb, so, ibb, hbp
--     from public.batting
--     where yearid >= 2010 and yearid <= 2015 and teamid = 'MIN'
--     ;

select * from pratt440.TwinsBatting2;
drop table pratt440.TwinsBatting2;