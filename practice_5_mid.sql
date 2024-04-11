-- ex 1
select co.continent, floor(avg(ci.population))
from city as ci
join country as co 
on co.code = ci.countrycode
group by co.continent;

-- ex 2
SELECT round(1.0*COUNT(t.signup_action)/COUNT(*),2) FROM emails as e
LEFT JOIN texts AS t ON e.email_id = t.email_id
AND t.signup_action = 'Confirmed';

-- ex 3
SELECT b.age_bucket,
      round(100.0*SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)/(SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)+SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)),2) as open_perc
      ,round(100.0*SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)/(SUM(CASE WHEN a.activity_type = 'open' THEN a.time_spent ELSE 0 END)+SUM(CASE WHEN a.activity_type = 'send' THEN a.time_spent ELSE 0 END)),2) as send_perc
FROM activities as a
JOIN age_breakdown as b ON a.user_id = b.user_id
WHERE a.activity_type in ('send', 'open')
group by b.age_bucket;

-- ex 4
SELECT customer_id FROM customer_contracts as c
LEFT JOIN products as p ON c.product_id = p.product_id
GROUP BY customer_id
HAVING count(DISTINCT p.product_category) =3;

-- ex 5
select e2.employee_id, e2.name, count(*) as reports_count, round(avg(e1.age)) as average_age from employees as e1
join employees as e2 on e1.reports_to = e2.employee_id
group by e2.employee_id, e2.name
order by e2.employee_id;

-- ex 6
select p.product_name , sum(unit) as unit from orders as o
left join products as p on p.product_id = o.product_id
where o.order_date >= '2020-02-01' and o.order_date < '2020-03-01'
group by p.product_name 
having sum(unit) >=100;

-- ex7
select p.page_id from pages as p
left join page_likes as l on p.page_id = l.page_id
where l.user_id is null
group by p.page_id
order by p.page_id;

-- MID COURSE TEST
-- ex 1
select distinct replacement_cost
from film
order by replacement_cost
limit 1;

-- ex 2
select 
	sum(case when replacement_cost >=9.99 and replacement_cost <=19.99 then 1 else 0 end) as low,
	sum(case when replacement_cost >=20.00 and replacement_cost <=24.99 then 1 else 0 end) as medium,
	sum(case when replacement_cost >=25.00 and replacement_cost <=29.99 then 1 else 0 end) as high
from film;

-- ex 3
select f.title, f.length, c.name
from film as f
left join film_category as fc on fc.film_id = f.film_id
left join category as c on c.category_id = fc.category_id
where name in ('Drama', 'Sports')
order by f.length desc
limit 1;

-- ex 4
select c.name, count(f.title)
from film as f
left join film_category as fc on fc.film_id = f.film_id
left join category as c on c.category_id = fc.category_id
group by c.name
order by count(f.title) desc;

-- ex 5
select a.first_name, a.last_name, count(fa.film_id)
from actor as a
left join film_actor as fa on fa.actor_id = a.actor_id
group by a.first_name, a.last_name
order by count(fa.film_id) desc;

-- ex 6
select count(a.address)
from address as a
left join customer as c on c.address_id = a.address_id
where c.customer_id is null;

-- ex 7
select ct.city, sum(p.amount)
from payment as p
left join customer as c on c.customer_id = p.customer_id
left join address as a on a.address_id = c.address_id
left join city as ct on ct.city_id = a.city_id
group by ct.city
order by sum(p.amount) desc;

-- ex 8
select ct.city || ', ' || co.country, sum(p.amount)
from payment as p
left join customer as c on c.customer_id = p.customer_id
left join address as a on a.address_id = c.address_id
left join city as ct on ct.city_id = a.city_id
left join country as co on co.country_id = ct.country_id
group by ct.city || ', ' || co.country
order by sum(p.amount) desc;

