-- ex 1
with tab as(select distinct customer_id, 
    first_value(order_date) over (partition by customer_id order by order_date) as first_order,
    first_value(customer_pref_delivery_date) over (partition by customer_id order by order_date) as first_pref
from delivery)

select 100.0*sum(case when first_pref - first_order = 0 then 1 else 0 end)/count(*) as immediate_percentage
from tab

-- ex 2
select round(1.0*count(*)/
    (select count(distinct player_id) from activity),2) as fraction
    from (
select player_id,
    event_date - lag(event_date) over (partition by player_id) as lag
from activity) as tab
where lag =1

-- ex 3
select id,
    case 
        when stu2 is null then student
        when id%2 = 1 then stu2
        when id%2 = 0 then stu3
        end student
from (select *, lead(student) over (order by id) as stu2,
    lag(student) over (order by id) as stu3
    from seat) as new

-- ex 4
with tab1 as (select distinct visited_on
from (select visited_on, lag(visited_on,6) over (order by visited_on) as lag
from customer) as tab1
where lag is not null),
tab2 as (
select *,
    (select sum(amount) as amount
    from customer
    where visited_on >= tab1.visited_on - '6 days'::interval and visited_on <= tab1.visited_on)
from tab1)

select *, round(1.0*amount/7,2) as average_amount
from tab2

-- ex 5
with   
dup_test as (select pid, tiv_2016
    from (select *, count(*) over (partition by lat, lon) as dup
    from insurance) as tab1
    where dup =1),
t15_test as (
select pid, tiv_2016
from (select *, count(*) over (partition by tiv_2015) as t15
from insurance) as tab2
where t15 >1)

select round(sum(t1.tiv_2016)::decimal,2) as tiv_2016
from dup_test as t1
join t15_test as t2 on t1.pid = t2.pid;

-- ex 6
with tab1 as
(select *,
    dense_rank() over (partition by departmentid order by salary desc) as rank
from employee)

select d.name as Department, tab1.name as employee, tab1.salary
from tab1
join department as d on d.id = tab1.departmentid
where rank <=3;

-- ex 7
with tab as (select *, 
    case when sum(weight) over (order by turn) <=1000 then 1 end test
from queue
order by turn)

select person_name
from tab
where test is not null
order by turn desc
limit 1;

-- ex 8
with tab1 as(select *
from products
where change_date <= '2019-08-16'
union
select product_id, '10' as new_price, date_trunc('year', '1000-01-01'::date)::date as change_date from products)

select distinct product_id, first_value(new_price) over (partition by product_id order by change_date desc) as price
from tab1;
