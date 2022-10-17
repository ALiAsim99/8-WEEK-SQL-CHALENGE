/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
/*SELECT customer_id,sum(price) AS price
from sales
left join menu
using (product_id)
group by customer_id
order by customer_id*/
-- 2. How many days has each customer visited the restaurant?
/*select customer_id,count(distinct order_date) as visits 
from sales
group by customer_id
order by customer_id--*/
-- 3. What was the first item from the menu purchased by each customer?
/*WITH order_rank AS(select *,rank() over(partition by customer_id order by order_date)
from sales)
SELECT  customer_id,product_name
from order_rank
join menu
using(product_id)
where rank=1
group by customer_id,product_name;*/
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
/*select product_name,count(*)
from sales
join menu
using(product_id)
group by product_name
limit 1*/
-- 5. Which item was the most popular for each customer?
/*WITH order_rank AS(select customer_id,product_name,count(*),rank()over(partition by customer_id order by count(*))
from sales
join menu
using(product_id)
group by customer_id,product_name
order by customer_id)
select customer_id,product_name
from order_rank
where rank=1*/
-- 6. Which item was purchased first by the customer after they became a member?
-- with order_rank AS(select *,dense_rank()over(partition by customer_id order by order_date) as rank
-- from sales
-- join members
-- using (customer_id)
-- join menu
-- using(product_id)
-- where order_date>=join_date)
-- SELECT customer_id,product_name
-- from order_rank
-- where rank=1
-- 7. Which item was purchased just before the customer became a member?
/*WITH prior_member_purchase AS(select *,rank() over(partition by customer_id order by order_date desc) as rank
from sales
join members
using(customer_id)
join menu
using(product_id)
where order_date<join_date)
select customer_id,product_name
from prior_member_purchase
where rank=1*/
-- 8. What is the total items and amount spent for each member before they became a member?
/*select customer_id,sum(price) as Total_spend
from sales
join members
using(customer_id)
join menu 
using(product_id)
where order_date<join_date
group by customer_id
order by customer_id*/
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
/*select customer_id,sum(
case when product_name='sushi' then 20*price
else 10*price end)as points
from sales
join menu
using(product_id)
group by customer_id
order by customer_id;*/
--10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
/*WITH members AS(select *,join_date+6 as deadline
from members)
select customer_id,
sum(case when order_date>=join_date and order_date<=deadline then 20*price
   when product_name='sushi' then 20*price
   else 10*price end) as points
from members
join sales
using (customer_id)
join menu
using (product_id)
where order_date<'2021-01-31'
group by customer_id*/

	--BONUS QUESTION--			  
/*select customer_id,order_date,product_name,price,case when order_date<join_date then 'N'
when order_date>=join_date then 'Y'
else 'N' end as member
from sales
join menu
using(product_id)
left join members
using(customer_id)
order by customer_id,order_date*/
--BONUS QUESTION2--

/*with member_pos AS(select customer_id,order_date,product_name,price,case when order_date<join_date then 'N'
when order_date>=join_date then 'Y'
else 'N' end as member
from sales
join menu
using(product_id)
left join members
using(customer_id)
order by customer_id,order_date)
SELECT *,case when member='N' then null
else DENSE_RANK()OVER(PARTITION BY CUSTOMER_ID,member order by order_date ) end as rank
FROM member_pos*/

--INSIGHTS---
/*
1)Customer A spent the most money while customer C spent the least.
2)Ramen is the most popular menu on the item.
3)Both customer A and B ordered ramen before becoming full time members.
4)
*/
				  
				  
				  
				  
				  