create table offices(
    oID int unique, oNumber int,
    floor int, size decimal,
    maxOccupancy int, primary key (oID)
);

create table employees(
    firstName varchar(50), middleName varchar(50),
    lastName varchar(50), jobTitle varchar(50),
    eID int unique, officeID int,
    salary int, primary key (eID),
    foreign key (officeID) references offices (oID)
);

create table departments(
    depNumber int unique, depName varchar(50),
    mainOfficeID int, officeCount int,
    assignedEmployees int, managerID int unique,
    adminID int unique, primary key (depNumber),
    foreign key (managerID) references employees (eID),
    foreign key (adminID) references employees(eID),
    foreign key (mainOfficeID) references offices(oID)
);

create table assignments(
    employeeID int,
    weeklyHours int,
    departmentID int,
    primary key (employeeID, departmentID),
    foreign key (employeeID) references employees(eID),
    foreign key (departmentID) references departments(depNumber)
);

select * from employees;
select * from departments;
select * from offices;
select * from assignments;

drop table assignments;
drop table departments;
drop table employees;
drop table offices;
