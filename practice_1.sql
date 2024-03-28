-- ex 1
select name 
from city
where population > 120000 and countrycode = 'USA';

-- ex 2
select * 
from city
where countrycode = 'JPN';

-- ex 3
select city, state
from station;

-- ex 4
select city from station 
where city like 'A%' 
    or city like 'E%'
    or city like 'I%'
    or city like 'O%'
    or city like 'U%';

-- ex 5
select distinct city from station 
where city like '%a' 
    or city like '%e'
    or city like '%i'
    or city like '%o'
    or city like '%u';

-- ex 6
select distinct city from station 
where not (city like 'A%' 
    or city like 'E%'
    or city like 'I%'
    or city like 'O%'
    or city like 'U%');

-- ex 7
select name from employee order by name;

-- ex 8
select name
from employee
where salary > 2000 and months < 10
order by employee_id;

-- ex 9
select product_id from products where low_fats = 'Y' and recyclable = 'Y';

-- ex 10
select name
from customer
where not referee_id = 2 or referee_id is null;

-- ex 11
select name, population, area
from world
where area >= 3000000 or population >= 25000000;

-- ex 12
select distinct author_id as id
from views
where author_id = viewer_id;

-- ex 13
SELECT part, assembly_step FROM parts_assembly where finish_date is null;

-- ex 14
select * from lyft_drivers where yearly_salary <= 30000 or yearly_salary >= 70000;

-- ex 15
select advertising_channel from uber_advertising where money_spent >= 100000 and year = 2019;
