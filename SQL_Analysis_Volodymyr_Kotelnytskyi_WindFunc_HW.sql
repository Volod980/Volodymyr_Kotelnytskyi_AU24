


-- 1. Create a query to produce a sales report highlighting the top customer
select channel_desc,
       cust_id,
       cust_full_name,
       amount_sold,
       sales_percentage from (select k.*,
							         round((amount_sold / amount_channel_level * 100),5) as sales_percentage,
							         row_number() over (partition by channel_desc order by amount_sold desc) as rn 
     						  from (select channel_desc,
									       ct.cust_id,
									       cust_first_name || ' ' || cust_last_name as cust_full_name,
									       sum(amount_sold) as amount_sold, -- calculating amount of sold for each customer
									       sum(sum(amount_sold)) over (partition by channel_desc) as amount_channel_level -- calculating amount of sold for each channels
								    from sh.sales sl
								    inner join sh.customers ct on ct.cust_id = sl.cust_id
								    inner join sh.channels ch on ch.channel_id = sl.channel_id
								    group by channel_desc, ct.cust_id, cust_first_name || ' ' || cust_last_name) k 
								    ) j 
 where rn between 1 and 5;
 




-- 2.Creating a query to retrieve data for a report that displays the total sales for all products in the Photo category in the Asian region for the year 2000
with quarter_sales as (

-- using crosstab function to transform rows into columns
select * from crosstab(
  'select p.prod_name,
          extract(quarter from t.time_id) as quarter, 
          round(sum(sl.amount_sold), 2) as sales          
   from sh.sales sl
   inner join sh.times t 
    on sl.time_id = t.time_id 
   inner join sh.customers c 
    on sl.cust_id = c.cust_id
   inner join sh.countries co 
    on c.country_id = co.country_id
   inner join sh.products p 
    on sl.prod_id = p.prod_id
 
   where lower(p.prod_category) = ''photo''
   and t.calendar_year = 2000
   and lower(co.country_region) = ''asia''
   group by p.prod_name, extract(quarter from t.time_id)
   order by 1,2'
) as final_result( prod_name varchar,
				   q1 numeric,
				   q2 numeric,
				   q3 numeric,
				   q4 numeric) )
				   
-- Final select to calculate yearly total				   
select prod_name, q1, q2, q3, q4,
       round(coalesce(q1,0) + coalesce(q2,0) + coalesce(q3,0) + coalesce(q4,0), 2) as year_sum
from quarter_sales
order by year_sum desc;




-- 3. Creating a query to generate a sales report for customers ranked in the top 300 based on total sales
select channel_desc,
	   cust_id,
	   cust_last_name,
	   cust_first_name, 
	   amount_sold
from (select ch.channel_desc,
		     c.cust_id,
		     c.cust_last_name,
		     c.cust_first_name,
		     round(sum(s.amount_sold), 2) as amount_sold,
		     rank() over ( order by sum(s.amount_sold) desc) as sales_rank -- using "rank()" to define top 300 customers
	   from sh.sales s
	   inner join sh.customers c 
	    on s.cust_id = c.cust_id
	   inner join sh.channels ch
	    on s.channel_id = ch.channel_id
	   inner join sh.times t 
	    on s.time_id = t.time_id
	   where t.calendar_year in (1998, 1999, 2001)
	   group by 
	       ch.channel_desc,
	       c.cust_id,
	       c.cust_last_name,
	       c.cust_first_name ) rank
where sales_rank <= 300 ;


-- 4. Creating a query to generate a sales report for January 2000, February 2000, and March 2000
select distinct 
   calendar_month_desc,
   prod_category,
   round(sum(case when lower(region) = 'americas' then sales end) over (partition by calendar_month_desc, prod_category), 2) as "Americas sales",
   round(sum(case when lower(region) = 'europe' then sales end) over (partition by calendar_month_desc, prod_category), 2) as "Europe sales"
from (select calendar_month_desc,
		     prod_category,
		     country_region as region,
		     amount_sold as sales
      from sh.sales sl
      inner join sh.times t 
      on sl.time_id = t.time_id
      inner join sh.customers c 
      on sl.cust_id = c.cust_id
      inner join sh.countries co 
      on c.country_id = co.country_id
      inner join sh.products p 
      on sl.prod_id = p.prod_id
      where calendar_month_desc in ('2000-01', '2000-02', '2000-03')
      and lower(country_region) in ('americas', 'europe')
) k
order by calendar_month_desc, prod_category;

