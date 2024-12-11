--CREATE DATABASE  final_task;   -- creating database
CREATE SCHEMA if not exists agency;

-- creating table "property"

create table if not exists agency.property (
   property_id serial primary key,
   address varchar(150) ,
   price decimal check (price > 0),
   property_type varchar(45) not null,
   description varchar(250),
   is_sold boolean default false,
   constraint chk_price_min check (price > 0) );
   


--add check constraint to ensure price 

alter table agency.property 
alter column address set not null;
 

 
 -- adding data to property table 
insert into agency.property (address, price, property_type, description)
select 'khreshchatyk st 15', 350000, 'apartment', 'modern 2-room apartment'
where not exists (select * from agency.property 
                  where lower(address) = 'khreshchatyk st 15');
                  
insert into agency.property (address, price, property_type, description)
select 'shevchenko ave 45', 450000, 'house', 'private house with garden'
where not exists (select * from agency.property 
                  where lower(address) = 'shevchenko ave 45');

insert into agency.property (address, price, property_type, description)
select 'ukrainska st 78', 180000, 'apartment', 'cozy 1-room apartment'
where not exists (select * from agency.property 
                  where lower(address) = 'ukrainska st 78');

insert into agency.property (address, price, property_type, description)
select 'peremogy ave 120', 550000, 'house', 'large family house'
where not exists (select * from agency.property  
                  where lower(address) = 'peremogy ave 120');

 
insert into agency.property (address, price, property_type, description)
select 'pushkinska st 25', 220000, 'apartment', 'studio in historical building'
where not exists (select * from agency.property
                  where lower(address) = 'pushkinska st 25');

insert into agency.property (address, price, property_type, description)
select 'volodymyrska st 95', 280000, 'commercial', 'office space downtown'
where not exists (select * from agency.property
                  where lower(address) = 'volodymyrska st 95'); 



-- creating table 'client'
create table if not exists  agency.client (
   client_id serial primary key, 
   first_name varchar(150) not null,
   last_name varchar(150) not null,
   email varchar(150) unique not null,
   phone varchar(20) not null,
   client_type varchar(10) not null,
   activity_ind boolean default true);

 
  alter table agency.client
 drop constraint if exists check_client_type; 


 --Add check constraint to client_type 

alter table agency.client
add constraint check_client_type
check (client_type in ('buyer', 'seller', 'both'));

  
 -- adding data to client table 
insert into agency.client (first_name, last_name, email, phone, client_type)
select 'taras', 'shevchuk', 'taras@email.com', '380501234567', 'buyer'
where not exists (select * from agency.client
                  where lower(email) = 'taras@email.com');

insert into agency.client (first_name, last_name, email, phone, client_type)
select 'oksana', 'kovalenko', 'oksana@email.com', '380672345678', 'seller'
where not exists (select * from agency.client 
                  where lower(email) = 'oksana@email.com');

insert into agency.client (first_name, last_name, email, phone, client_type)
select 'petro', 'bondarenko', 'petro@email.com', '380633456789', 'buyer'
where not exists (select * from agency.client 
                  where lower(email) = 'petro@email.com');

insert into agency.client (first_name, last_name, email, phone, client_type)
select 'olena', 'melnyk', 'olena@email.com', '380994567890', 'seller'
where not exists (select * from agency.client 
                  where lower(email) = 'olena@email.com');

insert into agency.client (first_name, last_name, email, phone, client_type)
select 'andriy', 'tkachenko', 'andriy@email.com', '380975678901', 'buyer'
where not exists (select * from agency.client 
				  where lower(email) = 'andriy@email.com');

insert into agency.client (first_name, last_name, email, phone, client_type)
select 'natalia', 'lysenko', 'natalia@email.com', '380936789012', 'seller'
where not exists (select * from agency.client 
				  where lower(email) = 'natalia@email.com');  
  
  
				 
-- creating table "agent" 				 
  create table if not exists  agency.agent (
   agent_id serial primary key,
   first_name varchar(100) not null,
   last_name varchar(100) not null,
   date_of_birth date not null,
   phone_num varchar(20) unique not null,
   start_date date not null,
   end_date date,
   constraint chk_start_date check (start_date >= '2024-07-01'));
 
  
 -- adding data to table "agent" 
insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'dmytro', 'ivanov', '1990-05-15', '380971112233', '2024-07-01'
where not exists (select * from agency.agent 
                  where phone_num = '380971112233');

insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'mariya', 'petrova', '1988-08-22', '380972223344', '2024-07-01'
where not exists (select * from agency.agent 
                  where phone_num = '380972223344');

insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'viktor', 'sydorenko', '1992-03-10', '380973334455', '2024-07-15'
where not exists (select * from agency.agent 
                  where phone_num = '380973334455');

insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'iryna', 'kravchuk', '1995-11-28', '380974445566', '2024-07-15'
where not exists (select * from agency.agent 
                  where phone_num = '380974445566');

insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'maksym', 'kozlov', '1991-07-19', '380975556677', '2024-08-01'
where not exists (select * from agency.agent 
                  where phone_num = '380975556677');

insert into agency.agent (first_name, last_name, date_of_birth, phone_num, start_date)
select 'sofia', 'vasylieva', '1993-12-05', '380976667788', '2024-08-01'
where not exists (select * from agency.agent 
                  where phone_num = '380976667788'); 
  
  --creating table "property_viewing"
  create table if not exists  agency.property_viewing (
   viewing_id serial primary key,
   property_id int references agency.property(property_id),
   client_id int references agency.client(client_id),
   agent_id int references agency.agent(agent_id),
   viewing_date date default current_date,
   result_of_viewing varchar(250),
   constraint chk_viewing_date check (viewing_date >= '2024-07-01'));

 

  
  -- Add not null constraint to result_of_viewing
alter table agency.property_viewing
alter column result_of_viewing set not null;
 


  --adding data to table "property_viewing" 
 insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-07-15', 'interested'
from agency.property p, agency.client c, agency.agent a 
where lower(p.address) = 'khreshchatyk st 15' 
and lower(c.email) = 'taras@email.com' 
and a.phone_num = '380971112233'
and not exists (select * from agency.property_viewing pv 
			    where pv.property_id = p.property_id 
			    and pv.client_id = c.client_id 
			    and pv.viewing_date = '2024-07-15' );

insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-07-20', 'will consider'
from agency.property p, agency.client c, agency.agent a
where lower(p.address) = 'shevchenko ave 45'
and lower(c.email) = 'oksana@email.com'
and lower(a.phone_num) = '380972223344'
and not exists (select * from agency.property_viewing pv
			    where pv.property_id = p.property_id
			    and pv.client_id = c.client_id
			    and pv.viewing_date = '2024-07-20');
  
  
insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-07-25', 'needs repairs'
from agency.property p, agency.client c, agency.agent a
where lower(p.address) = 'ukrainska st 78'
and lower(c.email) = 'petro@email.com'
and lower(a.phone_num) = '380973334455'
and not exists (select * from agency.property_viewing pv
			    where pv.property_id = p.property_id
			    and pv.client_id = c.client_id
			    and pv.viewing_date = '2024-07-25');
  
insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-08-01', 'too expensive'
from agency.property p, agency.client c, agency.agent a
where lower(p.address) = 'peremogy ave 120'
and lower(c.email) = 'olena@email.com'
and lower(a.phone_num) = '380974445566'
and not exists (select * from agency.property_viewing pv
			    where pv.property_id = p.property_id
			    and pv.client_id = c.client_id
			    and pv.viewing_date = '2024-08-01');  
  
  
 insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-08-05', 'good location'
from agency.property p, agency.client c, agency.agent a
where lower(p.address) = 'pushkinska st 25'
and lower(c.email) = 'andriy@email.com'
and lower(a.phone_num) = '380975556677'
and not exists (select * from agency.property_viewing pv
			    where pv.property_id = p.property_id
			    and pv.client_id = c.client_id
			    and pv.viewing_date = '2024-08-05'); 
  
 insert into agency.property_viewing (property_id, client_id, agent_id, viewing_date, result_of_viewing)
