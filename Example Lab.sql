-- create table for twinsdata

select * from twinsdata;

create table Demo(
PlayerID varchar(50) primary key,
namelast varchar(50),
namefirst varchar(50)
);

insert into Demo(PlayerID, namelast, namefirst)
select distinct playerid, namelast, namefirst from twinsdata; --distinct playerid cuts out all the dupes

select * from Demo;

drop table Demo;

-- dont need distinct for 2nd and 3rd table