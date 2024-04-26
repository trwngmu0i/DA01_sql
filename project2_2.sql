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

