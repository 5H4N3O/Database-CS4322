create table employees(
    firstName varchar(50),
    middleName varchar(50),
    lastName varChar(50),
    eID int,
    salary int,
    title varchar(50),
    primary key (eID)
);

create table departments(
    depNumber int,
    depName varchar(50),
    mainOffice varchar(50),
    officeCount int,
    assignedEmployees int,
    managerID int,
    primary key (depNumber, managerID),
    foreign key (managerID) references employees (eID)
);

create table offices(
    oID int,
    oNumber int,
    floor int,
    size double precision,
    maxOccupancy int,
    primary key (oID)
);

select * from offices;

select * from departments;
drop table departments;