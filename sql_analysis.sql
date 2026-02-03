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







