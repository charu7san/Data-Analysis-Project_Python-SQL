-- creating the empty table and then connecting this with our python and appending 
-- the data from there to avoid using max use of data types
CREATE TABLE df_orders
(
  `order_id` INT PRIMARY KEY,
  `order_date` DATE,
  `ship_mode` VARCHAR(20),
  `segment` VARCHAR(20),
  `country` VARCHAR(20),
  `city` VARCHAR(20),
  `state` VARCHAR(20),
  `postal_code` VARCHAR(20),
  `region` VARCHAR(20),
  `category` VARCHAR(20),
  `sub_category` VARCHAR(20),
  `product_id` VARCHAR(50),
  `quantity` INT,
  `discount` DECIMAL(7,2),
  `sale_price` DECIMAL(7,2),
  `profit` DECIMAL(7,2)
);


select * from df_orders;


#### 1.  find top 10 highest reveue generating products 

Select product_id , sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc
Limit 10;

select * from df_orders
limit 20;


select distinct region
from df_orders;



#### 2. find top 5 highest selling products in each region
with cte as
(
select region , product_id, sum(sale_price) as sales
from df_orders
group by region,product_id
)
Select * from (
select * 
, rank () Over (Partition by region order by sales desc) as rnk
from cte ) A 
where rnk <= 5;

###   or if we consider quantity 

WITH cte AS
(
  SELECT
    region,
    product_id,
    SUM(quantity) AS units_sold
  FROM df_orders
  GROUP BY region, product_id
)
SELECT *
FROM (
  SELECT *,
         RANK() OVER (PARTITION BY region ORDER BY units_sold DESC) AS rnk
  FROM cte
) A
WHERE rnk <= 5;

######   with both quantity and sale price

WITH cte AS
(
  SELECT
    region,
    product_id,
    SUM(quantity) AS units_sold,
    SUM(sale_price) AS total_sales
  FROM df_orders
  GROUP BY region, product_id
)
SELECT *
FROM (
  SELECT *,
         row_number() OVER (PARTITION BY region ORDER BY units_sold DESC) AS rnk
  FROM cte
) A
WHERE rnk <= 5;


   
## 3. find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

-- checking the dictinct year present in table

-- select  distinct year(order_date)
-- from df_orders;

-- we need the data in the below way 

--       2022_sales  2023_sales
-- jan
-- ...
-- dec 

with cte as (
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
-- order by order_year,order_month
)
select order_month
, sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month;


#### 4. for each category which month had highest sales 

with cte as (
select category, date_format(order_date, '%Y%m') as order_year_month, sum(sale_price) as sales
from df_orders
group by category, date_format(order_date, '%Y%m')
-- order by category, date_format(order_date, '%Y%m')
)
select  * from (
select *
, row_number() over (partition by category order by sales desc) as rn
from cte
) A
where rn =1;

#### 5.  which sub category had highest growth by profit in 2023 compare to 2022 

with cte as (
select year(order_date) as order_year, month(order_date) as order_month, sum(sale_price) as sales
from df_orders
group by year(order_date),month(order_date)
-- order by order_year,order_month
)
select order_month
, sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte 
group by order_month
order by order_month;


#### 6. for each category which month had highest sales 

with cte as (
select category, date_format(order_date, '%Y%m') as order_year_month, sum(sale_price) as sales
from df_orders
group by category, date_format(order_date, '%Y%m')
-- order by category, date_format(order_date, '%Y%m')
)
select  * from (
select *
, row_number() over (partition by category order by sales desc) as rn
from cte
) A
where rn =1;

##### 7. which sub category had highest growth by profit in 2023 compare to 2022

with cte as (
select sub_category, year(order_date) as order_year, sum(sale_price) as sales
from df_orders
group by sub_category, year(order_date)
)
,cte2 as (
select sub_category
, sum(case when order_year = 2022 then sales else 0 end) as sales_2022
, sum(case when order_year = 2023 then sales else 0 end) as sales_2023
from cte 
group by sub_category
)
Select *
,(sales_2023-sales_2022)*100/sales_2022  -- this will give the growth percent  
from cte2
order by (sales_2023-sales_2022)*100/sales_2022 desc
Limit 1;

-- without percentage  
 -- (sales_2023-sales_2022)  use only this then answer would be different 
















