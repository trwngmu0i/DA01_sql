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
