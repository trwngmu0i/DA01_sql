-- ex 1
with tam as ( SELECT distinct title, company_id,
(select sum(case 
  when title = a.title and company_id = a.company_id then 1 else 0 end) as dup
  from job_listings)
from job_listings as a)

select count(*) from tam where dup >=2;

-- ex 2
 with t1 as
(with total as
(select category, product, sum(spend) as total_spend 
from product_spend
where transaction_date >= '01-01-2022' and transaction_date < '01-01-2023'
GROUP BY category, product
)

select category, product, total_spend, RANK() OVER (PARTITION BY category ORDER BY total_spend DESC) as rank
from total)

select category, product, total_spend
from t1
where rank in (1,2)

-- ex 3
with t1 as
(SELECT policy_holder_id, count(*) 
FROM callers
group by policy_holder_id
having count(*) >=3)

select count(*) from t1;

-- ex 4
select p.page_id from pages as p
left join page_likes as l on p.page_id = l.page_id
where l.user_id is null
group by p.page_id
order by p.page_id;

-- ex 5
with 
june as (
  select distinct user_id from user_actions
  where event_date >= '06-01-2022' and event_date < '07-01-2022'),
july as (
  select distinct user_id, '7' as mth from user_actions
  where event_date >= '07-01-2022' and event_date < '08-01-2022') 

SELECT july.mth, count(june.user_id)
FROM july
join june on june.user_id = july.user_id
group by july.mth;

-- ex 6
select to_char(trans_date, 'yyyy-mm') as month, country, count(*) as trans_count,
sum( case when state = 'approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount,
sum(case when state = 'approved' then amount else 0 end) as approved_total_amount
from transactions
group by to_char(trans_date, 'yyyy-mm'), country;

-- ex 7
with fy as (
    select distinct product_id as product_id, 
(select year from sales where s.product_id = product_id order by year limit 1) as first_year
    from sales as s
)

select fy.product_id, fy.first_year, s.quantity, s.price
from fy
join sales as s on fy.product_id = s.product_id and fy.first_year = s.year;

-- ex 8
select distinct customer_id
from customer as c
join product as p on p.product_key = c.product_key
where (select count(distinct product_key)
    from customer 
    where c.customer_id = customer_id) = (select count(distinct product_key) from product);

-- ex 9
select a.employee_id
from employees as a
left join employees as b on a.manager_id = b.employee_id
where a.salary < 30000 and b.employee_id is null;

-- ex 10
trùng link ex 1

-- ex 11
with
r1 as (
    select u.name as results
    from movierating as mr
    join users as u on u.user_id = mr.user_id
    group by mr.user_id, u.name
    order by count(*) desc, u.name 
    limit 1
),
r2 as (
    select title as results
    from movies as m
    where m.movie_id = (select movie_id from movierating where created_at >= '2020-02-01' and created_at < '2020-03-01'
    group by movie_id
    order by avg(rating) desc limit 1)
)

select * from r1
union 
select * from r2

-- ex 12
with u as
(select requester_id as id from requestaccepted 
union all
select accepter_id from requestaccepted)

select id, count(*) as num
from u
group by id
order by count(*) desc
limit 1;
