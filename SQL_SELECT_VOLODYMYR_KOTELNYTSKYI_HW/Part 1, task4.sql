 
-- PART 1, Tasc 4
-- First variant
  select distinct f.release_year,
		                               --fc.name,
		                               count(case when name = 'Drama' then 1 end) as number_of_drama_movies,
		                               count(case when name = 'Travel' then 1 end ) as number_of_travel_movies,
		                               count(case when name = 'Documentary' then 1 end ) as number_of_documentary_movies
		                               from film f 
		               left join  film_category fc  on f.film_id  = fc.film_id
		                left join (select category_id,
		                                 name
		                                 from public.category)  ct 
		               on ct.category_id = fc.category_id
		               group by f.release_year
		              order by release_year desc;
		             
		              
-- Second variant
		              with film_category_new as( select fc.film_id,
                              fc.category_id,
                              ct.name
                              from public.film_category fc
                       left join (select category_id,
		                                 name
		                                 from public.category)  ct 
		               on ct.category_id = fc.category_id )
		               
		               
		               select distinct f.release_year,
		                               --fc.name,
		                               count(case when name = 'Drama' then 1 end) as number_of_drama_movies,
		                               count(case when name = 'Travel' then 1 end ) as number_of_travel_movies,
		                               count(case when name = 'Documentary' then 1 end ) as number_of_documentary_movies
		                               from film f 
		               left join  film_category_new fc  on f.film_id  = fc.film_id
		               where name in ('Drama','Travel','Documentary') and f.release_year is not null
		               group by f.release_year
		               order by release_year desc;