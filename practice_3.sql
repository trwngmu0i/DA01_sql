-- ex 1
select name
from students
where marks > 75
order by right(name, 3), id;

-- ex 2
select user_id, upper(left(name,1)) || lower(right(name, length(name)-1)) as name
from users;

-- ex 3
