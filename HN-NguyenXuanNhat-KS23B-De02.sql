create database NXN;
use NXN;
-- Phan 2
-- 2.1
create table customers (
customer_id char(10) primary key,
customer_full_name varchar(150) not null,
customer_email varchar(255) unique,
customer_address varchar(255) not null
);
create table rooms (
room_id char(10) primary key,
room_price decimal(10,2),
room_status enum ("Trống","Đã đặt"),
room_area int 
);
create table bookings (
booking_id int auto_increment primary key,
customer_id char(10) not null,
room_id char(10) not null,
check_in_date date not null,
check_out_date date not null,
total_amount decimal(10,2),
foreign key (customer_id) references customers(customer_id),
foreign key (room_id) references rooms(room_id)
);
create table payments( 
payment_id int auto_increment primary key,
booking_id int not null,
payment_method varchar(50),
payment_date date not null,
payment_amount decimal(10,2),
foreign key (booking_id) references bookings(booking_id)
);
-- 2.2
alter table rooms
add column room_type enum("single","double","suite");
-- 2.3
alter table customers
add column customer_phone char(15) not null unique;
-- 2.4
alter table bookings
add constraint total_amount check(total_amount >= 0);
-- Phan 3
-- 3.1
insert into customers (customer_id,customer_full_name,customer_email,customer_phone,customer_address)
values
("C001","Nguyen Anh Tu","tu.nguyen@example.com","0912345678","HaNoi,VietNam"),
("C002","Tran Thi Mai","lan.tran@example.com","0923456789","HaNoi,VietNam"),
("C003","Le Minh Hoang","hoang.len@example.com","0934567890","HaNoi,VietNam"),
("C004","Pham Hoang Nam","nam.pham@example.com","0945678901","HaNoi,VietNam"),
("C005","Vu Minh Thu","thu.vu@example.com","0956789012","HaNoi,VietNam"),
("C006","Nguyen Thi Lan","lan.nguyen@example.com","0967890123","HaNoi,VietNam"),
("C007","Bui Minh Tuan","tuan.bui@example.com","0978901234","HaNoi,VietNam"),
("C008","Pham Quang Hieu","hieu.pham@example.com","0989012345","HaNoi,VietNam"),
("C009","Le Thi Lan","lan.le@example.com","0990123456","HaNoi,VietNam"),
("C010","Nguyen Thi Mai","mai.nguyen@example.com","0901234567","HaNoi,VietNam");

insert into rooms (room_id,room_type,room_price,room_status,room_area)
values
("R001","Single",100.0,"Trống",25),
("R002","Double",150.0,"Đã đặt",40),
("R003","Suite",250.0,"Trống",60),
("R004","Single",120.0,"Đã đặt",30),
("R005","Double",160.0,"Trống",35);
select *from rooms;

insert into bookings ( customer_id,room_id,check_in_date,check_out_date,total_amount)
values
("C001","R001","25-03-01","2025-03-05",400.0),
("C002","R002","25-03-02","2025-03-06",600.0),
("C003","R003","25-03-03","2025-03-07",1000.0),
("C004","R004","25-03-04","2025-03-08",480.0),
("C005","R005","25-03-05","2025-03-09",800.0),
("C006","R001","25-03-06","2025-03-10",400.0),
("C007","R002","25-03-07","2025-03-11",600.0),
("C008","R003","25-03-08","2025-03-12",1000.0),
("C009","R004","25-03-09","2025-03-13",480.0),
("C010","R005","25-03-10","2025-03-14",800.0);

