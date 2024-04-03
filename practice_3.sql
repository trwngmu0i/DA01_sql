-- ex 1
select name
from students
where marks > 75
order by right(name, 3), id;

-- ex 2
select user_id, upper(left(name,1)) || lower(right(name, length(name)-1)) as name
from users;

-- ex 3
SELECT manufacturer, '$' || round(sum(total_sales)/1000000.0, 0) || ' million'
FROM pharmacy_sales
group by manufacturer
order by sum(total_sales) desc, manufacturer

-- ex 4
SELECT extract(month from submit_date) as mth, product_id as product, round(avg(stars),2) as avg_stars
FROM reviews
group by extract(month from submit_date), product_id
order by mth, product;

-- ex 5
SELECT sender_id, count(message_id) as message_count 
FROM messages
where sent_date >='08/03/2022' and sent_date < '09-03-2022'
GROUP BY sender_id
order by message_count DESC
limit 2;

-- ex 6
select tweet_id 
from tweets
where length(content) > 15;

-- ex 7
select activity_date as day, count(distinct user_id) as active_users
from activity
where activity_date > '2019-07-27'::timestamp - '30 days'::interval and activity_date <= '2019-07-27'
group by activity_date;

-- ex 8
select count(*)
from employees
where joining_date >= '2022-01-01' and joining_date < '2022-08-01';

-- ex 9
select position('a' in 'Amitah');

-- ex 10
select substr(title, length(winery) + 2, 4)
from winemag_p2
where country = 'Macedonia';
