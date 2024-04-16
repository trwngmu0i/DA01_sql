-- ex 1
SELECT to_char(transaction_date, 'yyyy') as year, product_id,
  sum(spend) as curr_year_spend,
  lag(sum(spend)) over (partition by product_id order by to_char(transaction_date, 'yyyy')) as prev_year_spend,
 round(100.0*sum(spend)/lag(sum(spend)) over (partition by product_id order by to_char(transaction_date, 'yyyy')) - 100,2) as yoy_rate
FROM user_transactions
group by to_char(transaction_date, 'yyyy'), product_id;

-- ex 2
SELECT distinct card_name,
  first_value(issued_amount) over (partition by card_name order by issue_year, issue_month) as issued_amount
FROM monthly_cards_issued
order by first_value(issued_amount) over (partition by card_name order by issue_year, issue_month) desc;

-- ex 3
select user_id, spend, transaction_date from(
SELECT *, count(*) over (partition by user_id) as num,
lead(transaction_date) over (partition by user_id order by transaction_date,2) as new_date
from transactions) as tab
where num >=3 and new_date is null;

-- ex 4
with tab as 
(SELECT distinct user_id,
  first_value(transaction_date) over (partition by user_id order by transaction_date desc) as last
FROM user_transactions)

select ut.transaction_date, ut.user_id, count(*)
from tab 
join user_transactions as ut on ut.transaction_date = tab.last and ut.user_id = tab.user_id
group by ut.transaction_date, ut.user_id

-- ex 5
with tab as (SELECT *, 
  COALESCE(lag(tweet_count) over (partition by user_id order by tweet_date),0) as lag1,
  coalesce(lag(tweet_count,2) over (partition by user_id order by tweet_date),0) as lag2,
  row_number() over (partition by user_id order by tweet_date) as num
FROM tweets)

select user_id, tweet_date,
 case when num <=2 then round(1.0*(tweet_count + lag1 + lag2)/num,2)
 else round(1.0*(tweet_count + lag1 + lag2)/3,2)
 end rolling_avg_3d
from tab;

-- ex 6
with tab as (SELECT *, 
  lag(transaction_timestamp) over (partition by merchant_id, credit_card_id) as pre_time,
  lag(amount) over (partition by merchant_id, credit_card_id) as pre_amount
FROM transactions)

select count(*)
from tab
where pre_time is not null
  and amount -pre_amount = 0
  and transaction_timestamp - pre_time <= '10 minutes'::interval;

-- ex 7
with tab1 as(select category, product, sum(spend) as total_spend
from product_spend
where transaction_date >='01-01-2022' and transaction_date <'01-01-2023'
group by category, product)

select category, product, total_spend from 
(select *, 
  lag(total_spend,2) over (PARTITION BY category order by total_spend desc) as lag
from tab1) as tab2
where lag is null

-- ex 8
with tab as (SELECT r.day, r.song_id, a.artist_name, r.rank
FROM global_song_rank as r
join songs as s on s.song_id = r.song_id
join artists as a on a.artist_id = s.artist_id
where rank <=10)

select * from
(select artist_name, dense_rank() over (order by count(*) desc) as artist_rank
from tab
group by artist_name) as tab2
where artist_rank <=5;
