create database behealthy;
use behealthy;

create table customer(
  cid int unsigned auto_increment,
  fname varchar(50) not null,
  mname varchar(50),
  lname varchar(50) not null,
  street varchar(50) not null,
  city varchar(50) not null,
  state varchar(50) not null,
  zip numeric(6,0) not null,
  sex enum('Male', 'Female') not null,
  dob date not null,
  email varchar(50),
  password varchar(50),
  phone_number numeric(10,0) not null,
  emergency_contact numeric(10,0),
  type enum('normal', 'prime', 'elite') default 'normal',
  created date default (current_date),
  age numeric(3,0) as (year(created) - year(dob)) not null,
  primary key (cid)
);
  
create table medicine_details(
  mid int unsigned auto_increment,
  name varchar(250) not null,
  generic_name varchar(250) not null,
  manufacturer varchar(250) not null,
  prescription_drug enum('yes', 'no') default 'no',
  net_dose numeric(6, 2) not null,
  discount_normal numeric(4,2) default 0.0,
  discount_prime numeric(4,2) default 0.0,
  discount_elite numeric(4,2) default 0.0,
  cautionary_note varchar(100),
  drug_type varchar(50),
  purpose varchar(50),
  adult_dose numeric(5, 2),
  child_dose numeric(5, 2),
  primary key (mid)
);

create table supplier(
  sid int unsigned auto_increment,
  name varchar(50) not null,
  street varchar(50) not null,
  city varchar(50) not null,
  state varchar(50) not null,
  zip numeric(6, 0) not null,
  phone_number numeric(10, 0) not null,
  license_no varchar(50) not null,
  license_expiry_date date not null,
  primary key (sid)
);

create table medicine_inventory(
  mid int unsigned not null,
  lot_number int unsigned not null,
  batch_number numeric(6, 0) not null,
  purchase_date date not null,
  mfg_date date not null,
  expiry_date date not null,
  sid int unsigned not null,
  quantity int unsigned not null,
  sold_quantity int unsigned not null,
  cost_price numeric(6,2) not null,
  mrp numeric(6, 2) not null,
  primary key (mid, lot_number),
  foreign key (mid) references medicine_details(mid),
  foreign key (sid) references supplier(sid)
);

create table cart_details(
  cid int unsigned not null,
  mid int unsigned not null,
  quantity int unsigned not null,
  primary key (cid, mid),
  foreign key (cid) references customer(cid),
  foreign key (mid) references medicine_details(mid)
);

create table invoice(
  bill_id int unsigned auto_increment,
  cid int unsigned not null,
  date datetime not null,
  net_amount numeric(8, 2) not null,
  net_discount numeric(8, 2) default 0.0,
  delivery_charges numeric(5, 2) not null,
  payment_status enum('paid', 'unpaid') not null,
  primary key (bill_id),
  foreign key (cid) references customer(cid)
);

create table invoice_details(
  bill_id int unsigned not null,
  mid int unsigned not null,
  lot_number int unsigned not null,
  quantity int unsigned not null,
  amount numeric(7, 2) not null,
  primary key (bill_id, mid, lot_number),
  foreign key (bill_id) references invoice(bill_id),
  foreign key (mid, lot_number) references medicine_inventory(mid, lot_number)
);

create table prescription(
  bill_id int unsigned not null,
  doctor_reg_no numeric(5, 0) not null,
  prescription_date date not null,
  primary key (bill_id),
  foreign key (bill_id) references invoice(bill_id)
);

create table prescription_details(
  bill_id int unsigned not null,
  mid int unsigned not null,
  quantity int unsigned not null,
  primary key (bill_id, mid),
  foreign key (bill_id) references invoice(bill_id),
  foreign key (mid) references medicine_details(mid)
);

create table supplier_medicine(
  sid int unsigned not null,
  mid int unsigned not null,
  last_purchase_price numeric (7, 2) not null,
  discount numeric(4,2) default 0.0,
  primary key (sid, mid),
  foreign key (sid) references supplier(sid),
  foreign key (mid) references medicine_details(mid)
);

create table supplier_order(
  soid int unsigned auto_increment,
  sid int unsigned not null,
  eid int unsigned not null,
  date datetime not null,
  net_amount numeric(11, 2) not null,
  status enum('pending', 'received') not null,
  primary key (soid),
  foreign key (sid) references supplier(sid),
  foreign key (eid) references customer(cid)
);

create table supplier_order_details(
  soid int unsigned not null,
  mid int unsigned not null,
  quantity int unsigned not null,
  purchase_rate numeric(7, 2) not null,
  primary key (soid, mid),
  foreign key (soid) references supplier_order(soid),
  foreign key (mid) references medicine_details(mid)
);

create table employee(
  eid int unsigned not null,
  role varchar(50) not null,
  qualification varchar(50) not null,
  experience varchar(100) not null,
  salary numeric(8, 2) not null,
  primary key (eid),
  foreign key (eid) references customer(cid)
);
