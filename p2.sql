--TASK 1
SELECT format_timestamp('%y-%m', created_at) as month_year,
  count(user_id) as total_user, count(order_id) as total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Complete' 
  AND created_at >= '2019-01-01' AND created_at < '2022-05-01'
GROUP BY 1
ORDER BY 1;
-- cả user và order đều tăng dần theo thời gian, giảm ở 22-02 nhưng đã trở lại đỉnh

-- TASK 2
SELECT format_timestamp('%y-%m', created_at) as month_year, 
  count(distinct user_id) as distinct_users,
  ROUND(1.0*sum(sale_price)/count(order_id),2) as average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
GROUP BY 1
ORDER BY 1;
-- số lượng avg_order_value tăng nhẹ giai đoạn đầu sau đó ổn định, số lượng user tăng dần theo thời gian

--TASK3
SELECT u.first_name, u.last_name, u.gender, u.age, 'youngest' AS tag
FROM bigquery-public-data.thelook_ecommerce.orders AS o 
join bigquery-public-data.thelook_ecommerce.users AS u on o.user_id = u.id
WHERE o.created_at >= '2019-01-01' AND o.created_at < '2022-05-01'
  AND u.age = (select min(age) from bigquery-public-data.thelook_ecommerce.users where gender = u.gender);
