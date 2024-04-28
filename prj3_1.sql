-- 1) Doanh thu theo từng ProductLine, Year  và DealSize?
-- Output: PRODUCTLINE, YEAR_ID, DEALSIZE, REVENUE
SELECT productline,
	EXTRACT(YEAR FROM orderdate) AS year_id,
	dealsize,
	SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1,2,3
ORDER BY 1,2,3

--2) Đâu là tháng có bán tốt nhất mỗi năm?
--Output: MONTH_ID, REVENUE, ORDER_NUMBER
SELECT *, RANK() OVER (PARTITION BY LEFT(month_id,4) ORDER BY revenue DESC)
FROM 
(SELECT TO_CHAR(orderdate, 'yyyy-mm') AS month_id,
	SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1) AS tab2

--3) Product line nào được bán nhiều ở tháng 11?
--Output: MONTH_ID, REVENUE, ORDER_NUMBER
SELECT * FROM
(SELECT *, RANK() OVER (PARTITION BY month_id ORDER BY revenue DESC) as rank
FROM
(SELECT TO_CHAR(orderdate, 'yyyy-mm') AS month_id,
	productline,
	SUM(sales) AS revenue
FROM public.sales_dataset_rfm_prj_clean
WHERE EXTRACT(MONTH FROM orderdate) = 11
GROUP BY 1,2) AS tab31) AS tab3
WHERE rank =1

--4) Đâu là sản phẩm có doanh thu tốt nhất ở UK mỗi năm? 
--Xếp hạng các các doanh thu đó theo từng năm.
--Output: YEAR_ID, PRODUCTLINE,REVENUE, RANK
SELECT * FROM
(SELECT EXTRACT(YEAR FROM orderdate) AS year_id,
	productline,
	SUM(sales) AS revenue,
	RANK() OVER (PARTITION BY EXTRACT(YEAR FROM orderdate) ORDER BY SUM(sales) DESC) AS rank
FROM public.sales_dataset_rfm_prj_clean
WHERE country = 'UK'
GROUP BY 1,2) AS tab4
WHERE rank=1

--Ai là khách hàng tốt nhất, phân tích dựa vào RFM 
--(sử dụng lại bảng customer_segment ở buổi học 23)
WITH tab51 AS 
(SELECT customername,
	current_date - MAX(orderdate) AS r,
	COUNT(DISTINCT ordernumber) AS f,
	SUM(sales) AS m
FROM public.sales_dataset_rfm_prj_clean
GROUP BY 1),
tab_score AS
(SELECT *, CAST(r_score*100 + f_score*10 + m_score AS VARCHAR) AS scores
FROM
(SELECT customername,
	ntile(5) OVER (ORDER BY r DESC) AS r_score,
	ntile(5) OVER (ORDER BY f) AS f_score,
	ntile(5) OVER (ORDER BY m) AS m_score
FROM tab51) AS tab52)

SELECT t1.customername, t1.scores, t2.segment
FROM tab_score AS t1
JOIN public.segment_score AS t2 ON t1.scores = t2.scores
ORDER BY 2 DESC
