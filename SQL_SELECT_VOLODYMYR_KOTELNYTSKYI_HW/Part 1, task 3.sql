-- Part 1, task 3
-- First variant 
select actor_id, 
       first_name,
       last_name, 
       number_of_movies from (
								select  ac.actor_id, 
								       first_name,
								       last_name, 
								       count(fl.film_id) as number_of_movies 
								       from actor  ac
								inner join public.film_actor fc 
								on ac.actor_id  = fc.actor_id 
								inner join public.film fl 
								on fl.film_id = fc.film_id
								where fl.release_year >= 2015 
								group by first_name, last_name,ac.actor_id
								order by count(fl.film_id) desc ) h
	 where number_of_movies >= (select min(number_of_movies) from (select  ac.actor_id, 
								       first_name,
								       last_name, 
								       count(fl.film_id) as number_of_movies 
								       from actor  ac
								inner join public.film_actor fc 
								on ac.actor_id  = fc.actor_id 
								inner join public.film fl 
								on fl.film_id = fc.film_id
								where fl.release_year >= 2015 
								group by first_name, last_name,ac.actor_id
								order by count(fl.film_id) desc
								limit 5) mn ) ; 


-- Second variant 
select actor_id, 
       first_name,
       last_name, 
       number_of_movies from (
	   select ac.actor_id,
       first_name,
       last_name, 
       count(fl.film_id) as number_of_movies 
       from actor  ac
inner join (select actor_id,
                  film_id 
                  from public.film_actor) fc 
on ac.actor_id  = fc.actor_id 
inner join (select film_id 
                  from public.film fl where fl.release_year >= 2015) fl 
on fl.film_id = fc.film_id
--where fl.release_year >= 2015
group by first_name, last_name,ac.actor_id
order by count(fl.film_id) desc
) h
	 where number_of_movies >= (select min(number_of_movies) from (select  ac.actor_id, 
								       first_name,
								       last_name, 
								       count(fl.film_id) as number_of_movies 
								       from actor  ac
								inner join public.film_actor fc 
								on ac.actor_id  = fc.actor_id 
								inner join public.film fl 
								on fl.film_id = fc.film_id
								where fl.release_year >= 2015 
								group by first_name, last_name,ac.actor_id
								order by count(fl.film_id) desc
								limit 5) mn ) ;  -- I will use this variant because this variant is more optimized 
                                   --and  execution time is smaller then in other scripts


-- Third variant 
 with number_of_movies as ( select actor_id, 
                                     count(fl.film_id)  number_of_movies 
                                     from film_actor fc
                              inner join (select film_id from film fl
                                        where fl.release_year >= 2015 ) fl  
                              on fl.film_id = fc.film_id
                              group by actor_id),
  
   min_number_of_movies as (select min(number_of_movies) as min_number from (select  ac.actor_id, 
								       first_name,
								       last_name, 
								       count(fl.film_id) as number_of_movies 
								       from actor  ac
								inner join public.film_actor fc 
								on ac.actor_id  = fc.actor_id 
								inner join public.film fl 
								on fl.film_id = fc.film_id
								where fl.release_year >= 2015 
								group by first_name, last_name,ac.actor_id
								order by count(fl.film_id) desc
								limit 5) mn)
                            
		
                            select ac.actor_id,
                                   first_name,
                                   last_name,
                                   nm.number_of_movies from actor ac
                            inner join number_of_movies nm
                            on ac.actor_id = nm.actor_id
                            where  nm.number_of_movies >= (select * from min_number_of_movies )
                            order by nm.number_of_movies desc
                            ;
                            
 