select p.property_id, c.client_id, a.agent_id, '2024-08-10', 'ready to buy'
from agency.property p, agency.client c, agency.agent a
where lower(p.address) = 'volodymyrska st 95'
and lower(c.email) = 'natalia@email.com'
and lower(a.phone_num) = '380976667788'
and not exists (select * from agency.property_viewing pv
			    where pv.property_id = p.property_id
			    and pv.client_id = c.client_id
			    and pv.viewing_date = '2024-08-10');
  
  -- creating table "transaction"
  create table if not exists   agency.transaction (
   transaction_id serial primary key,
   property_id int references agency.property(property_id),
   seller_id int references agency.client(client_id),
   buyer_id int references agency.client(client_id),
   agent_id int references agency.agent(agent_id),
   sale_price decimal check (sale_price > 0),
   transaction_date date default current_date,
   status varchar(50) default 'pending',
   constraint chk_transaction_date check (transaction_date >= '2024-07-01'));
 
  
   alter table agency.transaction
 drop constraint if exists check_transaction_status; 

--Add check constraint to transaction status  
alter table agency.transaction
add constraint check_transaction_status
check (status in ('pending', 'processing', 'completed', 'cancelled'));
 
  
  
  -- adding data to table "transaction"
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 345000, '2024-07-20', 'completed'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'khreshchatyk st 15'
and lower(s.email) = 'oksana@email.com'
and lower(b.email) = 'taras@email.com'
and lower(a.phone_num) = '380971112233'
and not exists ( select * from agency.transaction t
			     where t.property_id = p.property_id
			     and t.transaction_date = '2024-07-20');
  
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 440000, '2024-07-25', 'completed'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'shevchenko ave 45'
and lower(s.email) = 'olena@email.com'
and lower(b.email) = 'petro@email.com'
and lower(a.phone_num) = '380972223344'
and not exists (select * from agency.transaction t
			    where t.property_id = p.property_id
			    and t.transaction_date = '2024-07-25');  
  
  
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 175000, '2024-08-01', 'pending'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'ukrainska st 78'
and lower(s.email) = 'natalia@email.com'
and lower(b.email) = 'andriy@email.com'
and lower(a.phone_num) = '380973334455'
and not exists (select * from agency.transaction t
			    where t.property_id = p.property_id
			    and t.transaction_date = '2024-08-01');  
  
  
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 540000, '2024-08-05', 'pending'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'peremogy ave 120'
and lower(s.email) = 'oksana@email.com'
and lower(b.email) = 'taras@email.com'
and lower(a.phone_num) = '380974445566'
and not exists (select * from agency.transaction t
			    where t.property_id = p.property_id
			    and t.transaction_date = '2024-08-05'); 
  
  
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 215000, '2024-08-10', 'processing'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'pushkinska st 25'
and lower(s.email) = 'olena@email.com'
and lower(b.email) = 'petro@email.com'
and lower(a.phone_num) = '380975556677'
and not exists (select * from agency.transaction t
			    where t.property_id = p.property_id
			    and t.transaction_date = '2024-08-10');  
  
  
insert into agency.transaction (property_id, seller_id, buyer_id, agent_id, sale_price, transaction_date, status)
select p.property_id, s.client_id, b.client_id, a.agent_id, 275000, '2024-08-15', 'processing'
from agency.property p, agency.client s, agency.client b, agency.agent a
where lower(p.address) = 'volodymyrska st 95'
and lower(s.email) = 'natalia@email.com'
and lower(b.email) = 'andriy@email.com'
and lower(a.phone_num) = '380976667788'
and not exists (select * from agency.transaction t
			    where t.property_id = p.property_id
			    and t.transaction_date = '2024-08-15');  
  
  
  
  
  -- creating table "commission"
  create table if not exists  agency.commission (
    commission_id serial primary key,
    transaction_id int references agency.transaction(transaction_id),
    agent_id int references agency.agent(agent_id),
    payment_date date default current_date,
    amount decimal 
    constraint chk_payment_date check (payment_date >= '2024-07-01'));
  
   
   alter table agency.commission 
drop constraint if exists check_commission;

-- add check constraint for commission amount
alter table agency.commission
add constraint check_commission
check (amount > 0);



insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-07-25', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-07-20'
and not exists (select * from agency.commission c
   				where c.transaction_id = t.transaction_id);

insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-07-30', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-07-25'
and not exists (select * from agency.commission c
   				where c.transaction_id = t.transaction_id);

insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-08-05', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-08-01'
and not exists (select * from agency.commission c
 			    where c.transaction_id = t.transaction_id);

insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-08-10', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-08-05'
and not exists ( select * from agency.commission c
   				 where c.transaction_id = t.transaction_id);

insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-08-15', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-08-10'
and not exists (select * from agency.commission c
  				 where c.transaction_id = t.transaction_id);

insert into agency.commission (transaction_id, agent_id, payment_date, amount)
select t.transaction_id, t.agent_id, '2024-08-20', t.sale_price * 0.03
from agency.transaction t
where t.transaction_date = '2024-08-15'
and not exists (select * from agency.commission c
                where c.transaction_id = t.transaction_id);




 -- 5.1 Function that updates data in the table "property"            
 create or replace function agency.update_property(
    p_property_id integer,
    p_column_name varchar,
    p_new_value varchar
) returns void as $$
begin
    -- Checking if such a record exists
    if not exists (select 1 from agency.property where property_id = p_property_id) then
        raise exception 'No property found with id = %', p_property_id;
    end if;

-- part for updating
    execute format(
        'update agency.property set %I = %L where property_id = %s',
        p_column_name, -- %I
        p_new_value, -- %L 
        p_property_id -- %s
    );
    
    raise notice 'Successfully updated % in property table where property_id = %', p_column_name, p_property_id;
end;
$$ language plpgsql;


--5.2 creating function that adds a new transaction
create or replace function agency.add_new_transaction(
   p_property_address varchar,    
   p_seller_email varchar,      
   p_buyer_email varchar,        
   p_agent_phone varchar,        
   p_sale_price decimal,         
   p_status varchar default 'pending'  
) returns void as $$
declare -- Variables for storing IDs of found records
   v_property_id int;
   v_seller_id int;
   v_buyer_id int;
   v_agent_id int;
begin
   select property_id into strict v_property_id
   from agency.property
   where lower(address) = lower(p_property_address);
   
   select client_id into strict v_seller_id
   from agency.client  
   where lower(email) = lower(p_seller_email);
   
   select client_id into strict v_buyer_id
   from agency.client
   where lower(email) = lower(p_buyer_email);
   
   select agent_id into strict v_agent_id  
   from agency.agent
   where lower(phone_num) = lower(p_agent_phone);

-- inserting data to the table "transaction"
   insert into agency.transaction (
       property_id,
       seller_id, 
       buyer_id,
       agent_id,
       sale_price,
       status
   )
   select 
       v_property_id,
       v_seller_id,
       v_buyer_id, 
       v_agent_id,
       p_sale_price,
       p_status;

   raise notice 'Transaction successfully added';

   exception
       when no_data_found then
           raise notice 'Records not found';
       when too_many_rows then
           raise notice 'Multiple records found';
end;
$$ language plpgsql;

    
--6.Creating a view that presents analytics for the most recently added quarter

create or replace  view agency.quarterly_analytics as
with period_dates as (
    select 
        date_trunc('month', min(transaction_date)) as start_date,
        date_trunc('month', max(transaction_date)) + interval '1 month' - interval '1 day' as end_date
    from agency.transaction
)
select 
    p.address,
    p.property_type,
    t.sale_price,
    c.amount as commission_amount,
    round((c.amount * 100.0 / t.sale_price), 2) as commission_percentage,
    concat(a.first_name, ' ', a.last_name) as agent_name,
    t.status,
    to_char(t.transaction_date, 'Month YYYY') as transaction_month
from agency.transaction t
inner join agency.property p
 on t.property_id = p.property_id
inner join agency.agent a 
 on t.agent_id = a.agent_id
inner join agency.commission c 
 on t.transaction_id = c.transaction_id
inner join period_dates pd 
 on t.transaction_date between pd.start_date and pd.end_date
order by t.transaction_date;


-- 7.
-- Creating role "manager"

drop role if exists manager;
create role  manager with  password 'manager123';

-- giving the access to schema
grant usage on schema agency to manager; 

-- giving the access to all tables
grant select on all tables in schema agency to manager;
 
-- giving the access to the view
grant select on agency.quarterly_analytics to manager;

-- remove access on SELECT from role "manager"
revoke insert, update, delete, truncate 
on all tables in schema agency 
from manager;
revoke select on agency.quarterly_analytics from manager;
revoke all privileges on all tables in schema agency from manager;
revoke all privileges on schema agency from manager;

  set role manager;
  reset role;
