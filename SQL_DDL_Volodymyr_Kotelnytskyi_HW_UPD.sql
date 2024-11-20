create schema IF NOT EXISTS subway;

-- create table "line"
create  table if not exists  subway.line (line_id serial  primary key unique,
						  name varchar(100) not null ,
						  color varchar(50) not null check (color in ('blue', 'red', 'green', 'yellow')));
    
	
-- add information to table "line"					 
 insert into subway.line  ( name, color)
 select 'Saltivska' as name, 'blue' as  color
 where not exists (select * from subway.line ll 
					where name = ll.name 
					and color = ll.color)
 union
 select 'Oleksiivska' as name, 'red' as  color
 where not exists (select * from subway.line ll 
					where name = ll.name 
					and color = ll.color);
			
     



-- create table "station"
create table if not exists  subway.station (station_id serial primary key unique,
						     name varchar(100) not null ,
						     is_transfer boolean not null default false,
						     line_id int not null references subway.line(line_id));
						   
-- add information to table "station"							    
insert into subway.station ( name, is_transfer, line_id)
select 'Vokzalna' as name, true as is_transfer, 1 as line_id 
where not exists (select * from subway.station s 
                  where s.name = name
                  and is_transfer = s.is_transfer
                  and line_id = s.line_id)
union 
select 'Beresteiska' as name, false as is_transfer, 1 as line_id 
where not exists (select * from subway.station s 
                  where s.name = name
                  and is_transfer = s.is_transfer
                  and line_id = s.line_id);






-- create table "position"
create table  if not exists subway.position ( position_id  serial primary key unique,
							   position_name varchar(100) not null ,
							   base_salary decimal(10,2) check (base_salary > 0),
							   is_available varchar(2) check (is_available in ('Y', 'N')));

				
 -- add information to table "position" 							  
 insert into subway.position ( position_name, base_salary, is_available)
 select 'Station Manager' as position_name, 5000.00 as base_salary, 'Y' as is_available
 where not exists (select * from subway.position s 
                   where s.position_name = position_name 
                   and s.base_salary = base_salary
                   and s.is_available = is_available)
 union 
 select 'Train Driver' as position_name, 4500.00 as base_salary, 'Y' as is_available
 where not exists (select * from subway.position s 
                   where s.position_name = position_name 
                   and s.base_salary = base_salary
                   and s.is_available = is_available);
 




-- create table "employee"
create table if not exists  subway.employee (employee_id serial primary key unique,
							  first_name varchar(50) not null,
							  last_name varchar(50) not null,
							  date_of_birth date ,
							  position_id int references subway.position(position_id),
							  station_id int references subway.station(station_id),
							  start_date date not null check (start_date > '2000-01-01'),
							  end_date date check (end_date > start_date));


-- add information to table "employee"							 
insert into subway.employee (first_name, last_name, date_of_birth, position_id, station_id, start_date, end_date) 							 
select 'Volodymyr' as first_name, 'Kotelnytskyi' as  last_name,date('2003-11-26') as date_of_birth, 1 as position_id, 1 as station_id,date('2020-01-01') as start_date, date('2024-09-23') as end_date							 
where not exists (select * from subway.employee s
                  where s.first_name = first_name
                  and s.last_name =  last_name
                  and s.date_of_birth = date_of_birth
                  and s.position_id = position_id
                  and s.station_id = station_id
                  and s.start_date = start_date
                  and s.end_date = end_date)
union 

select 'Fisun' as first_name, 'Ksenia' as  last_name,date('2004-12-18') as date_of_birth, 2 as position_id, 2 as station_id, date('2020-02-01') as start_date, date('2023-05-28') as end_date							 
where not exists (select * from subway.employee s
                  where s.first_name = first_name
                  and s.last_name =  last_name
                  and s.date_of_birth = date_of_birth
                  and s.position_id = position_id
                  and s.station_id = station_id
                  and s.start_date = start_date
                  and s.end_date = end_date);
              
 

-- create table "train"
create table if not exists  subway.train (train_id serial primary key unique,
						   model varchar(100) not null,
						   capacity int check (capacity > 0),
						   line_id int references subway.line(line_id),
						   datefrom date not null check (datefrom > '2000-01-01'),
						   dateto date check (dateto > datefrom),
						   is_working varchar(2) check (is_working in ('Y', 'N')));

				
						  
-- add information to table "train"							  
insert into subway.train ( model, capacity, line_id, datefrom, dateto, is_working) 
select 'Hundai 23', 200, 1, date('2020-01-01'), date(null), 'Y'
where not exists (select * from subway.train s
                  where s.model = model
                  and s.capacity = capacity
                  and s.line_id = line_id
                  and s.datefrom = datefrom
                  and s.is_working = is_working)
 union
 select 'Hundai 893/01', 200, 1, date('2020-01-01'), date(null) , 'Y'
where not exists (select * from subway.train s
                  where s.model = model
                  and s.capacity = capacity
                  and s.line_id = line_id
                  and s.datefrom = datefrom
                  and s.is_working = is_working);
                  
                



-- create table "schedule"

