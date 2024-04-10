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
