show databases;
use test; 
show tables;
SELECT * FROM customers;

/*
Create table Customers,Agent and Orders.
Use primary key for each tables and foreign keys for connecting the tables.								
*/
create table customers(
  cust_code varchar(10) PRIMARY KEY,
  cust_name varchar(20),
  cust_city varchar(50),
  phone_no varchar(10),
  agent_code varchar(10),
  FOREIGN KEY (agent_code) 
  REFERENCES agent(agent_code));
  
create table agent(
  agent_code varchar(10),
  agent_name varchar(20), 
  country varchar(40), 
  phone_no varchar(10), 
  agent_status int,
  primary key(agent_code));
  
create table orders(
  order_num varchar(10) primary key,
  cust_code varchar(10) not null,
  agent_code varchar(10) not null,
  amount float,
  order_date date,
  FOREIGN KEY (agent_code) 
  REFERENCES agent(agent_code),
  foreign key(cust_code)
  references customers(cust_code));
 
INSERT INTO  agent VALUES ('A001', 'Joe',	'Canada',	'2345623452',	0);
INSERT INTO  agent VALUES ('A002', 'Sara',	'India',	'1234567890',	1);
INSERT INTO  agent VALUES ('A003', 'Wiley',	'Bahamas',	'9876543217',	1);
INSERT INTO  agent (agent_code,agent_name,country,phone_no,agent_status) VALUES ('A004', 'Katniss','Ireland',	'3456543698',1);
INSERT INTO  agent VALUES ('A005', 'Arjun',	 'India',	'9844342345',	0);

INSERT INTO customers VALUES ('C001', 'Albert',	'Chennai',	'9798865876',	'A001');
INSERT INTO customers VALUES ('C002', 'Ravi',	'Bangalore','9876123456',	'A002');
INSERT INTO customers VALUES ('C003', 'Archana','Chennai',  '9452309812',	'A003');
INSERT INTO customers VALUES ('C004', 'Riya',	'Trichy',   '9612309876',	'A004');
INSERT INTO customers VALUES ('C005', 'Rahul',	'Pune',	    '6009164616',	'A005');
				
INSERT INTO orders  VALUES ('O001',	'C001',	'A001',	50000.5, '2021-05-24');
INSERT INTO orders  VALUES ('O002',	'C002',	'A002',	3000.35, '2021-03-26');
INSERT INTO orders  VALUES ('O003',	'C003',	'A003',	25000.1, '2021-01-21');
INSERT INTO orders  VALUES ('O004',	'C004',	'A004',	6000.5,  '2020-04-24');
INSERT INTO orders  VALUES ('O006',	'C005',	'A005',	100000.4,'2019-09-13');
 
-- Alter the table agent , Add a new Column called "Commission".			
alter table agent add commission float;
-- updating
update agent set commission = 0.2  where agent_code ='A001';
update agent set commission = 0.96 where agent_code ='A002';
update agent set commission = 0.23 where agent_code ='A003';
update agent set commission = 0.12 where agent_code ='A004';
update agent set commission = 0.76 where agent_code ='A005';

-- Delete the column Phone_No from the agents table.			
alter table agent drop phone_no;

-- Rename the Column "Commision" as "Commision_Percentage".			
alter table agent rename column commission to commissions_percentage;

-- Make a copy of agent table with a table name as "AGENT_DETAILS" and delete the old agent table with the name "AGENT" 							
create table agent_details as select * from agent;
insert into agent_details SELECT * FROM agent;

-- Delete all the order table records in a single command 			
delete from customers;

-- Alter the tables orders and set a default value for the column Amount				
ALTER TABLE orders modify COLUMN amount int default 10 NOT NULL;

select * from agent_details;
desc agent_details;
  
  
  
  