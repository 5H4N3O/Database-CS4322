drop table student;
drop table takes;

create table student (
    sid int,
    lastname char(20),
    firstname char(20),
    primary key (sid)
);

create table takes (
    sid int,
    cid int,
    semester int,
    grade char(2),
    primary key (sid, cid, semester)
);

create table course (
    cid int,
    deptname char(20),
    coursenumber int,
    numcredits int,
    coursename char(20),
    primary key (cid)
);

create table gradevalue (
    grade char(2),
    value decimal,
    primary key (grade)
);

insert into gradevalue (grade, value) values
('A', 4.0),
('A-', 3.7),
('B+', 3.3),
('B', 3.0),
('B-', 2.7),
('C+', 2.3),
('C', 2.0),
('C-', 1.7),
('D+', 1.3),
('D', 1.0),
('F', 0.0),
('W', 0.0);

-- Insert data into student table
INSERT INTO student (sid, lastname, firstname) VALUES
(1, 'Smith', 'John'),
(2, 'Doe', 'Jane'),
(3, 'Brown', 'Charlie'),
(4, 'Johnson', 'Emily'),
(5, 'Davis', 'Michael'),
(6, 'Peter', 'Perfect');

-- Insert data into course table
INSERT INTO course (cid, deptname, coursenumber, numcredits, coursename) VALUES
(101, 'CS', 101, 4, 'Intro to Programming'),
(102, 'MATH', 201, 3, 'Calculus I'),
(103, 'HIST', 101, 3, 'World History'),
(104, 'PHYS', 101, 4, 'General Physics'),
(105, 'ENGL', 101, 3, 'English Literature');

-- Insert data into takes table
INSERT INTO takes (sid, cid, semester, grade) VALUES
(1, 101, 1, 'A'),
(1, 102, 1, 'B+'),
(2, 103, 1, 'A-'),
(2, 104, 1, 'B'),
(3, 105, 1, 'C'),
(6, 101, 1, 'A'),
(6, 102, 1, 'A'),
(6, 103, 1, 'A'),
(3, 101, 2, 'B'),
(4, 102, 2, 'A'),
(4, 103, 2, 'B-'),
(5, 104, 2, 'C+'),
(5, 105, 2, 'A-'),
(1, 105, 2, 'F'),
(2, 101, 2, 'W')
;

/** 1 **
For each student, show their first and last name and
the number of credits for courses they passed (did not receive an F or W). */

select * from takes;

-- select s.firstname, s.lastname, c.numcredits
-- from student s, course c, takes t
-- where c.cid = t.cid and s.sid = t.sid and t.grade != 'F' and t.grade != 'W';

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

/*** Select with sq ***/
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

/*** Old Way ***/
create table gpas(
    sid int,
    firstname char(20),
    lastname char(20),
    gpa decimal,
    primary key (sid)
);

insert into gpas
	(sid, firstname, lastname, gpa)
select
	s.sid, s.firstname, s.lastname, sum((g.value*c.numcredits))/sum(c.numcredits)
from student s, course c, takes t, gradevalue g
where c.cid = t.cid and s.sid = t.sid and g.grade = t.grade and t.grade != 'W'
group by (s.sid, s.firstname, s.lastname);

drop table gpas;
select firstname,lastname,gpa from gpas;

/** 3 **
Redo query 2, but where students may have taken a course multiple times.
Your query should calculate the GPA using the most recent non-W grade for a course that the student has taken.
You may assume that semester is an integer value that increases in later semesters
(so if you compare two semester values the larger semester value is a more recent semester). */

/*** New Strategy ***/
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

/*** Old Strategy ***/
truncate table gpas;
truncate table takes;
select * from gpas;

INSERT INTO takes (sid, cid, semester, grade) VALUES
(1, 101, 1, 'A'),
(1, 102, 1, 'B+'),

/*******************************************/
(1, 101, 2, 'F')

;
select * from takes;
select * from student; -- B+ and an F
insert into gpas
	(sid, firstname, lastname, gpa)
