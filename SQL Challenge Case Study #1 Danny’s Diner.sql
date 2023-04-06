use dannys_diner;
/*What is the total amount each customer spent at the restaurant?*/
select
   s.customer_id,
   sum(m.price) as price
from sales s
join menu m on s.product_id=m.product_id
group by s.customer_id;

   
/*Q2. How many days has each customer visited the restaurant?*/
select
   customer_id,
   count(distinct order_date) as number_days
from sales
group by customer_id;


/* What was the first item from the menu purchased by each customer?*/

with item_rnk as(
select
   s.customer_id,
   s.order_date,
   m.product_name,
   row_number() over(partition by s.customer_id order by s.order_date) as rnk
from sales s
left join menu m on s.product_id=m.product_id)

select 
    customer_id,
    order_date as first_date,
    product_name as first_item
from item_rnk
where rnk=1;

/*Q4. What is the most purchased item on the menu and how many times was it purchased by all customers?*/

SELECT product_name,
  COUNT(*) as number_items,
  ROW_NUMBER() OVER(ORDER BY COUNT(*) desc)as ranking
FROM sales t1
  LEFT JOIN menu t2
   ON t1.product_id = t2.product_id 
GROUP BY 1 
ORDER BY 2 DESC;

/*Q5. Which item was the most popular for each customer?*/

WITH item_rank AS(
 SELECT customer_id, 
   product_name,
   COUNT(*) as number_items,
   ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY COUNT(*) desc)as ranking
 FROM sales t1
   LEFT JOIN menu t2
    ON t1.product_id = t2.product_id 
 GROUP BY 1,2 
 ORDER BY 1,3 DESC
)
 SELECT customer_id,
   product_name,
   number_items
 FROM item_rank
 WHERE ranking = 1;

/*Which item was purchased first by the customer after they became a member?*/
with item as (select 
    s.customer_id,
    m.product_name,
    e.join_date,
    row_number() over(partition by customer_id ) as rnk
from sales s
left join menu m on m.product_id=s.product_id
left join members e on e.customer_id=s.customer_id
 where s.order_date>=e.join_date)

select 
   customer_id,
   join_date,
   product_name
from item
where rnk=1;


/*Which item was purchased just before the customer became a member?*/

with item as (select 
    s.customer_id,
    s.order_date,
    m.product_name,
    e.join_date,
    rank() over(partition by s.customer_id order by s.order_date desc) as rnk
from sales s
left join menu m on m.product_id=s.product_id
left join members e on e.customer_id=s.customer_id
 where s.order_date<e.join_date)

select 
   customer_id,
   order_date,
   product_name
from item
where rnk=1;

/*8. What is the total items and amount spent for each member before they became a member?*/

SELECT s.customer_id, COUNT(DISTINCT s.product_id) AS unique_menu_item, SUM(mm.price) AS total_sales
FROM sales AS s
JOIN members AS m
 ON s.customer_id = m.customer_id
JOIN menu AS mm
 ON s.product_id = mm.product_id
WHERE s.order_date < m.join_date
GROUP BY s.customer_id;

/* Recreate the table with: customer_id, order_date, product_name, price, member (Y/N)*/

 SELECT s.customer_id, s.order_date, m.product_name, m.price,
CASE
 WHEN mm.join_date > s.order_date THEN 'N'
 WHEN mm.join_date <= s.order_date THEN 'Y'
 ELSE 'N'
 END AS member
FROM sales AS s
LEFT JOIN menu AS m
 ON s.product_id = m.product_id
LEFT JOIN members AS mm
 ON s.customer_id = mm.customer_id;
 
 /*If each $1 spent equates to 10 points and sushi has a 2x points multiplier — how many points would each customer have?*/
 
 with point as (select *,
     case
        when product_id=1 then price*20
        else price*10
	end as points
    from menu)
    
  SELECT s.customer_id, SUM(p.points) AS total_points
FROM point AS p
JOIN sales AS s
 ON p.product_id = s.product_id
GROUP BY s.customer_id;