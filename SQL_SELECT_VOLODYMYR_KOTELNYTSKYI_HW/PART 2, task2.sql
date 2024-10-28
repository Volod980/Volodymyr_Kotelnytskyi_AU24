--Part 2, task 2  
   select title,
          count(r.rental_id) as num_of_rent,
          case when f.rating = 'G' then '3+'
	           when f.rating = 'PG' then '7+'
               when f.rating = 'PG-13' then '13+'
               when f.rating = 'R' then '17+'
               when f.rating = 'NC-17' then '18+'
               end expected_age
          from film f 
   left join  public.inventory inv
   on f.film_id = inv.film_id 
   left join public.rental r 
   on inv.inventory_id = r.inventory_id 
   group by title,f.rating
   order by count(rental_id) desc 
   limit 5