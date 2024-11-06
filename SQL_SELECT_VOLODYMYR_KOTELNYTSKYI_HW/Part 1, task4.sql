 
-- PART 1, Tasc 4
-- First variant
  select distinct f.release_year,
		                               --fc.name,
		                               count(case when upper(name) = 'DRAMA' then 1 end) as number_of_drama_movies,
		                               count(case when upper(name) = 'TRAVEL' then 1 end ) as number_of_travel_movies,
		                               count(case when upper(name) = 'DOCUMENTARY' then 1 end ) as number_of_documentary_movies
		                               from film f 
		               inner join  film_category fc  on f.film_id  = fc.film_id
		                INNER join  public.category  ct 
		               on ct.category_id = fc.category_id
		              where  upper(name) in ('DRAMA','TRAVEL','DOCUMENTARY')
		               group by f.release_year
		              order by release_year desc;
		             
		              
-- Second variant
		              with film_category_new as( select fc.film_id,
                              fc.category_id,
                              ct.name
                              from public.film_category fc
                       inner join public.category  ct 
		               on ct.category_id = fc.category_id )
		               
		               
		               select distinct f.release_year,
		                               count(case when upper(name) = 'DRAMA' then 1 end) as number_of_drama_movies,
		                               count(case when upper(name) = 'TRAVEL' then 1 end ) as number_of_travel_movies,
		                               count(case when upper(name) = 'DOCUMENTARY' then 1 end ) as number_of_documentary_movies
		                               from film f 
		               INNER join  film_category_new fc  on f.film_id  = fc.film_id
		               where upper(name) in ('DRAMA','TRAVEL','DOCUMENTARY') and f.release_year is not null
		               group by f.release_year
		               order by release_year desc;