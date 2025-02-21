create table pratt440.employees(
    id serial,
    name varchar(50),
    salary decimal(10,2),
    primary key (id)
);

-- Trigger Example
create or replace function pratt440.enforce_positive_salary()
returns trigger as $$
begin
    if new.salary <=0 then
        raise exception 'salary mustt be greater than 0';
    end if;
    return new;
end;
$$ language plpgsql;

-- Checking
create trigger check_positive_salary
before insert or update on pratt440.employees
for each row
execute function pratt440.enforce_positive_salary();

insert into pratt440.employees (name, salary) 
