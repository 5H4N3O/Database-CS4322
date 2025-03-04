/********** PART 1 **********/

/** 1 **
Write queries to calculate the sum of ABs, Rs, Hs, HRs, and RBIs
for every Twins player in the mlb.batting table. */

/** 2 **
For each of the statistics R, H, HR, and RBI
calculate the average number of each produced per AB.
So, for example, avgR = (total Rs / total ABs). */

/** 3 **
For each individual Twins player calculate their total
ABs, Rs, Hs, HRs, and RBIs for their career. */

/** 4 **
Using the statistics from item 3 calculate the "marginal"
Rs, Hs, HRs, and RBIs for each player for their career.
For example, for the player Kent Hrbek:
MarginalRs(KentHrbek) = TotalRs(KentHrbek) - TotalABs(KentHrbek) * AvgRsPerABTwins
MarginalHs(KentHrbek) = TotalHs(KentHrbek) - TotalABs(KentHrbek) * AvgHsPerABTwins
MarginalHRs(KentHrbek) = TotalHRs(KentHrbek) - TotalABs(KentHrbek) * AvgHRsPerABTwins
MarginalRBIs(KentHrbek) = TotalRBIs(KentHrbek) - TotalABs(KentHrbek) * AvgRBIsPerABTwins */

/** 5 **
Show the player with the highest and lowest numbers of each of
the four marginal values calculated in part 4. */

/********** PART 2 **********
Write two triggers. One should be triggered upon an insert into the master table
that automatically inserts a tuple into both the hitting and pitching tables with
Twins set as the team and 0 values for all of the other entries in each table.
Then set up a trigger that is invoked when a player is deleted from the master table
that removes any corresponding records in the hitting and pitching tables. */