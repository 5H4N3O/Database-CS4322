/** 1 **
For each student, show their first and last name and
the number of credits for courses they passed (did not receive an F or W). */

select s.firstname, s.lastname, sum(c.numcredits) as numcredits
from student s, course c, takes t
where c.cid = t.cid and s.sid = t.sid and t.grade != 'F' and t.grade != 'W'
group by (s.firstname, s.lastname);


/** 2 **
For each student, write a query to show for each student their first and last name and their GPA.
The GPA is the sum of their:
grade values (from that table) for each class grade times the number of credits for that class
(except that Ws are not included) divided by the total number of non-W credits the student has.
For this version of the query you may assume that each student has taken a course only once. */

select firstname, lastname, gpa
from
    (
    select s.sid, s.firstname, s.lastname, sum((g.value*c.numcredits))/sum(c.numcredits) as gpa
    from student s, course c, takes t, gradevalue g
    where c.cid = t.cid and s.sid = t.sid and g.grade = t.grade and t.grade != 'W'
    group by (s.sid, s.firstname, s.lastname)
    )sq;
-- Still want to group by (sid, firstname, lastname) in subquery in case there are students with
-- the same first and last names


/** 3 **
Redo query 2, but where students may have taken a course multiple times.
Your query should calculate the GPA using the most recent non-W grade for a course that the student has taken.
You may assume that semester is an integer value that increases in later semesters
(so if you compare two semester values the larger semester value is a more recent semester). */

select firstname, lastname, gpa
from
    (
    select s.sid, s.firstname, s.lastname, sum((g.value*c.numcredits))/sum(c.numcredits) as gpa
    from student s, course c, takes t, gradevalue g
    where c.cid = t.cid and s.sid = t.sid and g.grade = t.grade and t.grade != 'W' and (t.sid, t.cid, t.semester) in
        (
        select sid, cid, max(semester)
        from takes
        group by sid, cid
        )
    group by (s.sid, s.firstname, s.lastname)
    )sq;
-- Subquery now makes sure that the tuple (sid, cid, semester) is within the relation
-- of all classes a student has taken with the max semester value available for each class
-- (Checks that the chosen class is the most recent semester in which the student has taken the class)


/** 4 **
For each course report the DeptName and CourseNumber for that course
as well as the average grade received ignoring W grades and the average grade received ignoring W and F grades.
Note that you need to make sure that there is at least one student who got a qualifying grade to report these numbers. */

select c.deptname, c.coursenumber, avg(case when t.grade != 'W' then g.value else null end) as avgnotw,
       avg(case when t.grade != 'W' and t.grade != 'F' then g.value else null end) as avgnotwnotf
from course c, takes t, gradevalue g
where c.cid=t.cid and t.grade = g.grade
group by c.deptname, c.coursenumber;


/** 5 **
For each course report the DeptName and CourseNumber and the total enrollment by semester.
For each semester also calculate the DFW rate which is the percentage of students in a semester who a grade of D+, D, F, or W.
Report the courses sorted from highest DFW rate to lowest. */

select deptname, coursenumber, semester, enrolled, (cast(dfwsum as decimal)/cast(enrolled as decimal)) as dfwrate
from
     (
     select c.deptname, c.coursenumber, t.semester, count(distinct(t.sid)) as enrolled,
            sum(case when t.grade in ('D+', 'D', 'F', 'W') then 1 else 0 end) as dfwsum
     from course c, takes t, gradevalue g
     where c.cid=t.cid and t.grade = g.grade
     group by c.deptname, c.coursenumber, t.semester
     )sq
order by dfwrate desc;