create table if not exists subway.schedule ( schedule_id serial primary key unique,
							   train_id int references subway.train(train_id),
							   station_id int references subway.station(station_id),
							   arrival_time time not null,
							   day_of_week varchar(10) check (day_of_week in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')));


-- add information to table "schedule"								  
insert into subway.schedule ( train_id, station_id, arrival_time, day_of_week) 
select  1, 1, time '08:00:00' , 'Monday'
where not exists (select * from subway.schedule s
                  where s.train_id = train_id
                  and s.station_id = station_id
                  and s.arrival_time = arrival_time
                  and s.day_of_week = day_of_week)
union 
select   1, 2, time '08:15:00' , 'Monday'
where not exists (select * from subway.schedule s
                  where s.train_id = train_id
                  and s.station_id = station_id
                  and s.arrival_time = arrival_time
                  and s.day_of_week = day_of_week);
                  




-- create table "incidents "
create table if not exists subway.incidents (incident_id serial primary key unique, 
							   station_id int references subway.station(station_id),
							   incident_time timestamp not null check (incident_time > '2000-01-01'),
							   description varchar(500) not null,
							   responsible_employee_id int references subway.employee(employee_id));
							  
							  
-- add information to table "incidents"							  
insert into subway.incidents ( station_id, incident_time, description, responsible_employee_id) 
select 1, timestamp '2023-01-15 14:30:00' , 'Technical malfunction of the escalator', 1
where not exists (select * from subway.incidents  s
                  where s.station_id = station_id
                  and s.incident_time = incident_time
                  and s.description = description
                  and s.responsible_employee_id = responsible_employee_id)
union 
select  2, timestamp '2018-02-20 16:45:00', 'Loss of consciousness of the passenger', 2
where not exists (select * from subway.incidents  s
                  where s.station_id = station_id
                  and s.incident_time = incident_time
                  and s.description = description
                  and s.responsible_employee_id = responsible_employee_id);






-- create table "station_property"
create table if not exists subway.station_property (facility_id serial primary key unique,
									  station_id int references subway.station(station_id),
									  facility_type varchar(100) not null,
									  cost decimal(10,2) check (cost > 0),
									  is_available varchar(2) check (is_available in ('Y', 'N')));

									 
									 
-- add information to table "station_property"									 
insert into subway.station_property ( station_id, facility_type, cost, is_available) 
select 1, 'Loudspeaker', 3000.00, 'Y'
where not exists (select * from subway.station_property s
                  where s.station_id = station_id 
                  and s.facility_type = facility_type
                  and s.cost = cost
                  and s.is_available = is_available)
 
 union 
select 1, 'Escalator', 75000.00, 'Y'
where not exists (select * from subway.station_property s
                  where s.station_id = station_id 
                  and s.facility_type = facility_type
                  and s.cost = cost
                  and s.is_available = is_available);






-- create table "transfer"
create table if not exists subway.transfer (transfer_id serial primary key unique,
							  from_station_id int references subway.station(station_id),
							  to_station_id int references subway.station(station_id),
							  transfer_time_in_minutes decimal(5,2) check (transfer_time_in_minutes > 0),
							  check (from_station_id != to_station_id));



-- add information to table "transfer"								 
insert into subway.transfer (from_station_id, to_station_id, transfer_time_in_minutes) 
select 1, 2, 4.5
where not exists (select * from subway.transfer s
                  where s.from_station_id = from_station_id
                  and s.to_station_id = to_station_id
                  and s.transfer_time_in_minutes = transfer_time_in_minutes)
union

select 2, 1, 6.0
where not exists (select * from subway.transfer s
                  where s.from_station_id = from_station_id
                  and s.to_station_id = to_station_id
                  and s.transfer_time_in_minutes = transfer_time_in_minutes);






-- create table "station_cleaning"
create table if not exists subway.station_cleaning (cleaning_id serial primary key unique,
									  station_id int references subway.station(station_id),
									  responsible_employee_id int references subway.employee(employee_id),
									  day_of_cleaning date not null check (day_of_cleaning > '2000-01-01'),
									  cleaning_check int check (cleaning_check in (0, 1)));

									 
-- add information to table "station_cleaning"										 
insert into subway.station_cleaning ( station_id, responsible_employee_id, day_of_cleaning, cleaning_check) 
select 1, 2, date '2023-10-23', 1
where not exists (select * from subway.station_cleaning s
                  where s.station_id = station_id
                  and s.responsible_employee_id = responsible_employee_id
                  and s.day_of_cleaning = day_of_cleaning
                  and s.cleaning_check = cleaning_check)
union 
select 2, 1, date '2024-11-02', 1
where not exists (select * from subway.station_cleaning s
                  where s.station_id = station_id
                  and s.responsible_employee_id = responsible_employee_id
                  and s.day_of_cleaning = day_of_cleaning
                  and s.cleaning_check = cleaning_check) ;





-- ADD column "record_ts" to all new tables
alter table subway.line
add column if not exists record_ts date not null default current_date;

alter table subway.station 
add column if not exists record_ts date not null default current_date;

alter table subway.position 
add column if not exists record_ts date not null default current_date;

alter table subway.employee 
add column if not exists record_ts date not null default current_date;

alter table subway.train 
add column if not exists record_ts date not null default current_date;

alter table subway.schedule 
add column if not exists record_ts date not null default current_date;

alter table subway.incidents 
add column if not exists record_ts date not null default current_date;

alter table subway.station_property 
add column if not exists record_ts date not null default current_date;

alter table subway.transfer 
add column if not exists record_ts date not null default current_date;

alter table subway.station_cleaning 
add column if not exists record_ts date not null default current_date;