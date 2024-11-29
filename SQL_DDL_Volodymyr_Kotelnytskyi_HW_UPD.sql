create schema IF NOT EXISTS subway;

-- create table "line"
create  table if not exists  subway.line (line_id serial  primary key unique,
						  name varchar(100) not null ,
						  color varchar(50) not null check (color in ('blue', 'red', 'green', 'yellow')));
    
	
-- add information to table "line"					 
 insert into subway.line  ( name, color)
 select 'Saltivska' as name, 'blue' as  color
 where not exists (select * from subway.line ll 
					where lower(name) = 'saltivska'
					and lower(color) = 'blue' )
 union
 select 'Oleksiivska' as name, 'red' as  color
 where not exists (select * from subway.line ll 
					where lower(name) = 'oleksiivska'
					and lower(color) = 'red');
			
     



-- create table "station"
create table if not exists  subway.station (station_id serial primary key unique,
						     name varchar(100) not null ,
						     is_transfer boolean not null default false,
						     line_id int not null references subway.line(line_id));
						   
-- add information to table "station"							    
insert into subway.station ( name, is_transfer, line_id)
select 'Obolon' as name, true as is_transfer, l.line_id 
from subway.line l
where lower(l.color) = 'blue'
and not exists (select * from subway.station s 
                  where lower(s.name) = 'obolon'
                  and  s.is_transfer = true
                \
                  )
union 
select 'Teremky' as name, false as is_transfer, l.line_id 
from subway.line l
where lower(l.color) = 'blue'
and not exists (select * from subway.station s 
                  where lower(s.name) = 'teremky'
                  and  s.is_transfer = true
                 
                  );





