
-- ADD favorite films to film table
 
insert into film  (title, release_year,language_id, rental_duration,rental_rate )
with fv_films as (select 'Classmates' as title, 2010 as release_year, 1 as language_id , 1 as rental_duration, 4.99 as rental_rate
			 union all 
			select 'Top Gun' as title, 2022 as release_year, 1 as language_id , 2 as rental_duration, 9.99 as rental_rate		     
             union all 
            select 'Transformers 1' as title, 2007 as release_year, 1 as language_id , 3 as rental_duration, 19.99 as rental_rate )
					     
 select * from fv_films as k 
 where not  exists (select * from film f where k.title = f.title)
 returning film_id; 

-- add main actors of my favorite films
insert into actor (first_name, last_name)
 with mn_actors as (select 'Tom' as first_name, 'Cruise' as last_name
                    union all
                    select 'Miles' as first_name, 'Teller' as last_name
                    union all
                    select 'Shia' as first_name, 'LaBeouf' as last_name
                    union all
                    select 'Megan' as first_name, 'Fox' as last_name
                    union all
                    select 'Adam' as first_name, 'Sandler' as last_name
                    union all
                    select 'Kevin' as first_name, 'James' as last_name)
      select * from mn_actors act
      where  not exists (select * from actor r 
                        where act.first_name = r.first_name
                        and act.last_name = r.last_name)
  returning actor_id;
 
 -- add actor_id and film_id to film_actor table
 
insert into film_actor (actor_id, film_id)
select actor_id,
       film_id 
from film f
join actor a on
    (f.title = 'Top Gun' and a.first_name = 'Tom' and a.last_name = 'Cruise') or
    (f.title = 'Top Gun' and a.first_name = 'Miles' and a.last_name = 'Teller') or
    (f.title = 'Transformers 1' and a.first_name = 'Shia' and a.last_name = 'LaBeouf') or
    (f.title = 'Transformers 1' and a.first_name = 'Megan' and a.last_name = 'Fox') or
    (f.title = 'Classmates' and a.first_name = 'Adam' and a.last_name = 'Sandler') or
    (f.title = 'Classmates' and a.first_name = 'Kevin' and a.last_name = 'James')
    where not exists (select * from film_actor fa 
                       where fa.film_id = f.film_id and fa.actor_id = a.actor_id)
  returning actor_id,film_id ;                 
 
-- add information to inventory table

insert into inventory (film_id, store_id)
select  film_id, 
       case
           when title = 'Classmates' then 1
           when title = 'Transformers 1' then 2
           when title = 'Top Gun' then 2
           else 1 
       end as store_id
from film
where  lower(title) in ('classmates','transformers 1', 'top gun')
returning inventory_id,film_id, store_id;



-- Alter one of  customers with at least 43 rental and 43 payment records
with customers as (
    select customer_id
    from (
        select customer_id, count(*) as number_of_payments
        from payment p
        group by customer_id
        having count(*) >= 43
    ) pm
    union
    select customer_id
    from (
        select customer_id, count(*) as number_of_rents
        from rental r
        group by customer_id
        having count(*) >= 43
    ) rent
    order by customer_id desc
    limit 1
)
update public.customer ct
set store_id = ct.store_id,
    first_name = 'volodymyr',
    last_name = 'kotelnytskyi',
    email = 'volodymyr.kotelnytskyi@gmail.com',
    address_id = ct.address_id,
    last_update = current_date
from customers mm
where ct.customer_id = mm.customer_id
returning store_id,
          first_name, 
          last_name,
          email,
          address_id, 
          last_update;
-- 598 - It's my ID in customer table.
-- Also I wanted to do it by 'MERGE' but I installed old version of Postgres SQL




-- delete records which related with myself from payment table
 -- If I understood correctly it is better when we use insert into... select to save data which we want to delete    
 -- I do it first time that's why I use "create table"  
   
  create table arc_payment as
-- insert into arc_payment
  select * from payment 
  where customer_id = (select distinct customer_id 
                       from customer 
                       where lower(first_name) = 'volodymyr'
                       and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')
-- And then we delete needed records
delete from payment 
where customer_id = (select distinct customer_id 
                     from customer 
                     where lower(first_name) = 'volodymyr' 
                     and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')




-- delete records which related with myself from rental table
create table arc_rental as
-- insert into arc_rental
  select * from rental 
  where customer_id = (select distinct customer_id 
                       from customer 
                       where lower(first_name) = 'volodymyr'
                       and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')
-- And then we delete needed records
delete from payment 
where customer_id = (select distinct customer_id 
                     from customer 
                     where lower(first_name) = 'volodymyr' 
                     and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')



-- Next scripts add records to rental table
-- First, film 'classmates'
insert into rental (rental_date,inventory_id,customer_id, return_date,staff_id)
select
'2017-03-22 21:32:44.000 +0300',
inv.inventory_id,
(select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com'),
'2017-03-29 21:32:44.000 +0300'::timestamp + interval ' 1 weeks' * (rental_duration-1),
st.staff_id
from inventory inv
inner join  film f 
on f.film_id = inv.film_id
inner  join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
where  lower(f.title) = 'classmates'
returning rental_id, last_update;


-- SECOND, film 'classmates'
insert into rental (rental_date,inventory_id,customer_id, return_date,staff_id)
select
'2017-03-22 21:32:44.000 +0300',
inv.inventory_id,
(select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com'),
'2017-03-29 21:32:44.000 +0300'::timestamp + interval ' 1 weeks' * (rental_duration-1) ,
st.staff_id
from inventory inv
inner join  film  f
on f.film_id = inv.film_id
inner  join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
where  lower(f.title) = 'top gun'
returning rental_id, last_update;


-- Third record, film 'Transformer 1'
insert into rental (rental_date,inventory_id,customer_id, return_date,staff_id)
select
'2017-03-22 21:32:44.000 +0300',
inv.inventory_id,
(select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com'),
'2017-03-29 21:32:44.000 +0300'::timestamp + interval ' 1 weeks' * (rental_duration-1) ,
st.staff_id
from inventory inv
inner join film f 
on f.film_id = inv.film_id
inner join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
where  lower(f.title) = 'transformers 1'
returning rental_id, last_update,return_date ;




-- Next scripts to add records to the payment table
-- WARNING !! I decided to calculate amount field as number_of_rental_days * 1.2

insert into payment (customer_id,staff_id,rental_id,amount,payment_date)
select customer_id,
       staff_id,
       rental_id,
       case when lower(f.title) = 'top gun'
          then cast(extract(day from return_date::timestamptz - rental_date::timestamptz) as integer) * rental_rate 
               when lower(f.title) = 'classmates'
                 then cast(extract(day from return_date::timestamptz - rental_date::timestamptz) as integer) * rental_rate 
                    when lower(f.title) = 'transformers 1'
                       then cast(extract(day from return_date::timestamptz - rental_date::timestamptz) as integer) * rental_rate
                       end amount,
        rental_date
from rental r
inner join inventory inv
on r.inventory_id = inv.inventory_id
inner join film f 
on f.film_id = inv.film_id
where customer_id = (select distinct customer_id 
							from customer 
							where lower(first_name) = 'volodymyr' 
							and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')
returning payment_id,staff_id,rental_id,amount,payment_date;
        
      
       
       
       
       