insert into payments (booking_id,payment_method,payment_date,payment_amount)
values
(1,"Cash","25-03-05",400.00),
(2,"Credit Card","25-03-06",600.00),
(3,"Bank Tranfer","25-03-07",1000.00),
(4,"Cash","25-03-05",480.00),
(5,"Credit Card","25-03-09",800.00),
(6,"Bank Tranfer","25-03-10",400.00),
(7,"Cash","25-03-11",600.00),
(8,"Credit Card","25-03-12",1000.00),
(9,"Bank Tranfer","25-03-13",480.00),
(10,"Cash","25-03-14",800.00),
(1,"Credit Card","25-03-15",400.00),
(2,"Bank Tranfer","25-03-16",600.00),
(3,"Credit Card","25-03-17",1000.00),
(4,"Cash","25-03-18",480.00),
(5,"Bank Tranfer","25-03-19",800.00),
(6,"Cash","25-03-20",400.00),
(7,"Bank Tranfer","25-03-21",600.00),
(8,"Cash","25-03-22",1000.00),
(9,"Credit Card","25-03-23",480.00),
(10,"Bank Tranfer","25-03-24",800.00);
-- 3.2
UPDATE Bookings
JOIN Rooms ON Rooms.room_id = Bookings.room_id
SET Bookings.total_amount = Rooms.room_price * DATEDIFF(Bookings.check_out_date, Bookings.check_in_date)
WHERE room_status = 'Booked' AND Bookings.check_in_date < CURRENT_DATE();


select *from bookings;
-- 3.3
set sql_safe_updates = 0;
delete from payments
where payment_method = "Cash" and payment_amount < 500;
select *from payments;
-- Phan 4
-- 4.1
select
customers.customer_id as "Ma khach hang",
customers.customer_full_name as "Ten Khach Hang",
customers.customer_email as "Email",
customers.customer_phone as "So dien thoai",
customers.customer_address as "Dia chi"
from customers
order by customer_full_name asc;
-- 4.2
select 
room_id as "Ma phong",
room_type as "Loai phong",
room_price as "Gia phong",
room_area as "Dien tich"
from rooms
order by room_price desc;
-- 4.3
select 
customers.customer_id as "Ma Khach Hang",
customers.customer_full_name as "Ten Khach Hang",
rooms.room_id as "Ma Phong",
bookings.check_in_date as "Ngay dat phong",
bookings.check_out_date as "Ngay tra phong"
from customers
join bookings on bookings.customer_id = customers.customer_id
join rooms on rooms.room_id = bookings.room_id;
-- 4.4 
select
customers.customer_id as "Ma khach hang",
customers.customer_full_name as "Ten Khach Hang",
payments.payment_method as "Phuong thuc thanh toan",
payments.payment_amount as "So tien thanh toan"
from customers
join bookings on bookings.customer_id = customers.customer_id
join payments on payments.booking_id = bookings.booking_id
order by payments.payment_amount desc;
-- 4.5
select *from customers order by customer_full_name asc limit 3 offset 1;
-- 4.6 
select 
Bookings.customer_id, Customers.customer_full_name, count(Bookings.room_id) AS rooms_booked, sum(Bookings.total_amount) as total_spent
from Bookings
join Customers on Bookings.customer_id = Customers.customer_id
group by Bookings.customer_id
having count(Bookings.room_id) >= 1 and total_spent > 1000;
-- 4.7 
select
 rooms.room_id,rooms.room_type,
 rooms.room_price,
 sum(payments.payment_amount)as tong_tien_thanh_toan ,
 count(distinct(bookings.customer_id)) as so_khach_hang from rooms 
 join bookings on rooms.room_id=bookings.room_id
 join payments on bookings.booking_id=payments.booking_id
 group by rooms.room_id having tong_tien_thanh_toan<2000 and count(distinct (bookings.customer_id))>=3;
-- 4.8
select
customers.customer_id as "Ma khach hang",
customers.customer_full_name as "Ten khach hang",
bookings.room_id as "Ma phong",
sum(payments.payment_amount) as "TOng tien thanh toan"
from customers
join bookings on bookings.customer_id = customers.customer_id 
join payments on payments.booking_id = bookings.booking_id
group by customers.customer_id,customers.customer_full_name,bookings.room_id
having sum(payments.payment_amount) > 1000;
-- 4.9
with RoomBookingCounts as (
    select 
        Bookings.room_id, 
        Rooms.room_type, 
        count(Bookings.customer_id) as total_customers
    from Bookings 
    join Rooms  on Bookings.room_id = rooms.room_id
    group by Bookings.room_id, rooms.room_type
)
select * 
from RoomBookingCounts
where total_customers = (select max(total_customers) from RoomBookingCounts) or total_customers = (select min(total_customers) from RoomBookingCounts);

