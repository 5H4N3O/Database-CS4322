/********** PART 1 **********/

/** 1 **
Write queries to calculate the sum of ABs, Rs, Hs, HRs, and RBIs
for every Twins player in the mlb.batting table. */
select teamid, sum(AB) as absum, sum(R) as rsum,
       sum(H) as hsum, sum(HR) as hrsum, sum(RBI) as rbisum
from public.batting b
where b.teamid = 'MIN'
group by teamid;

/** 2 **
For each of the statistics R, H, HR, and RBI
calculate the average number of each produced per AB.
So, for example, avgR = (total Rs / total ABs). */
select (rsum/absum) as ravg, (hsum/absum) as havg,
       (hrsum/absum) as hravg, (rbisum/absum) as rbiavg
from(
    select
           cast(sum(AB) as decimal) as absum,
           cast(sum(R) as decimal) as rsum,
           cast(sum(H) as decimal) as hsum,
           cast(sum(HR) as decimal) as hrsum,
           cast(sum(RBI) as decimal) as rbisum
    from public.batting b
    where b.teamid = 'MIN'
    group by teamid
    )sq;

create table pratt440.avgperab as
select (rsum/absum) as ravg, (hsum/absum) as havg,
       (hrsum/absum) as hravg, (rbisum/absum) as rbiavg
from(
    select
           cast(sum(AB) as decimal) as absum,
           cast(sum(R) as decimal) as rsum,
           cast(sum(H) as decimal) as hsum,
           cast(sum(HR) as decimal) as hrsum,
           cast(sum(RBI) as decimal) as rbisum
    from public.batting b
    where b.teamid = 'MIN'
    group by teamid
    )sq;
select * from pratt440.avgperab;
drop table pratt440.avgperab;

/** 3 **
For each individual Twins player calculate their total
ABs, Rs, Hs, HRs, and RBIs for their career. */
select playerid, sum(AB) as absum, sum(R) as rsum,
       sum(H) as hsum, sum(HR) as hrsum, sum(RBI) as rbisum
from public.batting b
where b.teamid = 'MIN'
group by playerid;

/** 4 **
Using the statistics from item 3 calculate the "marginal"
Rs, Hs, HRs, and RBIs for each player for their career.
For example, for the player Kent Hrbek:
MarginalRs(KentHrbek) = TotalRs(KentHrbek) - TotalABs(KentHrbek) * AvgRsPerABTwins
MarginalHs(KentHrbek) = TotalHs(KentHrbek) - TotalABs(KentHrbek) * AvgHsPerABTwins
MarginalHRs(KentHrbek) = TotalHRs(KentHrbek) - TotalABs(KentHrbek) * AvgHRsPerABTwins
MarginalRBIs(KentHrbek) = TotalRBIs(KentHrbek) - TotalABs(KentHrbek) * AvgRBIsPerABTwins */
select playerid,
       (rsum-absum*a.ravg) as MarginalRs,
       (hsum-absum*a.havg) as MarginalHs,
       (hrsum-absum*a.hravg) as MarginalHRs,
       (rbisum-absum*a.rbiavg) as MarginalRBIs
from avgperab a,
    (
    select playerid, sum(AB) as absum, sum(R) as rsum,
       sum(H) as hsum, sum(HR) as hrsum, sum(RBI) as rbisum
    from public.batting b
    where b.teamid = 'MIN'
    group by playerid
    )sq;

create table pratt440.marginals as
    select playerid,
       (rsum-absum*a.ravg) as MarginalRs,
       (hsum-absum*a.havg) as MarginalHs,
       (hrsum-absum*a.hravg) as MarginalHRs,
       (rbisum-absum*a.rbiavg) as MarginalRBIs
from avgperab a,
    (
    select playerid, sum(AB) as absum, sum(R) as rsum,
       sum(H) as hsum, sum(HR) as hrsum, sum(RBI) as rbisum
    from public.batting b
    where b.teamid = 'MIN'
    group by playerid
    )sq;
