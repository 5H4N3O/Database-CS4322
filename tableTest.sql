create table people (
	id int primary key, --Should be unique
	firstName varchar(10),
	lastName varChar(10)
);

insert into people (id, firstName, lastName) 
values
(1, 'Shane', 'Pratt'),
(2, 'Elijah', 'Pratt');

select * from people;

drop table people;