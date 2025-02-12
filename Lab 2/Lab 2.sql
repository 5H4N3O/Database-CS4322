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

create table pratt440.test();

create table pratt440.TwinsBatting2 as
    select playerid
    from public.batting
    where yearid < 2010
    ;

select * from pratt440.TwinsBatting2;