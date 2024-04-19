-- BUOC 1: tao bang 
create table SALES_DATASET_RFM_PRJ
(
  ordernumber VARCHAR,
  quantityordered VARCHAR,
  priceeach        VARCHAR,
  orderlinenumber  VARCHAR,
  sales            VARCHAR,
  orderdate        VARCHAR,
  status           VARCHAR,
  productline      VARCHAR,
  msrp             VARCHAR,
  productcode      VARCHAR,
  customername     VARCHAR,
  phone            VARCHAR,
  addressline1     VARCHAR,
  addressline2     VARCHAR,
  city             VARCHAR,
  state            VARCHAR,
  postalcode       VARCHAR,
  country          VARCHAR,
  territory        VARCHAR,
  contactfullname  VARCHAR,
  dealsize         VARCHAR
) 
-- import data
--- BUOC 2: clean data
select * from SALES_DATASET_RFM_PRJ;
-- ordernumber 
ALTER TABLE public.sales_dataset_rfm_prj
ALTER ordernumber TYPE numeric using (trim(ordernumber)::integer)
ALTER quantityordered TYPE numeric using (trim(quantityordered)::integer)
ALTER priceeach TYPE decimal using priceeach::decimal
ALTER orderlinenumber TYPE numeric using (trim(orderlinenumber)::integer)
ALTER priceeach TYPE decimal using priceeach::decimal
ALTER msrp TYPE numeric using (trim(msrp)::integer);
--orderdate
ALTER TABLE public.sales_dataset_rfm_prj
ALTER orderdate TYPE timestamp using to_TIMESTAMP(orderdate, 'mm/dd/yyyy hh24:mi');
-- CHECK NULL/BLANK
ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_ordernumber 
CHECK (ordernumber IS NOT NULL);

ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_quantityordered
CHECK (quantityordered IS NOT NULL);

ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_priceeach
CHECK (priceeach IS NOT NULL);

ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_orderlinenumber
CHECK (orderlinenumber IS NOT NULL);

ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_sales
CHECK (sales IS NOT NULL);

ALTER TABLE public.sales_dataset_rfm_prj
ADD CONSTRAINT check_orderdate
CHECK (orderdate IS NOT NULL);

-- ADD COLUMN lastname firstname
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR,
ADD COLUMN contactfirstname VARCHAR;

UPDATE public.sales_dataset_rfm_prj
SET contactlastname = UPPER(SUBSTRING(contactfullname, POSITION('-' IN contactfullname) + 1,1)) || LOWER(RIGHT(contactfullname, LENGTH(contactfullname) - POSITION('-' IN contactfullname)-1)),
	contactfirstname = UPPER(LEFT(contactfullname, 1)) || SUBSTRING(contactfullname, 2, POSITION('-' IN contactfullname) - 2);
	
-- ADD QTR, MONTH, YEAR
ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN QTR_ID INTEGER,
ADD COLUMN MONTH_ID INTEGER,
ADD COLUMN YEAR_ID INTEGER;

UPDATE public.sales_dataset_rfm_prj
SET QTR_ID = EXTRACT('quarter' FROM orderdate),
	MONTH_ID = EXTRACT('month' FROM orderdate),
	YEAR_ID = EXTRACT('year' FROM orderdate);
	
-- TIM OUTLIER
-- box plot
CREATE OR REPLACE VIEW view_bp AS (
WITH bp AS(SELECT q1 - 1.5*(q3-q1) as min_value, q3 + 1.5*(q3-q1) as max_value
from (SELECT
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) as q3,
	PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) as q1,
	PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY quantityordered) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY quantityordered) as iqr
from public.sales_dataset_rfm_prj) as pct)
SELECT ordernumber
FROM public.sales_dataset_rfm_prj as p
WHERE p.quantityordered < (select min_value from bp) or p.quantityordered > (select max_value from bp));
-- z_score
CREATE OR REPLACE VIEW view_z as (
WITH z AS (SELECT ordernumber, quantityordered, 
	(SELECT AVG(quantityordered) AS avg_q FROM public.sales_dataset_rfm_prj),
	(SELECT STDDEV(quantityordered) AS stddev FROM public.sales_dataset_rfm_prj)
FROM public.sales_dataset_rfm_prj)
SELECT ordernumber
FROM z
WHERE abs((quantityordered - avg_q)/stddev) > 3);

-- DELETE FROM SALES_DATASET_RFM_PRJ WHERE ordernumber in (SELECT * FROM view_bp) OR ordernumber IN (SELECT * FROM view_z)

CREATE TABLE SALES_DATASET_RFM_PRJ_CLEAN AS
(SELECT * FROM SALES_DATASET_RFM_PRJ);
