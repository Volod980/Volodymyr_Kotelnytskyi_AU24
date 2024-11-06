-- PART 1, task 1
-- First variant
select distinct ff.title,name from film ff
inner join (select film_id,
                  category_id
                  from public.film_category) fc on ff.film_id = fc.film_id
INNER join (select category_id,
                  name
                  from public.category)  ct on ct.category_id = fc.category_id
where ff.release_year between 2017 and 2019 and rental_rate > 1 and UPPER(name) = 'ANIMATION'
order by title;

-- Second variant
with film_category as( select fc.film_id,
                              fc.category_id,
                              ct.name
                              from public.film_category fc
                       inner join (select category_id,
		                                 name
		                                 from public.category)  ct 
		               on ct.category_id = fc.category_id )
		              
		               select distinct ff.title, 
		                               ct.name from film ff
		               INNER join film_category ct
		               on ff.film_id = ct.film_id 
		               where ff.release_year between 2017 and 2019 and rental_rate > 1 and UPPER(name) = 'ANIMATION'
					   order by title;
					   
-- Third variant	
select distinct ff.title,name from film ff
inner join (select film_id,
                  category_id
                  from public.film_category) fc on ff.film_id = fc.film_id
inner join (select category_id,
                  name
                  from public.category where UPPER(name) = 'ANIMATION' )  ct on ct.category_id = fc.category_id
where ff.release_year between 2017 and 2019 and rental_rate > 1 
order by title;
