


--TASK 2

-- 1.Create a new user with the username "rentaluser" and the password "rentalpassword".
create user rentaluser with password 'rentalpassword';
grant connect on database dvdrental to rentaluser;

--2. Grant "rentaluser" SELECT permission for the "customer" table
grant select on customer to rentaluser;

--Checking permissions the new role "rentaluser"
set role rentaluser;
select * from customer;

reset role; -- Logging out from rentaluser role

select  current_user -- checking current role


-- 3. Create a new user group called "rental" and add "rentaluser" to the group
create group rental;
alter group rental add user rentaluser;



--4.Grant the "rental" group INSERT and UPDATE permissions for the "rental" table. 

grant insert, update on rental to rental; -- giving permission to group "rental" for updating and inserting



set role rental; -- set the "rental" role


-- Inserting new row under role "rental"
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
select '2024-11-24 18:09:00', 1525, 333, '2024-11-28 18:09:00', 2
where not exists (select * from rental s 
				    where s.inventory_id = 1525
				    and s.rental_date = '2024-11-24 18:09:00'
				    and s.customer_id = 333
				    and s.return_date = '2024-11-28 18:09:00'
				    and s.staff_id = 2 );
	
-- updating the row under role "rental"				   
update rental 
set return_date = '2024-11-30 18:09:00'
where rental_date = '2024-11-24 18:09:00'
and return_date = '2024-11-28 18:09:00'
and customer_id = 333;

reset role ; --Logging out from the "rental" role


-- 5. Revoke the "rental" group's INSERT permission for the "rental" table. 
revoke insert on rental from rental;

set role rental; -- set the "rental" role

-- Checking whether access to "Insert" has been removed
insert into rental (rental_date, inventory_id, customer_id, return_date, staff_id)
select '2024-11-24 18:09:00', 1800, 213, '2024-11-28 18:09:00', 2
where not exists (select * from rental s 
				    where s.inventory_id = 1800
				    and s.rental_date = '2024-11-24 18:09:00'
				    and s.customer_id = 213
				    and s.return_date = '2024-11-28 18:09:00'
				    and s.staff_id = 2 );

reset role;				   
-- 6.Create a personalized role for any customer already existing in the dvd_rental database. 
alter table public.rental disable row level security;
alter table public.payment disable row level security;

create or replace function adding_new_role(needed_customer_id numeric)
 returns void as 
$$
declare
     
 v_role_name varchar;
begin
    
    if not exists (select * from customer where customer_id = needed_customer_id) then
        raise exception 'customer with id % does not exist', needed_customer_id;
    end if;

    -- Creating a role name based on the client's data
    select lower(concat('client_', first_name, '_', last_name)) into v_role_name
    from public.customer where customer_id = needed_customer_id;

    -- check if the role already exists
    if exists (select 1 from pg_roles where rolname = v_role_name) then
        raise exception 'role % already exists', v_role_name;
    end if;

    -- create a role and grant rights
    execute 'create role ' || v_role_name;
    execute 'grant connect on database dwhrental to ' || v_role_name;
    execute 'grant select on rental to ' || v_role_name;
    execute 'grant select on payment to ' || v_role_name;
        
    raise notice 'role % successfully created with "select" permission', v_role_name;

end;
$$ language plpgsql;

select * from adding_new_role(214) -- adding new role
set role client_kristin_johnston; -- set the "client_kristin_johnston" role
   
select * from rental; -- checking whether this role has opportunity to see records in rental table
 select * from payment; -- checking whether this role has opportunity to see records in payment table
	
 reset role; -- logging out from this role
   
   
   
   
   -- TASK 3
   -- It's a query to make sure this user sees only their own data.
-- first step
alter table rental enable row level security;
alter table payment enable row level security;

-- second step
    create  policy rental_policy_214  on rental
    for select
    to client_kristin_johnston
    using (customer_id = (select distinct customer_id from customer where lower(email) = 'kristin.johnston@sakilacustomer.org'));

    create  policy rental_policy_214  on payment
    for select
    to client_kristin_johnston
    using (customer_id = (select distinct customer_id from customer where lower(email) = 'kristin.johnston@sakilacustomer.org'));
   
   
   set role client_kristin_johnston; -- set the "client_kristin_johnston" role
   
   select * from rental; -- checking whether this role has opportunity to see records in rental table
   select * from payment; -- checking whether this role has opportunity to see records in payment table
	
   reset role; -- logging out from this role
   
   
   
