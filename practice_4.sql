-- ex 1
SELECT 
  sum(CASE
    WHEN device_type = 'laptop' then 1
    else 0
  END) as laptop_view,
  sum(CASE
    when device_type in ('phone', 'tablet') then 1
    else 0
    end) as mobile_view
FROM viewership;

-- ex 2
select x,y,z,
    case 
        when x+y <= z then 'No'
        when y+z <= x then 'No'
        when x+z <= y then 'No'
        else 'Yes'
    end triangle
from triangle;

-- ex 3
select
  sum(CASE
    when call_category is null or call_category = 'n/a' then 1
    else 0
    end)*100.0/count(*) as call_percentage
from callers;

-- ex 4 
select name
from customer
where not referee_id = 2 or referee_id is null;

-- ex 5
select survived,
    sum(case
        when pclass = 1 then 1
        else 0
    end) as first_class,
    sum(case
        when pclass = 2 then 1
        else 0
    end) as second_class,
    sum(case
        when pclass = 3 then 1
        else 0
    end) as third_class
from titanic
group by survived;
