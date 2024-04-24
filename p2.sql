-- TASK 1
SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year, 
  count(user_id) as total_user,
  count(order_id) as total_order
FROM bigquery-public-data.thelook_ecommerce.orders
WHERE status = 'Complete' 
  AND created_at >= '2019-01-01' AND created_at < '2022-05-01'
GROUP BY 1
ORDER BY 1;

-- TASK 2
SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
  COUNT(DISTINCT user_id) AS distinct_user,
  ROUND(AVG(sale_price),2) AS average_order_value
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE created_at >= '2019-01-01' AND created_at < '2022-05-01'
GROUP BY 1

-- TASK 3
WITH tab1 AS (
SELECT gender,
  MIN(age) as young,
  MAX(age) as old
FROM bigquery-public-data.thelook_ecommerce.users
GROUP BY gender),
young_tab AS (
  SELECT u.first_name, u.last_name, u.gender, u.age, 'youngest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users AS u
  JOIN tab1 AS t1 ON u.gender = t1.gender
  WHERE u.age = t1.young
  AND U.created_at >= '2019-01-01' AND u.created_at < '2022-05-01'),
old_tab AS (
  SELECT u.first_name, u.last_name, u.gender, u.age, 'oldest' AS tag
  FROM bigquery-public-data.thelook_ecommerce.users AS u
  JOIN tab1 AS t1 ON u.gender = t1.gender
  WHERE u.age = t1.old 
  AND U.created_at >= '2019-01-01' AND u.created_at < '2022-05-01'
)

SELECT * FROM young_tab
UNION DISTINCT
SELECT * FROM old_tab

-- TASK 4
WITH tab1 AS (
SELECT FORMAT_DATE('%Y-%m', created_at) AS month_year,
  oi.product_id, p.name AS product_name, SUM(oi.sale_price) AS sales,
  SUM(p.cost) AS cost, 
  SUM(oi.sale_price) - SUM(p.cost) AS profit
FROM bigquery-public-data.thelook_ecommerce.products AS p
JOIN bigquery-public-data.thelook_ecommerce.order_items as oi ON p.id = oi.product_id
WHERE created_at >= '2019-01-01' AND created_at < '2022-05-01'
GROUP BY 1,2,3)

SELECT * FROM (
SELECT *,
  DENSE_RANK() OVER (PARTITION BY month_year ORDER BY profit DESC) AS stt
FROM tab1) AS tab2
WHERE stt <=5
ORDER BY month_year, stt

-- TASK 5
SELECT DATE(oi.created_at) AS dates, p.category AS product_categories, SUM(sale_price) AS revenue
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.products AS p ON p.id = oi.product_id
WHERE DATE(oi.created_at) <= '2022-04-15' AND DATE(oi.created_at) >= '2022-01-15'
GROUP BY 1,2
ORDER BY 1


-- PART 2
SELECT 
  FORMAT_DATE('%Y-%m', created_at) AS month,
  EXTRACT('YEAR' FROM created_at) AS year,
  p.category AS product_category,
  SUM(sale_price) AS TPV,
  COUNT(order_id) AS TPO,
  SUM(sale_price) - SUM(cost) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.orders AS o
JOIN bigquery-public-data.thelook_ecommerce.products AS p ON o.product_id = p.id
