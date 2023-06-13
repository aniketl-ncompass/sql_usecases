use aniketlodh;
show tables;

drop table ROLES;

-- Inserting DATA 
create table EMPLOYEE(
emp_id varchar(4) primary key,
emp_name varchar(30),
department varchar(4),
active int,
gender varchar(10),
role_id varchar (4),
foreign key (department)
references DEPARTMENT (dept_id),
foreign key (role_id)
references ROLES (role_id)
);

create table DEPARTMENT (
dept_id varchar(4) primary key,
dept_name varchar(30)
);

create table ROLES(
role_id varchar(4) primary key,
role_name varchar(30)
);

create table REPORTING(
report_id varchar(4),
l2 varchar(10) default null,
l1 varchar(10) default null,
foreign key(report_id)
 references EMPLOYEE(emp_id)
);

create table EMP_ACTIVE_DATE(
emp_act_id varchar(4),
active_from date,
resigned_on date default null,
foreign key (emp_act_id)
references EMPLOYEE(emp_id)
);


INSERT INTO EMPLOYEE VALUES
	('E001', 'RAJKUMAR',  'D001', 1, 'M', 'R001'),
	('E002', 'GANESH',    'D001', 1, 'M', 'R002'),
	('E003', 'RAGHU',     'D001', 1, 'M', 'R003'),
	('E004', 'CHITRA',    'D001', 1, 'F', 'R001'),
	('E005', 'PRIYA',     'D001', 1, 'F', 'R002'),
	('E006', 'PREM KUMAR','D001', 1, 'M ','R003'),
	('E007', 'KRISHNA',   'D002', 1, 'M', 'R006'),
	('E008', 'PREETHI',   'D002', 1, 'F', 'R005'),
	('E009', 'RAVI',      'D002', 0, 'M', 'R004'),
	('E010', 'MEENA',     'D002', 1, 'F', 'R004');
select * from EMPLOYEE;
    
INSERT INTO ROLES  VALUES
	('R001', 'TEAM LEAD'),
	('R002', 'SR. DEVELOPER'),
	('R003', 'DEVLOPER'),
	('R004', 'MANAGER'),
	('R005', 'SR. MANAGER'),
	('R006', 'EXE. MANAGER');    
select * from ROLES;

INSERT INTO DEPARTMENT VALUES
	('D001', 'DEVELOPMENT'),
	('D002', 'HR');
select * from DEPARTMENT;

INSERT INTO REPORTING VALUES
	('E001', NULL, NULL),
	('E002', NULL, 'E001'),
	('E003', 'E002', 'E001'),
	('E004', NULL, NULL),
	('E005', NULL, 'E004'),
	('E006', 'E005', 'E004'),
	('E007', NULL, NULL),
	('E008', NULL, 'E007'),
	('E009', 'E008', 'E007'),
	('E010', 'E008', 'E007');
select * from REPORTING;

INSERT INTO EMP_ACTIVE_DATE VALUES
	('E001', '2015-01-02', NULL),
	('E002', '2016-03-01', NULL),
	('E003', '2018-01-02', NULL),
	('E004', '2014-11-01', NULL),
	('E005', '2015-02-01', NULL),
	('E006', '2019-01-02', NULL),
	('E007', '2013-01-02', NULL),
	('E008', '2015-01-02', NULL),
	('E009', '2017-11-05', '2020-10-31'),
	('E010', '2015-01-02', NULL);
select * from EMP_ACTIVE_DATE;



-- Q1 GET EMPLOYESS STRENGTH IN EACH DEPARTMENT 

select DEPARTMENT.dept_id as ID, DEPARTMENT.dept_name as DEPARTMENT,
 count(EMPLOYEE.department) as STRENGTH from DEPARTMENT
inner join EMPLOYEE on DEPARTMENT.dept_id = EMPLOYEE.department
group by DEPARTMENT.dept_id, DEPARTMENT.dept_name;



