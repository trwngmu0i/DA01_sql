-- ex 1
select distinct city 
from station
where id%2=0;

-- ex 2
select count(city) - count(distinct city)
from station;

-- ex 3
select ceiling(avg(salary) - avg(cast(replace(cast(salary as char), '0','') as signed integer)))
from employees;

-- ex 4
SELECT cast(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal(10,1)) as mean
FROM items_per_order;

-- ex 5
SELECT candidate_id 
FROM candidates
where skill in ('Python', 'Tableau', 'PostgreSQL')
group by candidate_id
having count(*) = 3;

-- ex 6
SELECT user_id, max(post_date::date) - min(post_date::date) as days_between
FROM posts
where extract('year' from post_date::date) = 2021
group by user_id
having count(post_id) >=2;

-- ex 7
SELECT card_name, max(issued_amount) - min(issued_amount) as difference
from monthly_cards_issued
group by card_name
order by difference desc;

-- ex 8
SELECT manufacturer, count(drug) as drug_count, sum(cogs-total_sales) as total_loss
FROM pharmacy_sales
where total_sales < cogs
group by manufacturer
order by total_loss desc;

-- ex 9
select *
from cinema
where id%2 = 1 and description != 'boring'
order by rating desc;

-- ex 10
select teacher_id, count(distinct subject_id) as cnt
from teacher
group by teacher_id;

-- ex 11
select user_id, count(follower_id) as followers_count
from followers
group by user_id
order by user_id asc;

-- ex 12
select class 
from courses
group by class
having count(student) >=5;
