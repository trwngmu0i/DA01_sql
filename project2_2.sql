CREATE VIEW vw_ecommerce_analyst AS 
WITH tab1 AS 
(
SELECT FORMAT_DATE('%Y-%m', oi.created_at) AS month,
  EXTRACT(YEAR FROM oi.created_at) AS year,
  p.category AS product_category,
  SUM(oi.sale_price) AS TPV,
  COUNT(oi.order_id) AS TPO,
  SUM(p.cost) AS total_cost,
  SUM(oi.sale_price) - SUM(p.cost) AS total_profit
FROM bigquery-public-data.thelook_ecommerce.order_items AS oi
JOIN bigquery-public-data.thelook_ecommerce.products AS p ON p.id = oi.product_id
JOIN bigquery-public-data.thelook_ecommerce.orders AS o ON o.order_id = oi.order_id
GROUP BY 1,2,3
ORDER BY 1,2,3
)

SELECT month, year, product_category, TPV, TPO,
  CAST(ROUND(100.00*TPV/(lag(TPV) OVER (PARTITION BY product_category ORDER BY month)) - 100,2) AS STRING) || '%' AS revenue_growth,
  CAST(ROUND(100.00*TPO/(lag(TPO) OVER (PARTITION BY product_category ORDER BY month)) - 100,2) AS STRING) || '%' AS order_growth,
  total_cost, total_profit,
  total_profit/total_cost AS profit_to_cost_ratio
FROM tab1;

-----
WITH f AS (
SELECT user_id, created_at, sale_price,
  MIN(created_at) OVER (PARTITION BY user_id) AS first_buy
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE status = 'Complete'
),
tab2 AS (
SELECT user_id, sale_price, FORMAT_DATE('%Y-%m', first_buy) AS cohort_date, created_at,
  (EXTRACT(MONTH FROM created_at) - EXTRACT(MONTH FROM first_buy)) + (EXTRACT(YEAR FROM created_at) - EXTRACT(YEAR FROM first_buy))*12 + 1 AS index
FROM f),
pre_cohort AS (
SELECT cohort_date, index, COUNT(DISTINCT user_id) AS cnt, SUM(sale_price) AS revenue
FROM tab2
WHERE index <= 4
GROUP BY 1,2
ORDER BY 1),
  
customer_cohort AS (
SELECT cohort_date,
  SUM(CASE WHEN index = 1 THEN cnt ELSE 0 END) AS i1,
  SUM(CASE WHEN index = 2 THEN cnt ELSE 0 END) AS i2,
  SUM(CASE WHEN index = 3 THEN cnt ELSE 0 END) AS i3,
  SUM(CASE WHEN index = 4 THEN cnt ELSE 0 END) AS i4
FROM pre_cohort
GROUP BY 1
ORDER BY cohort_date),

customer_retention AS (
SELECT cohort_date,
  CAST(ROUND(100.00*i1/i1,2) AS STRING) || '%' AS r1,
  CAST(ROUND(100.00*i2/i1,2) AS STRING) || '%' AS r2,
  CAST(ROUND(100.00*i3/i1,2) AS STRING) || '%' AS r3,
  CAST(ROUND(100.00*i4/i1,2) AS STRING) || '%' AS r4
FROM customer_cohort),

customer_churn AS (
SELECT cohort_date,
  CAST(100 - ROUND(100.00*i1/i1,2) AS STRING) || '%' AS c1,
  CAST(100 - ROUND(100.00*i2/i1,2) AS STRING) || '%' AS c2,
  CAST(100 - ROUND(100.00*i3/i1,2) AS STRING) || '%' AS c3,
  CAST(100 - ROUND(100.00*i4/i1,2) AS STRING) || '%' AS c4
FROM customer_cohort)

SELECT * FROM customer_retention