select
	s.sid, s.firstname, s.lastname, sum((g.value*c.numcredits))/sum(c.numcredits)
from student s, course c, takes t, gradevalue g
where c.cid = t.cid and s.sid = t.sid and g.grade = t.grade and t.grade != 'W' and (t.sid, t.cid, t.semester) in (
    select sid, cid, max(semester)
    from takes
    group by sid, cid
    )
group by (s.sid, s.firstname, s.lastname)
;

select firstname, lastname, gpa from gpas;

/** 4 **
For each course report the DeptName and CourseNumber for that course
as well as the average grade received ignoring W grades and the average grade received ignoring W and F grades.
Note that you need to make sure that there is at least one student who got a qualifying grade to report these numbers. */

/*** Select with Cases Strategy ***/

select c.deptname, c.coursenumber, avg(case when t.grade != 'W' then g.value else null end) as avgnotw,
       avg(case when t.grade != 'W' and t.grade != 'F' then g.value else null end) as avgnotwnotf
from course c, takes t, gradevalue g
where c.cid=t.cid and t.grade = g.grade
group by c.deptname, c.coursenumber;



/*** Old Strategy ***/
truncate averagegrades;
drop table averagegrades;

create table averagegrades(
    deptname char(20),
    coursenumber int,
    gIgnoreW decimal,
    gIgnoreWF decimal,
    primary key (deptname, coursenumber)
);

insert into averagegrades
	(deptname, coursenumber, gIgnoreW)
select c.deptname, c.coursenumber, avg(g.value)
from course c, takes t, gradevalue g
where c.cid = t.cid and g.grade = t.grade and t.grade != 'W'
group by c.deptname, coursenumber
;

update averagegrades
    set gIgnoreWF=(
        select avg(g.value)
        from course c, takes t, gradevalue g
        where c.cid = t.cid and g.grade = t.grade and t.grade != 'W' and t.grade != 'F'
          and averagegrades.deptname = c.deptname and averagegrades.coursenumber = c.coursenumber
        group by c.deptname, coursenumber
        );

INSERT INTO course (cid, deptname, coursenumber, numcredits, coursename) VALUES
(987, 'CS', 9987, 5, 'Computer Graphics');

delete from course
where cid=987;

select * from course;


select * from averagegrades;

select deptname, coursenumber,
    case
        when gIgnoreW >= 3.85 then 'A'
        when gIgnoreW >= 3.55 then 'A-'
        when gIgnoreW >= 3.15 then 'B+'
        when gIgnoreW >= 2.85 then 'B'
        when gIgnoreW >= 2.55 then 'B-'
        when gIgnoreW >= 2.15 then 'C+'
        when gIgnoreW >= 1.85 then 'C'
        when gIgnoreW >= 1.55 then 'C-'
        when gIgnoreW >= 1.15 then 'D+'
        when gIgnoreW >= 0.85 then 'D'
        else 'F'
    end as withoutW,
    case
        when gIgnoreWF >= 3.85 then 'A'
        when gIgnoreWF >= 3.55 then 'A-'
        when gIgnoreWF >= 3.15 then 'B+'
        when gIgnoreWF >= 2.85 then 'B'
        when gIgnoreWF >= 2.55 then 'B-'
        when gIgnoreWF >= 2.15 then 'C+'
        when gIgnoreWF >= 1.85 then 'C'
        when gIgnoreWF >= 1.55 then 'C-'
        when gIgnoreWF >= 1.15 then 'D+'
        when gIgnoreWF >= 0.85 then 'D'
        else 'F'
    end as withoutWF
from averagegrades;

/** 5 **
For each course report the DeptName and CourseNumber and the total enrollment by semester.
For each semester also calculate the DFW rate which is the percentage of students in a semester who a grade of D+, D, F, or W.
Report the courses sorted from highest DFW rate to lowest. */

select * from takes;
select * from course;

/*** New way ***/
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

truncate table takes;

INSERT INTO takes (sid, cid, semester, grade) VALUES
(2, 101, 1, 'D'),
(1, 101, 2, 'A')
;