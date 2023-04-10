
------ A. Pizza Metrics ---------

use pizza_runner;

/*How many pizzas were ordered?*/

select
   count(order_id) as total_order
from customer_orders;

/*How many unique customer orders were made?*/

select
   count(distinct customer_id) as uniq_CUStomer
from customer_orders;

/*How many successful orders were delivered by each runner?*/
SELECT 
    runner_id, 
    COUNT(order_id) AS order_count
FROM runner_orders
WHERE duration IS NOT NULL
GROUP BY runner_id;

/* How many of each type of pizza was delivered? */

select
    count(c.order_id) as typ
from pizza_names p
join customer_orders c
on c.pizza_id=p.pizza_id
join runner_orders r
on r.order_id=c.order_id
where r.distance is not null
group by p.pizza_id;

/* How many Vegetarian and Meatlovers were ordered by each customer? */
select
    c.customer_id,
    p.pizza_name,
    count(c.order_id) as typ
from pizza_names p
join customer_orders c
on c.pizza_id=p.pizza_id
group by p.pizza_name,c.customer_id
order by c.customer_id;

/* What was the maximum number of pizzas delivered in a single order? */

select
   c.order_id,
    count(r.pickup_time) as total_delivery
 from customer_orders c
 join runner_orders r 
 on r.order_id=c.order_id
 group by c.order_id
 order by total_delivery desc
 limit 1;

/*  What was the volume of orders for each day of the week?*/
select
    dayname(order_time) as Day,
    count(order_id) as total_orders
from customer_orders
group by Day
order by total_orders desc;

/* What was the total volume of pizzas ordered for each hour of the day?*/

select
    hour(order_time) as Hour,
    count(order_id) as total_orders
from customer_orders
group by Hour
order by total_orders desc;





























