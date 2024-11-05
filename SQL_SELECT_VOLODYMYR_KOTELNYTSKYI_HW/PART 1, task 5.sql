--PART 1, task 5
-- First variant
select ct.customer_id,
       string_agg(distinct title,',') as list_of_horrors,
       sum(amount) 
       from public.customer ct
left join public.payment pt 
on pt.customer_id = ct.customer_id 
left join public.rental  r 
on pt.rental_id  = r.rental_id 
left join public.inventory inv 
on inv.inventory_id = r.inventory_id 
left join public.film f
on f.film_id  = inv.film_id 
left join public.film_category fc
on fc.film_id  = f.film_id 
inner join public.category cg 
on cg.category_id = fc.category_id 
where lower(cg.name) = 'horror'
group by ct.customer_id;


-- Second variant
select ct.customer_id,
       string_agg( distinct title,',') as list_of_horrors,
       sum(amount) from public.customer ct
left join (select customer_id,
                  amount,
                  rental_id
                  from public.payment ) pt 
on pt.customer_id = ct.customer_id 
left join (select rental_id,
                  inventory_id 
                  from public.rental)  r 
on pt.rental_id  = r.rental_id 
left join (select inventory_id,
                  film_id
                  from public.inventory) inv
on inv.inventory_id = r.inventory_id 
left join (select film_id,
                  title
                  from public.film) f
on f.film_id  = inv.film_id 
left  join (select film_id,
                   category_id
                   from public.film_category) fc
on fc.film_id  = f.film_id 
inner join (select category_id
                  from public.category
                  where lower(name) = 'horror') cg 
on cg.category_id = fc.category_id 
group by ct.customer_id;