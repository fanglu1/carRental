-- 1)Customer 'Angel' has rented 'SBA1111A' from today for 10 days.
insert into rental_records (veh_reg_no, customer_id, start_date, end_date, lastUpdated)
values
   ('SBA1111A', (select customer_id from customers where name='Angel'), curdate(), date_add(curdate(), interval 10 day), null);

-- 2) Customer 'Kumar' has rented 'GA5555E' from tomorrow for 3 months.
insert into rental_records (veh_reg_no, customer_id, start_date, end_date, lastUpdated)
values
   ('GA5555E', (select customer_id from customers where name='Kumar'), curdate(), date_add(curdate(), interval 3 month), null );

-- 3) List all rental records (start date, end date) with vehicle's registration number, brand, and customer name, sorted by vehicle's categories followed by start date.
select 
rental_records.start_date as 'start date',
rental_records.end_date as 'end date',
rental_records.veh_reg_no, 
vehicles.brand,
customers.name
from rental_records
inner join vehicles on rental_records.veh_reg_no = vehicles.veh_reg_no
inner join customers on rental_records.customer_id = customers.customer_id
order by vehicles.category, start_date;

-- 4) List all the expired rental records (end_date before CURDATE()).
select *
from rental_records
where end_date < curdate();

-- 5) List the vehicles rented out on '2012-01-10' (not available for rental), in columns of vehicle registration no, customer name, start date and end date.
select 
rental_records.veh_reg_no as 'vehicle registration no',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
where '2012-01-10' between rental_records.start_date and rental_records.end_date;

-- 6) List all vehicles rented out today, in columns registration number, customer name, start date, end date.
select
rental_records.veh_reg_no as 'registration number',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
where curdate() = rental_records.start_date;

-- 7) Similarly, list the vehicles rented out (not available for rental) for the period from '2012-01-03' to '2012-01-18'.
select
rental_records.veh_reg_no as 'registration number',
customers.name as 'customer name',
rental_records.start_date as 'start date',
rental_records.end_date as 'end date'
from rental_records
inner join customers
on customers.customer_id = rental_records.customer_id
where rental_records.start_date between '2012-01-03' and '2012-01-18'
or  rental_records.end_date between '2012-01-03' and '2012-01-18'
or rental_records.start_date < '2012-01-03' and rental_records.end_date > '2012-01-18';

-- 8)List the vehicles (registration number, brand and description) available for rental (not rented out) on '2012-01-10'
select 
vehicles.veh_reg_no as 'registration number',
vehicles.brand as 'brand',
vehicles.desc as description
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no not in (
select veh_reg_no 
from rental_records 
where rental_records.start_date < '2012-01-10' 
and rental_records.end_date > '2012-01-10');

-- 9) list the vehicles available for rental for the period from '2012-01-03' to '2012-01-18'.
select 
vehicles.veh_reg_no as 'registration number',
vehicles.brand as 'brand',
vehicles.desc as description
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no not in  (
select veh_reg_no 
from rental_records 
where rental_records.start_date <'2012-01-03' 
or rental_records.end_date > '2012-01-03'
and rental_records.start_date < '2012-01-18'
and rental_records.end_date > '2012-01-18');

-- 10) list the vehicles available for rental from today for 10 days.
select distinct
vehicles.veh_reg_no as 'registration number',
vehicles.brand as 'brand',
vehicles.desc as description
from vehicles
left join rental_records
on vehicles.veh_reg_no = rental_records.veh_reg_no
where vehicles.veh_reg_no not in  (
select veh_reg_no 
from rental_records 
where rental_records.start_date between curdate() and date_add(curdate(), interval 10 day))
