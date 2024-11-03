
-- ADD favorite films to film table

insert into film (title, release_year,language_id, rental_duration,rental_rate )
values ('Classmates', 2010,1, 1, 4.99),
       ('Top Gun',2022,1,2,9.99),
       ('Transformers 1',2007,1,3,19.99)
 returning film_id;     


-- add main actors of my favorite films
insert into actor (first_name, last_name)
values ('Tom', 'Cruise'),
        ('Miles', 'Teller'),
        ('Shia', 'LaBeouf'),
        ('Megan', 'Fox'),
        ('Adam', 'Sandler'),
        ('Kevin', 'James')
 returning actor_id;      
       



-- add to stores inventory

insert into inventory (film_id,store_id)
values (1011,2),
       (1012,2),
       (1013,1)
returning inventory_id;  




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
set store_id = 2,
    first_name = 'volodymyr',
    last_name = 'kotelnytskyi',
    email = 'volodymyr.kotelnytskyi@gmail.com',
    address_id = 604,
    last_update = current_date
from customers mm
where ct.customer_id = mm.customer_id;
-- 598 - It's my ID in customer table.
-- Also I wanted to do it by 'MERGE' but I installed old version of Postgres SQL




-- delete records which related with myself from payment table
delete from payment 
where customer_id = (select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')




-- delete records which related with myself from rental table
delete from rental
where customer_id = (select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')




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
inner join (select * from film f where  lower(f.title) = 'classmates') f
on f.film_id = inv.film_id
left  join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
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
inner join (select * from film f where  lower(f.title) = 'top gun') f
on f.film_id = inv.film_id
left  join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
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
inner join (select * from film f where  lower(f.title) = 'transformers 1') f
on f.film_id = inv.film_id
left  join  (select distinct on (store_id) 
                   store_id, 
                   staff_id, 
                   last_update
                   from staff
                   order by store_id, last_update desc )st
on st.store_id = inv.store_id 
returning rental_id, last_update,return_date ;




-- Next scripts to add records to the payment table
-- WARNING !! I decided to calculate amount field as number_of_rental_days * 1.2

insert into payment (customer_id,staff_id,rental_id,amount,payment_date)
select customer_id,
       staff_id,
       rental_id,
        cast(extract(day from return_date::timestamptz - rental_date::timestamptz) as integer) * 1.2,
        rental_date
        from rental
        where customer_id = (select distinct customer_id from customer where lower(first_name) = 'volodymyr' and lower(email) = 'volodymyr.kotelnytskyi@gmail.com')
        returning payment_id,staff_id,rental_id,amount,payment_date;