-- 4.10
with AvgRoomPayment as (
    select 
        Bookings.room_id, 
        avg(Payments.payment_amount) as avg_payment
    from Payments
    join Bookings on Payments.booking_id = Bookings.booking_id
    group by Bookings.room_id
)
select 
    Customers.customer_id, 
    Customers.customer_full_name, 
    Bookings.room_id, 
    sum(Payments.payment_amount) as total_paid
from Bookings
join Customers on Bookings.customer_id = Customers.customer_id
join Payments ON Bookings.booking_id = Payments.booking_id
join AvgRoomPayment ON Bookings.room_id = AvgRoomPayment.room_id
group by Customers.customer_id, Customers.customer_full_name, Bookings.room_id, AvgRoomPayment.avg_payment
having total_paid > AvgRoomPayment.avg_payment;
-- Phan 5
-- 5.1
create view getInforRooms as 
select 
rooms.room_id as "Ma phong",
rooms.room_type as "Loai phong",
customers.customer_id as "Ma khach hang",
customers.customer_full_name as "Ten khach hang"
from rooms
join bookings on bookings.room_id = rooms.room_id
join customers on customers.customer_id = bookings.customer_id
where bookings.check_in_date < "2025-03-10";
select *from getInforRooms;
-- 5.2
create view getInforRooms2 as 
select 
rooms.room_id as "Ma phong",
rooms.room_area as "Dien tich phong",
customers.customer_id as "Ma khach hang",
customers.customer_full_name as "Ten khach hang"
from rooms
join bookings on bookings.room_id = rooms.room_id
join customers on customers.customer_id = bookings.customer_id
where rooms.room_area > 30;
select *from getInforRooms2;
-- Phan 6
-- 6.1
delimiter &&
create trigger check_insert_booking after insert on bookings for each row
begin
if new.check_in_date > new.check_out_date then
	signal sqlstate '45000'
    set message_text = "Ngày đặt phòng không thể sau ngày trả phòng được !";
end if;
end ;
&&
delimiter &&;
insert into bookings ( customer_id,room_id,check_in_date,check_out_date,total_amount)
values
("C001","R001","2025-03-01","2025-06-01",400.0);
-- 6.2
delimiter &&
create trigger update_room_status_on_booking before insert on bookings for each row
begin
update rooms
set room_status = "Đã đặt"
where room_id = new.room_id;
end &&;
delimiter &&;
select *from rooms;
insert into bookings ( customer_id,room_id,check_in_date,check_out_date,total_amount)
values
("C013","R003","2025-03-01","2025-02-01",400.0);
-- Phan 7
-- 7.1
delimiter &&
create procedure add_customer (in p_customer_id char(10),in p_customer_full_name varchar(150),in p_customer_email varchar(255),in p_customer_phone varchar(20),p_customer_address varchar(255))
begin
insert into customers (customer_id,customer_full_name,customer_email,customer_phone,customer_address)
values(p_customer_id,p_customer_full_name,p_customer_email,p_customer_phone,p_customer_address);
end &&;
delimiter &&;
drop procedure add_customer;
call add_customer("C011","Nguyen Xuan Nhat","xuannhatvn2111@gmail.com","0399482205","HaiDuong.VietNam");
select *from customers;
-- 7.2
delimiter &&
create procedure add_payment (in p_booking_id int,p_payment_method varchar(50), p_payment_amount decimal(10,2), p_payment_date date)
begin
insert into payments (booking_id,payment_method,payment_date,payment_amount)
values (p_booking_id,p_payment_method,p_payment_date,p_payment_amount);
end &&;
delimiter &&;
drop procedure add_payment;
call add_payment ( 2,"Cast",500.00,"2025-03-24");
select *from payments;