-- Q5 CALCULATE THE STRENGTH (IN RATIO) OF FEMALE EMPLOYEES IN EACH DEPARTMENT

select DEPARTMENT.dept_name as DEPARTMENT,
concat(count(case when EMPLOYEE.gender = "F" then 1 end )*100/count(EMPLOYEE.gender),"%") as RATIO
from DEPARTMENT
inner join EMPLOYEE 
where DEPARTMENT.dept_id=EMPLOYEE.department and EMPLOYEE.active = 1
group by DEPARTMENT.dept_name;


-- Q4 GET LIST OF ALL EMPLOYEES WHO HAS PART OF OUR TEAM FOR MORE THAN 1500 DAYS

select EMPLOYEE.emp_id as ID, EMPLOYEE.emp_name as EMPLOYEE,
 DATEDIFF(curdate(), EMP_ACTIVE_DATE.active_from) as DAYS
from EMPLOYEE
inner join EMP_ACTIVE_DATE
on EMP_ACTIVE_DATE.emp_act_id = EMPLOYEE.emp_id and EMP_ACTIVE_DATE.resigned_on is null
where  DATEDIFF(curdate(), EMP_ACTIVE_DATE.active_from) > 1560;


-- Q2 LIST EACH EMPLOYEES L2, L1 REPORTING SENIORS

select EMPLOYEE.emp_id as ID, EMPLOYEE.emp_name as EMPLOYEE,
 coalesce( (select EMPLOYEE.emp_name from EMPLOYEE where REPORTING.l2=EMPLOYEE.emp_id) ,"-") as L2,
 coalesce( (select EMPLOYEE.emp_name from EMPLOYEE where REPORTING.l1=EMPLOYEE.emp_id) ,"-")as L1
from EMPLOYEE
left join REPORTING
on EMPLOYEE.emp_id = REPORTING.report_id
where EMPLOYEE.active = 1;


-- Q3 PROVIDE DETAILED EMPLOYEE REPORT ALL EMPLOYEES

select EMPLOYEE.emp_id as ID, EMPLOYEE.emp_name as EMPLOYEE,
( select DEPARTMENT.dept_name from DEPARTMENT
 where  EMPLOYEE.department=DEPARTMENT.dept_id 
 ) as DEPARTMENT,
 ROLES.role_name as ROLE,
 case 
	when EMPLOYEE.active = 1 then "ACTIVE"
	else "RESIGNED"
end as STATUS,
 case 
	when EMPLOYEE.gender = 'M' then "MALE"
	else "FEMALE"
end as GENDER, 
concat(
	TIMESTAMPDIFF( year,  EMP_ACTIVE_DATE.active_from, CURRENT_DATE() ),' years ', 
	TIMESTAMPDIFF( month, EMP_ACTIVE_DATE.active_from, CURRENT_DATE() ) - TIMESTAMPDIFF( year, EMP_ACTIVE_DATE.active_from, CURRENT_DATE() )*12, ' months ', -- excluding the years.
	TIMESTAMPDIFF( DAY,  EMP_ACTIVE_DATE.active_from, CURRENT_DATE() )
    - TIMESTAMPDIFF( year, EMP_ACTIVE_DATE.active_from, CURRENT_DATE() )*365 -- excluding the years after converting it to dates.
    - (
		TIMESTAMPDIFF(month, EMP_ACTIVE_DATE.active_from,CURRENT_DATE())
        - TIMESTAMPDIFF(year,EMP_ACTIVE_DATE.active_from,CURRENT_DATE())*12
		)*30,' days '
)
 AS TERM
 from EMPLOYEE
 inner join ROLES
 on ROLES.role_id = EMPLOYEE.role_id
 inner join EMP_ACTIVE_DATE
 on EMP_ACTIVE_DATE.emp_act_id = EMPLOYEE.emp_id
 order by EMPLOYEE.emp_id asc;