-- create table "position"
create table  if not exists subway.position ( position_id  serial primary key unique,
							   position_name varchar(100) not null ,
							   base_salary decimal(10,2) check (base_salary > 0),
							   is_available varchar(2) check (is_available in ('Y', 'N')));

				
 -- add information to table "position" 							  
 insert into subway.position ( position_name, base_salary, is_available)
 select 'Station Manager' as position_name, 5000.00 as base_salary, 'Y' as is_available
 where not exists (select * from subway.position s 
                   where lower(s.position_name) = 'station manager' 
                   and s.base_salary = base_salary
                   and s.is_available = is_available)
 union 
 select 'Train Driver' as position_name, 4500.00 as base_salary, 'Y' as is_available
 where not exists (select * from subway.position s 
                   where lower(s.position_name) = 'train driver'
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
select 'Volodymyr' as first_name,
				'Kotelnytskyi' as  last_name,
				date('2003-11-26') as date_of_birth, 
				(select distinct position_id from subway.position where lower(is_available) = 'y' and lower(position_name) = 'station manager' ) as position_id, 
				(select distinct station_id from subway.station where lower(name) = 'obolon' ) as station_id,
				date('2020-01-01') as start_date,
				date('2024-09-23') as end_date							 
where not exists (select * from subway.employee s
                  where lower(s.first_name) = 'volodymyr'
                  and lower(s.last_name) = 'kotelnytskyi'
                  and s.date_of_birth = date_of_birth
                  and s.position_id = (select distinct position_id from subway.position where lower(is_available) = 'y' and lower(position_name) = 'station manager' )
                  and s.station_id = (select distinct station_id from subway.station where lower(name) = 'obolon' )
                  and s.start_date = start_date
                  and s.end_date = end_date)
union 

                 select 'Fisun' as first_name,
                  'Ksenia' as  last_name,
                  date('2004-12-18') as date_of_birth,
                  (select distinct position_id from subway.position where lower(is_available) = 'y' and lower(position_name) = 'train driver' ) as position_id, 
		 (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as station_id,
                  date('2020-02-01') as start_date,
                  date('2023-05-28') as end_date							 
where not exists (select * from subway.employee s
                  where lower(s.first_name) = 'fisun'
                  and lower(s.last_name) =  'ksenia'
                  and s.date_of_birth = date_of_birth
                  and s.position_id =  (select distinct position_id from subway.position where lower(is_available) = 'y' and lower(position_name) = 'train driver' )
                  and s.station_id = (select distinct station_id from subway.station where lower(name) = 'vokzalna' )
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
select 'Hundai 23',
		200,
		(select distinct line_id from subway.line where lower(color) = 'red'),
		date('2020-01-01'),
		date(null),
		'Y'
where not exists (select * from subway.train s
                  where lower(s.model) = 'hundai 23'
                  and s.capacity = 200
                  and s.line_id = (select distinct line_id from subway.line where lower(color) = 'red')
                  and lower(s.is_working) = 'y')
 union
 select 'Hundai 893/01',
 		200, 
 		(select distinct line_id from subway.line where lower(color) = 'red'), 
 		date('2020-01-01'), 
 		date(null) ,
 		'Y'
where not exists (select * from subway.train s
                  where lower(s.model) = 'hundai 893/01'
                  and s.capacity = 200
                  and s.line_id = (select distinct line_id from subway.line where lower(color) = 'red')
                  and lower(s.is_working) = 'y');
                  
                



-- create table "schedule"

create table if not exists subway.schedule ( schedule_id serial primary key unique,
							   train_id int references subway.train(train_id),
							   station_id int references subway.station(station_id),
							   arrival_time time not null,
							   day_of_week varchar(10) check (day_of_week in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')));


-- add information to table "schedule"								  
insert into subway.schedule ( train_id, station_id, arrival_time, day_of_week) 
select  (select distinct train_id from subway.train where lower(model) = 'hundai 893/01') as train_id ,
        (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as station_id, 
        time '08:00:00',
        'Monday'
         where not exists (select * from subway.schedule s
	                  where  s.arrival_time = '08:00:00'
     			  and lower(s.day_of_week) = 'monday')
union 

	select   (select distinct train_id from subway.train where lower(model) = 'hundai 893/01') as train_id,
	         (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as station_id,
	         time '08:15:00' ,
	         'Monday'
	where not exists (select * from subway.schedule s
	                  where  s.arrival_time = '08:15:00'
	                  and lower(s.day_of_week) = 'monday');
	                  




-- create table "incidents "
create table if not exists subway.incidents (incident_id serial primary key unique, 
							   station_id int references subway.station(station_id),
							   incident_time timestamp not null check (incident_time > '2000-01-01'),
							   description varchar(500) not null,
							   responsible_employee_id int references subway.employee(employee_id));
							  
							  
-- add information to table "incidents"							  
insert into subway.incidents ( station_id, incident_time, description, responsible_employee_id) 
       select (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as station_id,
       timestamp '2023-01-15 14:30:00',
       'Technical malfunction of the escalator',
	   1
where not exists (select * from subway.incidents  s
                  where s.incident_time = '2023-01-15 14:30:00'
                  and lower(s.description) = 'technical malfunction of the escalator')
union 
select  (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as station_id,
	timestamp '2018-02-20 16:45:00',
	'Loss of consciousness of the passenger',
	2
where not exists (select * from subway.incidents  s
                  where  s.incident_time = '2018-02-20 16:45:00'
                  and lower(s.description) = 'loss of consciousness of the passenger') ;





-- create table "station_property"
create table if not exists subway.station_property (facility_id serial primary key unique,
									  station_id int references subway.station(station_id),
									  facility_type varchar(100) not null,
									  cost decimal(10,2) check (cost > 0),
									  is_available varchar(2) check (is_available in ('Y', 'N')));

									 
									 
-- add information to table "station_property"									 
insert into subway.station_property ( station_id, facility_type, cost, is_available) 
select (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as station_id,
       'Loudspeaker',
       3000.00,
	'Y'
where not exists (select * from subway.station_property s
                  where s.station_id = (select distinct station_id from subway.station where lower(name) = 'beresteiska' )
                  and lower(s.facility_type) = 'loudspeaker'
                  and s.cost = 3000.00
                  and lower(s.is_available) = 'y')
 
 union 
select  (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as station_id,
       'Escalator',
	75000.00, 
	'Y'
where not exists (select * from subway.station_property s
                  where s.station_id = (select distinct station_id from subway.station where lower(name) = 'beresteiska' )
	          and lower(s.facility_type) = 'escalator'
                  and s.cost = 75000.00
                  and lower(s.is_available) = 'y' );






-- create table "transfer"
create table if not exists subway.transfer (transfer_id serial primary key unique,
							  from_station_id int references subway.station(station_id),
							  to_station_id int references subway.station(station_id),
							  transfer_time_in_minutes decimal(5,2) check (transfer_time_in_minutes > 0),
							  check (from_station_id != to_station_id));



-- add information to table "transfer"								 
insert into subway.transfer (from_station_id, to_station_id, transfer_time_in_minutes) 
select (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as from_station_id,
       (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as to_station_id,
       4.5
where not exists (select * from subway.transfer s
                  where s.from_station_id = (select distinct station_id from subway.station where lower(name) = 'beresteiska' )
                  and s.to_station_id = (select distinct station_id from subway.station where lower(name) = 'vokzalna' )
                  )
union

select (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as from_station_id,
       (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as to_station_id ,
       6.0
where not exists (select * from subway.transfer s
                  where s.from_station_id = (select distinct station_id from subway.station where lower(name) = 'vokzalna' )
                  and s.to_station_id = (select distinct station_id from subway.station where lower(name) = 'beresteiska' )
                  );






-- create table "station_cleaning"
create table if not exists subway.station_cleaning (cleaning_id serial primary key unique,
									  station_id int references subway.station(station_id),
									  responsible_employee_id int references subway.employee(employee_id),
									  day_of_cleaning date not null check (day_of_cleaning > '2000-01-01'),
									  cleaning_check int check (cleaning_check in (0, 1)));

									 
-- add information to table "station_cleaning"										 
insert into subway.station_cleaning ( station_id, responsible_employee_id, day_of_cleaning, cleaning_check) 
  
       select (select distinct station_id from subway.station where lower(name) = 'beresteiska' ) as station_id,
       2,
       date '2023-10-23',
       1
where not exists (select * from subway.station_cleaning s
                  where s.station_id = (select distinct station_id from subway.station where lower(name) = 'beresteiska' )
                  and s.responsible_employee_id = 2
                  and s.day_of_cleaning = '2023-10-23'
                  )
union 
select (select distinct station_id from subway.station where lower(name) = 'vokzalna' ) as station_id ,
       1,
       date '2024-11-02',
       1
where not exists (select * from subway.station_cleaning s
                  where s.station_id = (select distinct station_id from subway.station where lower(name) = 'vokzalna' )
                  and s.responsible_employee_id = 1
                  and s.day_of_cleaning = '2024-11-02'
                 ) ;





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