select * from pratt440.marginals;
drop table pratt440.marginals;

/** 5 **
Show the player with the highest and lowest numbers of each of
the four marginal values calculated in part 4. */
select
    m.playerid as rmax,
    m2.playerid as rmin,
    m3.playerid as hmax,
    m4.playerid as hmin,
    m5.playerid as hrmax,
    m6.playerid as hrmin,
    m7.playerid as rbimax,
    m8.playerid as rbimin
from
    marginals m,
    marginals m2,
    marginals m3,
    marginals m4,
    marginals m5,
    marginals m6,
    marginals m7,
    marginals m8,
    (
    select
        max(MarginalRs) as rhigh,
        max(MarginalHs) as hhigh,
        max(MarginalHRs) as hrhigh,
        max(MarginalRBIs) as rbihigh,
        min(MarginalRs) as rlow,
        min(MarginalHs) as hlow,
        min(MarginalHRs) as hrlow,
        min(MarginalRBIs) as rbilow
    from marginals m
    )sq
where (m.playerid,m.marginalrs) = (m.playerid,rhigh) and
      (m2.playerid,m2.marginalrs) = (m2.playerid,rlow) and
      (m3.playerid,m3.marginalhs) = (m3.playerid,hhigh) and
      (m4.playerid,m4.marginalhs) = (m4.playerid,hlow) and
      (m5.playerid,m5.marginalhrs) = (m5.playerid,hrhigh) and
      (m6.playerid,m6.marginalhrs) = (m6.playerid,hrlow) and
      (m7.playerid,m7.marginalrbis) = (m7.playerid,rbihigh) and
      (m8.playerid,m8.marginalrbis) = (m8.playerid,rbilow);

select * from pratt440.marginals
         where playerid='knoblch01' or
               playerid='thompda01' or
               playerid='carewro01' or
               playerid='laudnti01' or
               playerid='killeha01' or
               playerid='tovarce01';

/********** PART 2 **********
Write two triggers. One should be triggered upon an insert into the master table
that automatically inserts a tuple into both the hitting and pitching tables with
Twins set as the team and 0 values for all of the other entries in each table.
Then set up a trigger that is invoked when a player is deleted from the master table
that removes any corresponding records in the hitting and pitching tables. */

-- Insert trigger
create trigger insertmaster
after insert on pratt440.master
for each row execute function pratt440.autoinsert();

create function pratt440.autoinsert()
returns trigger as $$
begin
    insert into pratt440.batting(playerid, yearid, stint, teamid, lgid, g, ab, r, h, db, tr, hr, rbi, sb, cs, bb, so, ibb, hbp, sh, sf, gidp)
    select new.playerid,0,0,'MIN',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ;
    insert into pratt440.fielding(playerid, yearid, stint, teamid, lgid, pos, g, gs, innouts, po, a, e, dp, pb, wp, sb, cs, zr)
    select new.playerid,0,0,n'MIN',0,0,0,0,0,0,0,0,0,0,0,0,0,0
    ;
    return new;
end;
$$ language plpgsql;

drop function pratt440.autoinsert();
drop trigger insertmaster on pratt440.master;

-- Delete trigger
create trigger deletemaster
after delete on pratt440.master
for each row execute function pratt440.autodelete();

create function pratt440.autodelete()
returns trigger as $$
begin
    delete from pratt440.batting
    where playerid = old.playerid;

    delete from pratt440.fielding
    where playerid = old.playerid;

    return old;
end;
$$ language plpgsql;

drop function pratt440.autodelete();
drop trigger deletemaster on pratt440.master;

select * from pratt440.master where playerid = 'Shane';
select * from pratt440.batting where playerid = 'Shane';
select * from pratt440.fielding where playerid = 'Shane';

delete from pratt440.master where playerid = 'Shane';

insert into pratt440.master(playerid)
values ('Shane');