create table salesperson(
	seller_id serial primary key,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	phone_number VARCHAR(50),
	email VARCHAR(100)
);

create table mechanic(
	mechanic_id serial primary key,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(100),
	address VARCHAR(100),
	phone_number VARCHAR(50)
);

create table car(
	car_serial_number serial primary key,
	make VARCHAR(50),
	model VARCHAR(50),
	car_year VARCHAR(4),
	color VARCHAR(30),
	is_new BOOLEAN,
	car_payment_amount NUMERIC(8,2),
	seller_id INT,
	foreign key (seller_id) references salesperson(seller_id)
);

create table customer(
	customer_id serial primary key,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	phone_number VARCHAR(100),
	email VARCHAR(100),
	address VARCHAR(100),
	car_serial_number int,
	foreign key (car_serial_number) references car(car_serial_number)
);

create table service(
	service_id serial primary key,
	mechanic_id int,
	foreign key (mechanic_id) references mechanic(mechanic_id),
	car_serial_number int,
	foreign key (car_serial_number) references car(car_serial_number),
	service_payment_amount NUMERIC(8,2),
	service_description VARCHAR(500)
);

create table part(
	part_id serial primary key,
	service_id int,
	foreign key (service_id) references service(service_id),
	part_name VARCHAR(50),
	description VARCHAR(50),
	price NUMERIC(8,2),
	quantity INT
);

create table invoice(
	invoice_id serial primary key,
	invoice_date timestamp,
	seller_id int,
	foreign key (seller_id) references salesperson(seller_id),
	customer_id int,
	foreign key (customer_id) references customer(customer_id),
	car_serial_number int,
	foreign key (car_serial_number) references car(car_serial_number)
);

drop table invoice;
drop table part;
drop table service;
drop table customer;
drop table car;
drop table mechanic;
drop table salesperson;

-- Insert into salesperson
insert into salesperson (first_name, last_name, phone_number, email) values ('John', 'Jackson', '785-458-2312', 'jj@sales.com');
insert into salesperson (first_name, last_name, phone_number, email) values ('Bob', 'Smith', '123-234-1231', 'bs@sales.com');

-- Insert into mechanic
insert into mechanic (first_name, last_name, email, address, phone_number) values ('Jim', 'Jones', 'jj2@sales.com', '754 ford St.', '789-123-4567');
insert into mechanic (first_name, last_name, email, address, phone_number) values ('Ben', 'Jones', 'bj@dt.com', '694 main St.', '456-890-1011');

-- Insert into car
insert into car(make, model, car_year, color, is_new, car_payment_amount, seller_id) values ('toyota', 'camry', '2022', 'white', true, 20000, 1);
insert into car(make, model, car_year, color, is_new, car_payment_amount) values ('pontiac', 'g6', '2008', 'black', false, 15000);

-- Insert into customer
insert into customer (first_name, last_name, phone_number, email, address) values ('Bob', 'Smith', '888-234-1231', 'bs@sales.com', '456 Fake St.');
insert into customer (first_name, last_name, phone_number, email, address, car_serial_number) values ('Joe', 'Dirt', '888-555-1234', 'dt@dt.com', '123 Fake St.', 1);

-- Insert into service
insert into service (mechanic_id, car_serial_number, service_payment_amount, service_description) values(1, 2, 69.99, 'oil change');
insert into service (mechanic_id, car_serial_number, service_payment_amount, service_description) values(2, 1, 50.00, 'tire rotation');
insert into service (mechanic_id, car_serial_number, service_payment_amount, service_description) values(1, 2, 30.99, 'air filter change');

-- Insert into part
insert into part (service_id, part_name, description, price, quantity) values(1, 'oil filter', 'filter for engine oil', 6.99, 1);
insert into part (service_id, part_name, description, price, quantity) values(1, 'air filter', 'filter for air', 6.99, 1);

-- Insert into invoice
insert into invoice (invoice_date, seller_id, customer_id, car_serial_number) values(now(), 1, 1, 1);
insert into invoice (invoice_date, seller_id, customer_id, car_serial_number) values(now(), 2, 2, 2);

-- Insert into customer using stored procedure
create or replace procedure add_customer(
	_first_name VARCHAR(50),
	_last_name VARCHAR(50),
	_phone_number VARCHAR(100),
	_email VARCHAR(100),
	_address VARCHAR(100)
)
language plpgsql
as $$
begin 
	insert into customer(first_name, last_name, phone_number, email, address) values (_first_name, _last_name, _phone_number, _email, _address);
end;
$$;
create or replace procedure add_customer(
	_first_name VARCHAR(50),
	_last_name VARCHAR(50),
	_phone_number VARCHAR(100),
	_email VARCHAR(100),
	_address VARCHAR(100),
	_car_serial_number int
)
language plpgsql
as $$
begin 
	insert into customer(first_name, last_name, phone_number, email, address, car_serial_number) values (_first_name, _last_name, _phone_number, _email, _address, _car_serial_number);
end;
$$;

call add_customer('Walter', 'White', '999-555-1231', 'ww@fox.com', '123 Street st.');
call add_customer('Shrater', 'Hank', '999-555-5431', 'koh@fox.com', '123 Street st.', 1);

select * from customer;