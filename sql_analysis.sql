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


####  find top 10 highest reveue generating products 
Select product_id , sum(sale_price) as sales
from df_orders
group by product_id
order by sales desc
Limit 10;

select * from df_orders
limit 20;


select distinct region
from df_orders;



#### find top 5 highest selling products in each region
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


   
## find month over month growth comparison for 2022 and 2023 sales eg : jan 2022 vs jan 2023

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


#### 
















