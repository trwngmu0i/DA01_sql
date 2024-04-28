-- tính RFM
SELECT * FROM public.customer;
SELECT * FROM public.sales;
SELECT * FROM segment_score;

WITH customer_rfm AS (
SELECT c.customer_id,
	current_date - MAX(s.order_date) AS r,
	COUNT(DISTINCT order_id) AS f,
	SUM(s.sales) AS m
FROM public.customer AS c
JOIN public.sales AS s ON c.customer_id = s.customer_id
GROUP BY 1),
tab1 AS (
SELECT *, CAST(r_score*100 + f_score*10 + m_score AS VARCHAR) AS scores
FROM (
SELECT customer_id,
	ntile(5) OVER (ORDER BY r DESC) AS r_score,
	ntile(5) OVER (ORDER BY f DESC) AS f_score,
	ntile(5) OVER (ORDER BY m DESC) AS m_score
FROM customer_rfm) AS customer_rfm_index)

SELECT t2.segment, COUNT(customer_id)
FROM tab1 AS t1
JOIN public.segment_score AS t2 ON t1.scores = t2.scores
GROUP BY 1
ORDER BY 2 DESC
