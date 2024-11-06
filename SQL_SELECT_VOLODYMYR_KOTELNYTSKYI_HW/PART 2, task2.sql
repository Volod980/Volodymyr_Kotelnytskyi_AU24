--Part 2, task 2  
   select title,
          count(r.rental_id) as num_of_rent,
          case when f.rating = 'G' then 'All ages admitted'
	           when f.rating = 'PG' then 'Some material is not suitable for children'
               when f.rating = 'PG-13' then 'under 13'
               when f.rating = 'R' then 'Under 17'
               when f.rating = 'NC-17' then 'Adults only'
               end expected_age
          from film f 
   inner join  public.inventory inv
   on f.film_id = inv.film_id 
   inner join public.rental r 
   on inv.inventory_id = r.inventory_id 
   group by title,f.rating
  having count(rental_id) >= (select min(num_of_rent) 
		                     from  ( select title,
					            count(r.rental_id) as num_of_rent
					            from film f 
						    inner join  public.inventory inv
					            on f.film_id = inv.film_id 
						    inner join public.rental r 
						    on inv.inventory_id = r.inventory_id 
						    group by title,f.rating
						    order by count(rental_id) desc
						    limit 5) v)
	order by count(rental_id) desc			
	--I hope that this rating system  will be more correct
