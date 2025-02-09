create table decimalTest (
	id decimal
);

insert into decimaltest (id)
values
(2.4),
(4.1234567),
(1.23456789);

select * from decimalTest;

drop table decimalTest;