
------------------------1-----------------------------

create view sales_revenue_by_category_qtr as
select h.name, quarter|| 'Q' || ' ' || h.year as last_quarter,h.revenue as quarter_revenue ,total.revenue as year_revenue 
	-- Subquery to retrieve revenue by movie category for the last quarter
	from (
select ct.category_id,
       ct_2.name ,
       extract(quarter from pm.payment_date ) as quarter,
       extract(year from pm.payment_date ) as year,
       sum(pm.amount) as revenue,
       count(payment_date) as num_of_sales
       from public.film_category ct
inner join public.inventory inv 
on inv.film_id = ct.film_id 
inner join public.rental r 
on r.inventory_id = inv.inventory_id 
inner join public.payment pm
on pm.rental_id = r.rental_id 
inner join public.category ct_2
on ct.category_id = ct_2.category_id 
group by ct.category_id,
         ct_2.name , 
         extract(quarter from pm.payment_date ),
         extract(year from pm.payment_date )
having count(payment_date) >= 1
) h 
-- Subquery to obtain total income for the entire year
inner join (select ct.category_id,ct_2.name ,
      -- extract(quarter from pm.payment_date ) as quarter,
       extract(year from pm.payment_date ) as year,
       sum(pm.amount) as revenue,
       count(payment_date) as num_of_sales
       from public.film_category ct
inner join public.inventory inv 
on inv.film_id = ct.film_id 
inner join public.rental r 
on r.inventory_id = inv.inventory_id 
inner join public.payment pm
on pm.rental_id = r.rental_id 
inner join public.category ct_2
on ct.category_id = ct_2.category_id 
group by ct_2.name ,
         ct.category_id,
         extract(year from pm.payment_date )
having count(payment_date) >= 1) total

on total.category_id= h.category_id
where h.year = (select max(extract(year from payment_date )) from public.payment)
and h.quarter = (select max(extract(quarter from payment_date )) from public.payment)


----------------------2----------------------------

create or replace  function get_sales_revenue_by_category_qtr(input_quarter integer, input_year integer)
returns table (
    category_name text,
    last_quarter text,
    quarter_revenue numeric,
    year_revenue numeric
) as $$
begin
    return query
	
    select 
        h.name as category_name, 
        quarter || 'q ' || h.year as last_quarter,
        h.revenue as quarter_revenue,
        total.revenue as year_revenue
    from (
-- Subquery to receive revenue for a given quarter	
       select ct.category_id,
       ct_2.name ,
       extract(quarter from pm.payment_date ) as quarter,
       extract(year from pm.payment_date ) as year,
       sum(pm.amount) as revenue,
       count(payment_date) as num_of_sales
       from public.film_category ct
inner join public.inventory inv 
on inv.film_id = ct.film_id 
inner join public.rental r 
on r.inventory_id = inv.inventory_id 
inner join public.payment pm
on pm.rental_id = r.rental_id 
inner join public.category ct_2
on ct.category_id = ct_2.category_id 
group by ct.category_id,
         ct_2.name , 
         extract(quarter from pm.payment_date ),
         extract(year from pm.payment_date )
having count(payment_date) >= 1
    ) h
-- Subquery to obtain total income for the entire year
inner join (select ct.category_id,
                   ct_2.name ,
      -- extract(quarter from pm.payment_date ) as quarter,
			       extract(year from pm.payment_date ) as year,
			       sum(pm.amount) as revenue,
			       count(payment_date) as num_of_sales
			       from public.film_category ct
inner join public.inventory inv 
on inv.film_id = ct.film_id 
inner join public.rental r 
on r.inventory_id = inv.inventory_id 
inner join public.payment pm
on pm.rental_id = r.rental_id 
inner join public.category ct_2
on ct.category_id = ct_2.category_id 
group by ct_2.name ,
         ct.category_id,
         extract(year from pm.payment_date )
having count(payment_date) >= 1
    ) total
    on total.category_id = h.category_id
    where 
        h.year = input_year
        and h.quarter = input_quarter;
end;
$$ language plpgsql;


select * from get_sales_revenue_by_category_qtr(1, 2017);





