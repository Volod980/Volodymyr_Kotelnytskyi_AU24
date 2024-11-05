select actor_id,
       name, 
       EXTRACT(YEAR FROM current_date) - last_year as inactive_period   
       from (
             select act.actor_id, 
		            concat( first_name,' ', last_name) as name,
		            max(f.release_year) as last_year 
             from public.actor act
             left join public.film_actor fl
             on fl.actor_id = act.actor_id 
             inner join film f 
             on f.film_id  = fl.film_id 
             group by act.actor_id,
                      concat( first_name,' ', last_name) ) k
       order by EXTRACT(YEAR FROM current_date) - last_year desc;
     -- The answer: Humphrey Garland didn't act for a longer period of time than the others