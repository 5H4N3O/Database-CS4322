/* TwinsPlayerList needs to have NAMELAST to THROWS (10),
 * PLAYERID is primary key
 */
create table TwinsPlayerList(
	PlayerID varchar(50) primary key, namelast varchar(50), 
	namefirst varchar(50), namegiven varchar(50), birthyear int,
	birthmonth int, birthday int, weight int, height int, 
	bats varchar(50), throws varchar(50)
);

/* Insert data from twinsdata table columns into twinsplayerlist columns */
insert into TwinsPlayerList
	(PlayerID, namelast, namefirst, namegiven, birthyear, 
	birthmonth, birthday, weight, height, bats, throws)
select 
	distinct playerid, namelast, namefirst, namegiven, birthyear, 
	birthmonth, birthday, weight, height, bats, throws
from twinsdata;


/* TwinsBatting needs to have YEARID to HBP (15),
 * PLAYERID, YEARID and STINT is primary key
 * PLAYERID is a foreign key that refers to TwinsPlayerList
 */
create table TwinsBatting (
	playerid varchar(50) references twinsplayerlist(playerid),
	yearid int, stint int, ab int, r int, h int, db int,
	tr int, hr int, rbi int, sb int, cs int, bb int, so int, ibb int,
	hbp int, primary key (playerid, yearid, stint)
);

insert into TwinsBatting
	(playerid, yearid, stint, ab, r, h, db, tr, hr, rbi, sb, cs, bb, 
	so, ibb, hbp)
select 
	distinct playerid, yearid, stint, ab, r, h, db, tr, hr, rbi, sb, 
	cs, bb, so, ibb, hbp
from twinsdata;

/* Checks keys of a table */
select constraint_name, table_name, column_name, ordinal_position
from information_schema.key_column_usage
where table_name = 'twinsbatting';


/* TwinsFielding needs to have POS to CCS (11),
 * PLAYERID, YEARID, STINT, and POS is primary key
 * PLAYERID is a foreign key that refers to TwinsPlayerList
 */
create table TwinsFielding (
	playerid varchar(50) references twinsplayerlist, yearid int,
	stint int, pos varchar(50), g int, innouts int, po int, a int,
	e int, dp int, pb int, wp varchar(50), csb int, ccs int,
	primary key (playerid, yearid, stint, pos)
);

insert into TwinsFielding
	(playerid, yearid, stint, pos, g, innouts, po, a, e, dp, pb, 
	wp, csb, ccs)
select 
	distinct playerid, yearid, stint, pos, g, innouts, po, a, e, dp, 
	pb, wp, csb, ccs
from twinsdata;

/* Select each table */
select * from twinsdata;
select * from twinsplayerlist;
select * from twinsbatting;
select * from twinsfielding;

/* Drop each table */
drop table twinsplayerlist;
drop table twinsbatting;
drop table twinsfielding;

