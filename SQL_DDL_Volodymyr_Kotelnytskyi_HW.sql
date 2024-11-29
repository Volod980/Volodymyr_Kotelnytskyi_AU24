create schema subway;

create table subway.line (line_id int primary key unique,
						  name varchar(100) not null ,
						  color varchar(50) not null check (color in ('blue', 'red', 'green', 'yellow')));
    
 insert into subway.line (line_id, name, color)
 values
(1, 'Saltivska', 'blue'),
(2, 'Oleksiivska', 'red');




create table subway.station (station_id int primary key unique,
						     name varchar(100) not null ,
						     is_transfer boolean not null default false,
						     line_id int not null references subway.line(line_id));
						   
insert into subway.station (station_id, name, is_transfer, line_id)
values
(1, 'Vokzalna', true, 1),
(2, 'Beresteiska', false, 1);





create table subway.position ( position_id int primary key unique,
							   position_name varchar(100) not null ,
							   base_salary decimal(10,2) check (base_salary > 0),
							   is_available varchar(2) check (is_available in ('Y', 'N')));

 insert into subway.position (position_id, position_name, base_salary, is_available)
 values
(1, 'Station Manager', 5000.00, 'Y'),
(2, 'Train Driver', 4500.00, 'Y');




create table subway.employee (employee_id int primary key unique,
							  first_name varchar(50) not null,
							  last_name varchar(50) not null,
							  date_of_birth date ,
							  position_id int references subway.position(position_id),
							  station_id int references subway.station(station_id),
							  start_date date not null check (start_date > '2000-01-01'),
							  end_date date check (end_date > start_date));

insert into subway.employee (employee_id, first_name, last_name, date_of_birth, position_id, station_id, start_date, end_date) 
values
(1, 'Volodymyr', 'Kotelnytskyi', '2003-11-26', 1, 1, '2020-01-01', null),
(2, 'Fisun', 'Ksenia', '2004-12-18', 2, 2, '2020-02-01', null);




create table subway.train (train_id int primary key unique,
						   model varchar(100) not null,
						   capacity int check (capacity > 0),
						   line_id int references subway.line(line_id),
						   datefrom date not null check (datefrom > '2000-01-01'),
						   dateto date check (dateto > datefrom),
						   is_working varchar(2) check (is_working in ('Y', 'N')));

insert into subway.train (train_id, model, capacity, line_id, datefrom, dateto, is_working) values
(1, 'Hundai 23', 200, 1, '2020-01-01', null, 'Y'),
(2, 'Hundai 893/01', 200, 1, '2020-01-01', null, 'Y');





create table subway.schedule ( schedule_id int primary key unique,
							   train_id int references subway.train(train_id),
							   station_id int references subway.station(station_id),
							   arrival_time time not null,
							   day_of_week varchar(10) check (day_of_week in ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')));

insert into subway.schedule (schedule_id, train_id, station_id, arrival_time, day_of_week) 
values
(1, 1, 1, '08:00:00', 'Monday'),
(2, 1, 2, '08:15:00', 'Monday');




create table subway.incidents (incident_id int primary key unique, 
							   station_id int references subway.station(station_id),
							   incident_time timestamp not null check (incident_time > '2000-01-01'),
							   description varchar(500) not null,
							   responsible_employee_id int references subway.employee(employee_id));
							  
							  
insert into subway.incidents (incident_id, station_id, incident_time, description, responsible_employee_id) 
values
(1, 1, '2023-01-15 14:30:00', 'Technical malfunction of the escalator', 1),
(2, 2, '2018-02-20 16:45:00', 'Loss of consciousness of the passenger', 2);






create table subway.station_property (facility_id int primary key unique,
									  station_id int references subway.station(station_id),
									  facility_type varchar(100) not null,
									  cost decimal(10,2) check (cost > 0),
									  is_available varchar(2) check (is_available in ('Y', 'N')));

insert into subway.station_property (facility_id, station_id, facility_type, cost, is_available) 
values
(1, 1, 'Loudspeaker', 3000.00, 'Y'),
(2, 1, 'Escalator', 75000.00, 'Y');






create table subway.transfer (transfer_id int primary key unique,
							  from_station_id int references subway.station(station_id),
							  to_station_id int references subway.station(station_id),
							  transfer_time_in_minutes decimal(5,2) check (transfer_time_in_minutes > 0),
							  check (from_station_id != to_station_id));

insert into subway.transfer (transfer_id, from_station_id, to_station_id, transfer_time_in_minutes) 
values
(1, 1, 2, 4.5),
(2, 2, 1, 6.0);






create table subway.station_cleaning (cleaning_id int primary key unique,
									  station_id int references subway.station(station_id),
									  responsible_employee_id int references subway.employee(employee_id),
									  day_of_cleaning date not null check (day_of_cleaning > '2000-01-01'),
									  cleaning_check int check (cleaning_check in (0, 1)));

insert into subway.station_cleaning (cleaning_id, station_id, responsible_employee_id, day_of_cleaning, cleaning_check) 
values
(1, 1, 2, '2023-10-23', 1),
(2, 2, 1, '2024-11-02', 1);




-- ADD column record_ts to all new tables
alter table subway.line 
add column record_ts date not null default current_date;

alter table subway.station 
add column record_ts date not null default current_date;

alter table subway.position 
add column record_ts date not null default current_date;

alter table subway.employee 
add column record_ts date not null default current_date;

alter table subway.train 
add column record_ts date not null default current_date;

alter table subway.schedule 
add column record_ts date not null default current_date;

alter table subway.incidents 
add column record_ts date not null default current_date;

alter table subway.station_property 
add column record_ts date not null default current_date;

alter table subway.transfer 
add column record_ts date not null default current_date;

alter table subway.station_cleaning 
add column record_ts date not null default current_date;