--------------------------3----------------------------------
create or replace  function most_popular_films_by_countries( input_country_name text[] )
 returns table (
    country text,
    title text,
    rating text,
    language text,
    length numeric,
    release_year numeric
) as $$
begin
return query
 select 
        m.country, 
        c.title, 
        c.rating :: text,
        ln.name :: text as language,
        c.length ::numeric , 
        c.release_year ::numeric from (select ranked.country,
                            film_id
     
						  from ( select country.country,
								        inv.film_id,
								        count(distinct r.rental_id) as num_of_rentals,
								        rank() over (partition by country.country order by count(distinct r.rental_id) desc) as rank_num
								    from public.rental r
								    inner join public.inventory inv 
								    on r.inventory_id = inv.inventory_id
								    inner join public.customer ct
								    on ct.customer_id = r.customer_id
								    inner join public.address ad
								    on ad.address_id = ct.address_id
								    inner join public.city city
								    on city.city_id = ad.city_id
								    inner join public.country country
								    on country.country_id = city.country_id
								    group by country.country, 
								              inv.film_id  ) ranked
								where rank_num = 1 ) m
inner join public.film c
on m.film_id = c.film_id
inner join public.language ln 
on ln.language_id = c.language_id

where 
        m.country ILIKE any(input_country_name); -- I changed "=" to "ILIKE" and it already works with "BRAZIL"
end;
$$ language plpgsql;
select * from most_popular_films_by_countries(array['AnguillA','Afghanistan'])




-------------------------------------------4--------------------------
create or replace function films_in_stock_by_title(needed_film text)
returns table(row_num numeric,
              film_title text,
              language text,
              customer_name text,
              rental_date date
              ) as
$$
begin
  --Checking if there are any films matching the given title
 if not exists (select * from 
               ( select title as film_title
				            from public.film f
				            inner join public.inventory inv on f.film_id = inv.film_id
				            inner join public.rental r on r.inventory_id = inv.inventory_id
				            inner join public.customer cust on cust.customer_id = r.customer_id
				            inner join public.language ln on ln.language_id = f.language_id
				            where title ilike needed_film
				            limit 1
				        ) as check_films
				    ) then

         raise notice 'film not found: %', needed_film;  -- now it's displayed in output
       return;
        end if;
   
  -- Performing the main query if the film is found
    return query

   select row_number() over (order by k.film_title) ::numeric as row_num,
          k.film_title :: text,
          k.name :: text as language,
          k.customer_name :: text,
          k.rental_date :: date from ( select  
						         f.title as film_title,
						         ln.name,
						         cust.first_name || ' ' || cust.last_name as customer_name,
						          r.rental_date,
						          row_number() over (partition by f.title order  by r.rental_date desc) rn
						    from public.film f
						    inner join public.inventory inv
						    on f.film_id = inv.film_id
						    inner join  public.rental r
						    on r.inventory_id = inv.inventory_id
							inner join public.customer cust
						    on cust.customer_id = r.customer_id
						    inner join public.language ln
						    on ln.language_id = f.language_id 
						    )k 
                      where rn = 1 and k.film_title  ilike needed_film;
 
    
end;
$$ language plpgsql;

select * from films_in_stock_by_title('%dfv%');
select * from films_in_stock_by_title('%love%');








----------------------------------5---------------------------
create or replace function new_movie(
    film_title text,
    release_year_param numeric default extract(year from current_date)::numeric, 
    film_language text default 'Klingon'
) 
returns table (
    film_id numeric,
    title text,
    release_year numeric,
    language_id numeric, 
    rental_duration numeric,
    rental_rate numeric,
    replacement_cost numeric
) as $$
declare
    new_lang_id numeric; -- variable for language_id
begin
    -- checking if a movie with the same title exists
    if exists (
        select * from film f where lower(f.title) = lower(film_title))
        then raise notice 'the film "%s" already exists in the table.', film_title;
        return;
        end if;

    -- checking if the language exists and get its id if it exists
    select l.language_id into new_lang_id from language l where lower(l.name) = lower(film_language);

    -- if the language does not exist, insert it and get the id
    if new_lang_id is null then
        insert into language (language_id, name)
        values ((select coalesce(max(l2.language_id), 0) + 1 from language l2), film_language);

        raise notice 'language "%s" has been added to the language table.', film_language;

        -- getting the id of the new language after inserting it
        select l.language_id into new_lang_id from language l where lower(l.name) = lower(film_language);
        end if;

    -- inserting a new movie into the film table
    return query
    insert into film (
        film_id, title, release_year, language_id, rental_duration, rental_rate, replacement_cost
    )
    values (
        (select coalesce(max(f2.film_id), 0) + 1 from film f2),  -- generating a new id for the movie
        film_title,
        release_year_param,
        new_lang_id,        
        3,                  -- rental_duration
        4.99,               -- rental_rate
        19.99               -- replacement_cost
    )
    returning 
        film.film_id::numeric,  
        film.title, 
        film.release_year::numeric, 
        film.language_id::numeric,
        film.rental_duration::numeric, 
        film.rental_rate::numeric, 
        film.replacement_cost::numeric;
end;
$$ language plpgsql;
