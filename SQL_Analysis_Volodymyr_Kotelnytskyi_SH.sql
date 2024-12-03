-- 1. Retrieving the total sales amount for each product category for a specific time period

select  p.prod_category,
	    sum(s.amount_sold) as total_sales,
	    count(*) as number_of_sales
from sh.sales s
inner join sh.products p 
 on s.prod_id = p.prod_id
inner join sh.times t 
 on s.time_id = t.time_id
where t.calendar_year = 1998 -- time period
group by p.prod_category
order by total_sales desc;
  

-- 2 Calculating the average sales quantity by region for a particular product
 select c.country_subregion,
	    round(avg(s.quantity_sold), 2) as avg_quantity,
	    count(*) as total_sales,
	    sum(s.quantity_sold) as total_quantity
from sh.sales s
inner join sh.customers cu 
 on s.cust_id = cu.cust_id
inner join sh.countries c 
 on cu.country_id = c.country_id
inner join sh.products p 
 on s.prod_id = p.prod_id
where  lower(p.prod_name) = '5mp telephoto digital camera' 
group by c.country_subregion

 -- 3. Top five customers with the highest total sales amount
 select c.cust_first_name,
	    c.cust_last_name,
	    c.cust_email,
	    count(*) as number_of_purchases,
	    sum(s.amount_sold) as total_amount
from  sh.sales s
inner join sh.customers c
 on s.cust_id = c.cust_id
group by 
    c.cust_id,
    c.cust_first_name,
    c.cust_last_name,
    c.cust_email
                            -- to choose all customers which have sales amount of top 5 highest amount
having sum(s.amount_sold) >= (select min(total_amount) from (select cust_id,
                                              sum(s.amount_sold) as total_amount
                                              from sh.sales s
                                              group by cust_id
                                              order by sum(s.amount_sold) desc 
                                              limit 5 ) g)
 order by sum(s.amount_sold) desc;
